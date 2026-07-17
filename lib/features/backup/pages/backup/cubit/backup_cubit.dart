import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/core/utils/services/backup_file_service.dart';
import 'package:jaga_saku/core/utils/services/settings/settings_service.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_preview.dart';
import 'package:jaga_saku/features/backup/domain/usecases/export_backup.dart';
import 'package:jaga_saku/features/backup/domain/usecases/preview_backup.dart';
import 'package:jaga_saku/features/backup/domain/usecases/restore_backup.dart';
import 'package:jaga_saku/features/backup/domain/usecases/validate_backup.dart';

part 'backup_cubit.freezed.dart';
part 'backup_state.dart';

/// Drives the Backup & Restore screen: export (→ file → share sheet), pick +
/// validate (→ preview), and the destructive restore (safety-backup → atomic
/// full-replace → live refresh). Every emit after an `await` is guarded by
/// [isClosed]; there is no stream subscription, so [close] needs no override.
class BackupCubit extends Cubit<BackupState> {
  BackupCubit({
    required ExportBackup exportBackup,
    required ValidateBackup validateBackup,
    required PreviewBackup previewBackup,
    required RestoreBackup restoreBackup,
    required BackupFileService backupFileService,
    required SettingsService settingsService,
    required TxChangeNotifier txChangeNotifier,
  }) : _exportBackup = exportBackup,
       _validateBackup = validateBackup,
       _previewBackup = previewBackup,
       _restoreBackup = restoreBackup,
       _fileService = backupFileService,
       _settings = settingsService,
       _txChanges = txChangeNotifier,
       super(const BackupState.idle());

  final ExportBackup _exportBackup;
  final ValidateBackup _validateBackup;
  final PreviewBackup _previewBackup;
  final RestoreBackup _restoreBackup;
  final BackupFileService _fileService;
  final SettingsService _settings;
  final TxChangeNotifier _txChanges;

  static const String _kLastExportedAt = 'backup.lastExportedAt';
  static const String _kLastItemCount = 'backup.lastItemCount';

  /// Loads the last-export metadata into [BackupState.idle] — called on route
  /// build and after every successful export/restore.
  Future<void> loadMeta() async {
    final at = await _settings.getString(_kLastExportedAt);
    final count = await _settings.getString(_kLastItemCount);
    if (isClosed) return;
    emit(
      BackupState.idle(
        lastExportedAt: at == null ? null : int.tryParse(at),
        lastItemCount: count == null ? null : int.tryParse(count),
      ),
    );
  }

  /// Export → write the file → open the share sheet → persist last-export meta.
  Future<void> exportBackup() async {
    emit(const BackupState.exporting());
    final result = await _exportBackup(NoParams());
    if (isClosed) return;
    if (result.isLeft()) {
      emit(BackupState.failure(result.getLeft().toNullable()!));
      return;
    }
    final file = result.getRight().toNullable()!;
    try {
      final path = await _fileService.write(
        _exportFileName(file.exportedAt),
        file.content,
      );
      await _fileService.share(path);
      await _settings.setString(_kLastExportedAt, file.exportedAt.toString());
      await _settings.setString(_kLastItemCount, file.itemCount.toString());
    } catch (e, s) {
      log.e('Backup export delivery failed', error: e, stackTrace: s);
      if (isClosed) return;
      emit(const BackupState.failure(BackupFailure(BackupFailureReason.io)));
      return;
    }
    if (isClosed) return;
    emit(const BackupState.exportSuccess());
    await loadMeta();
  }

  /// Pick a file → read → validate → preview. A cancelled pick stays idle.
  Future<void> pickAndValidate() async {
    final path = await _fileService.pickJson();
    if (isClosed) return;
    if (path == null) return; // user cancelled the picker
    emit(const BackupState.validating());
    final String raw;
    try {
      raw = await _fileService.read(path);
    } catch (e, s) {
      log.e('Backup read failed', error: e, stackTrace: s);
      if (isClosed) return;
      emit(const BackupState.failure(BackupFailure(BackupFailureReason.io)));
      return;
    }
    final result = await _validateBackup(raw);
    if (isClosed) return;
    if (result.isLeft()) {
      emit(BackupState.failure(result.getLeft().toNullable()!));
      return;
    }
    final data = result.getRight().toNullable()!;
    emit(BackupState.previewReady(preview: _previewBackup(data), data: data));
  }

  /// Destructive restore — only valid from [BackupPreviewReady]. Writes a safety
  /// backup FIRST (aborting without touching the DB if that write fails), then
  /// runs the atomic full-replace and pings every derived view to refresh live.
  Future<void> restore() async {
    final current = state;
    if (current is! BackupPreviewReady) return;
    final data = current.data;
    emit(const BackupState.restoring());

    // 1. Safety backup of the CURRENT db, written before anything is destroyed.
    final safety = await _exportBackup(NoParams());
    if (isClosed) return;
    if (safety.isLeft()) {
      emit(BackupState.failure(safety.getLeft().toNullable()!));
      return;
    }
    try {
      final safetyFile = safety.getRight().toNullable()!;
      await _fileService.write(
        _safetyFileName(safetyFile.exportedAt),
        safetyFile.content,
      );
    } catch (e, s) {
      log.e('Safety backup failed — restore aborted', error: e, stackTrace: s);
      if (isClosed) return;
      emit(const BackupState.failure(BackupFailure(BackupFailureReason.io)));
      return; // never destroy without a safety net
    }

    // 2. Atomic full-replace.
    final result = await _restoreBackup(data);
    if (isClosed) return;
    if (result.isLeft()) {
      emit(BackupState.failure(result.getLeft().toNullable()!));
      return;
    }
    // 3. Refresh every derived money view (Home/Calendar/Insight/Budget/…).
    _txChanges.ping();
    emit(BackupState.restoreSuccess(result.getRight().toNullable()!));
    await loadMeta();
  }

  String _exportFileName(int millis) =>
      'jaga-saku-backup-${_stamp('yyyyMMdd-HHmm', millis)}.json';

  String _safetyFileName(int millis) =>
      'jaga-saku-safety-${_stamp('yyyyMMdd-HHmmss', millis)}.json';

  String _stamp(String pattern, int millis) =>
      DateFormat(pattern).format(DateTime.fromMillisecondsSinceEpoch(millis));
}
