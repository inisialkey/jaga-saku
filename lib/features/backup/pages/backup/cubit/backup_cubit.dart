import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/core/utils/services/backup_file_service.dart';
import 'package:jaga_saku/core/utils/services/settings/settings_service.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_preview.dart';
import 'package:jaga_saku/features/backup/domain/usecases/export_backup.dart';
import 'package:jaga_saku/features/backup/domain/usecases/preview_backup.dart';
import 'package:jaga_saku/features/backup/domain/usecases/restore_backup.dart';
import 'package:jaga_saku/features/backup/domain/usecases/validate_backup.dart';
import 'package:jaga_saku/features/reminders/data/reminder_service.dart';
import 'package:jaga_saku/features/security/app_lock_service.dart';

part 'backup_cubit.freezed.dart';
part 'backup_state.dart';

/// Drives the Backup & Restore screen: export (→ file → share sheet), pick +
/// validate (→ preview), and the destructive restore (safety-backup → atomic
/// full-replace → live refresh). A successful restore also reloads the three
/// in-memory settings holders it just invalidated on disk (V4-M2), so the app
/// reflects the restored data without a relaunch. Every emit after an `await` is
/// guarded by [isClosed]; there is no stream subscription, so [close] needs no
/// override.
class BackupCubit extends Cubit<BackupState> {
  BackupCubit({
    required ExportBackup exportBackup,
    required ValidateBackup validateBackup,
    required PreviewBackup previewBackup,
    required RestoreBackup restoreBackup,
    required BackupFileService backupFileService,
    required SettingsService settingsService,
    required AppSettingsCubit appSettings,
    required AppLockService appLock,
    required ReminderService reminderService,
  }) : _exportBackup = exportBackup,
       _validateBackup = validateBackup,
       _previewBackup = previewBackup,
       _restoreBackup = restoreBackup,
       _fileService = backupFileService,
       _settings = settingsService,
       _appSettings = appSettings,
       _appLock = appLock,
       _reminderService = reminderService,
       super(const BackupState.idle());

  final ExportBackup _exportBackup;
  final ValidateBackup _validateBackup;
  final PreviewBackup _previewBackup;
  final RestoreBackup _restoreBackup;
  final BackupFileService _fileService;
  final SettingsService _settings;

  /// The in-memory settings holders a restore invalidates (V4-M2) — all
  /// app-global singletons, so reloading them is independent of this cubit's
  /// own lifecycle.
  final AppSettingsCubit _appSettings;
  final AppLockService _appLock;
  final ReminderService _reminderService;

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
      // Record the export BEFORE handing off to the share sheet: once `write`
      // returns, the backup exists on disk and "last exported" is true. Sharing
      // after meant a share-sheet throw left the file written but the metadata
      // unwritten — the user saw a failure toast while "Last export" still read
      // never, even though a valid backup was sitting in app-docs.
      await _settings.setString(_kLastExportedAt, file.exportedAt.toString());
      await _settings.setString(_kLastItemCount, file.itemCount.toString());
      await _fileService.share(path);
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
    emit(BackupState.restoreSuccess(result.getRight().toNullable()!));

    // V4-M2: the restore rewrote the settings table under the running app —
    // reload every in-memory holder so theme/locale/name, the lock gate, and the
    // scheduled reminders reflect the restored data live (no relaunch). These
    // act on the app-global singletons, so BackupCubit's own lifecycle doesn't
    // gate them. `_appSettings.load()` also re-emits the restored cycle
    // start-day, which re-windows Home / BudgetList through their subscription.
    // Each is isolated: they are independent holders, so one failing must not
    // cost the other two their refresh (that would be the staleness this fix
    // exists to remove).
    await _reloadAfterRestore('app settings', _appSettings.load);
    await _reloadAfterRestore('lock config', _appLock.refreshConfig);
    await _reloadAfterRestore('reminder schedules', _reminderService.reconcile);

    await loadMeta();
  }

  /// Runs one post-restore reload, logging rather than rethrowing. The restore
  /// has already committed and `restoreSuccess` is already emitted, so a failed
  /// reload costs freshness in ONE holder — never data. It must not take the
  /// other reloads or [loadMeta] down with it, and it must not escape: the page
  /// calls [restore] un-awaited, so a throw would surface as an unhandled async
  /// error. The realistic thrower is `reconcile()`'s MethodChannel / `tz` seam.
  Future<void> _reloadAfterRestore(
    String what,
    Future<void> Function() reload,
  ) async {
    try {
      await reload();
    } catch (e, s) {
      log.e('Post-restore reload failed: $what', error: e, stackTrace: s);
    }
  }

  String _exportFileName(int millis) =>
      'jaga-saku-backup-${_stamp('yyyyMMdd-HHmm', millis)}.json';

  String _safetyFileName(int millis) =>
      'jaga-saku-safety-${_stamp('yyyyMMdd-HHmmss', millis)}.json';

  String _stamp(String pattern, int millis) =>
      DateFormat(pattern).format(DateTime.fromMillisecondsSinceEpoch(millis));
}
