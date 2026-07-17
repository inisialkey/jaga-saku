import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_preview.freezed.dart';

/// Per-table row counts shown before the user commits an irreversible restore,
/// plus the backup's [exportedAt]. Derived from a validated `BackupData` by the
/// pure `PreviewBackup` usecase.
@freezed
abstract class BackupPreview with _$BackupPreview {
  const factory BackupPreview({
    @Default(0) int accounts,
    @Default(0) int transactions,
    @Default(0) int categories,
    @Default(0) int budgets,
    @Default(0) int recurring,
    @Default(0) int templates,
    @Default(0) int settings,
    @Default(0) int exportedAt,
  }) = _BackupPreview;
}
