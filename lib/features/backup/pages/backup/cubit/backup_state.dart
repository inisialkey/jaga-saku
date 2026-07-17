part of 'backup_cubit.dart';

/// State machine for the Backup & Restore screen. `idle` carries last-export
/// metadata (from `SettingsService`) for the "Last export …" line; `previewReady`
/// carries the validated payload plus its preview counts, gating the destructive
/// restore button.
@freezed
sealed class BackupState with _$BackupState {
  const factory BackupState.idle({int? lastExportedAt, int? lastItemCount}) =
      BackupIdle;

  const factory BackupState.exporting() = BackupExporting;

  const factory BackupState.exportSuccess() = BackupExportSuccess;

  const factory BackupState.validating() = BackupValidating;

  const factory BackupState.previewReady({
    required BackupPreview preview,
    required BackupData data,
  }) = BackupPreviewReady;

  const factory BackupState.restoring() = BackupRestoring;

  const factory BackupState.restoreSuccess(BackupPreview preview) =
      BackupRestoreSuccess;

  const factory BackupState.failure(Failure failure) = BackupFailureState;
}
