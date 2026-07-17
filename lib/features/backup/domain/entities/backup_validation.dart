import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';

part 'backup_validation.freezed.dart';

/// Outcome of checking a picked backup file before it can be restored.
enum BackupValidationReason {
  /// Envelope + integrity all pass — [BackupValidation.data] is populated.
  ok,

  /// Not parseable JSON (or not a JSON object).
  notJson,

  /// Parseable JSON but missing the required envelope keys.
  missingEnvelope,

  /// `schemaVersion` is newer than the running app can read (can't down-migrate).
  unsupportedSchemaVersion,

  /// Envelope is well-formed but the data fails integrity — a duplicate primary
  /// key within a table, or a foreign key that resolves to no parent row.
  corruptData,
}

/// Restore strategy. V3 ships exactly one — full replace; kept as an enum so a
/// future merge/append strategy is an additive change, not a refactor.
enum RestoreStrategy { fullReplace }

/// Result of `BackupValidator.validate`: whether the file is restorable, the
/// [reason], and — when valid — the parsed [data] plus its [exportedAt].
@freezed
abstract class BackupValidation with _$BackupValidation {
  const factory BackupValidation({
    required bool valid,
    required BackupValidationReason reason,
    BackupData? data,
    int? exportedAt,
  }) = _BackupValidation;
}
