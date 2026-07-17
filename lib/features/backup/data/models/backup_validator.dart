import 'dart:convert';

import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/backup/data/models/backup_serializer.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_validation.dart';

/// Validates a picked backup file's raw JSON before it can be restored:
/// parse → envelope → `schemaVersion` → referential integrity. Pure + `const`
/// (no DI); the repository owns a `const BackupValidator()`.
class BackupValidator {
  const BackupValidator();

  static const BackupSerializer _serializer = BackupSerializer();

  BackupValidation validate(String rawJson) {
    // 1. Parse — anything unparseable (or not a JSON object) is not a backup.
    final Object? decoded;
    try {
      decoded = jsonDecode(rawJson);
    } on FormatException {
      return _fail(BackupValidationReason.notJson);
    }
    if (decoded is! Map<String, Object?>) {
      return _fail(BackupValidationReason.notJson);
    }

    // 2. Envelope — required keys present with the expected shapes.
    if (decoded['app'] == null ||
        decoded['schemaVersion'] is! int ||
        decoded['exportedAt'] is! int ||
        decoded['data'] is! Map) {
      return _fail(BackupValidationReason.missingEnvelope);
    }

    // 3. Schema — a NEWER backup can't be safely read (no down-migration); an
    // OLDER one is fine (the running DB is already migrated forward).
    final schemaVersion = decoded['schemaVersion']! as int;
    if (schemaVersion > Migrations.latestVersion) {
      return _fail(BackupValidationReason.unsupportedSchemaVersion);
    }

    // 4. Build the typed payload — reuse the parsed map (no second jsonDecode).
    final BackupData data;
    final int exportedAt;
    try {
      final record = _serializer.decodeEnvelope(decoded);
      data = record.data;
      exportedAt = record.exportedAt;
    } catch (_) {
      return _fail(BackupValidationReason.corruptData);
    }

    // 5. Integrity — duplicate primary keys or dangling foreign keys.
    if (!_integrityOk(data)) {
      return _fail(BackupValidationReason.corruptData);
    }

    return BackupValidation(
      valid: true,
      reason: BackupValidationReason.ok,
      data: data,
      exportedAt: exportedAt,
    );
  }

  BackupValidation _fail(BackupValidationReason reason) =>
      BackupValidation(valid: false, reason: reason);

  /// True when no table has a duplicate primary key AND every foreign key value
  /// resolves to a parent row within the same backup.
  bool _integrityOk(BackupData d) {
    if (_hasDupKey(d.settings, 'key')) return false;
    for (final rows in [
      d.accounts,
      d.categories,
      d.transactions,
      d.budgets,
      d.txTemplates,
      d.recurring,
    ]) {
      if (_hasDupKey(rows, 'id')) return false;
    }

    final accountIds = _ids(d.accounts);
    final categoryIds = _ids(d.categories);
    final templateIds = _ids(d.txTemplates);

    for (final r in d.categories) {
      if (!_refOk(r['parent_id'], categoryIds)) return false;
    }
    for (final r in d.transactions) {
      if (!_refOk(r['account_id'], accountIds)) return false;
      if (!_refOk(r['to_account_id'], accountIds)) return false;
      if (!_refOk(r['category_id'], categoryIds)) return false;
    }
    for (final r in d.budgets) {
      if (!_refOk(r['category_id'], categoryIds)) return false;
    }
    for (final r in d.txTemplates) {
      if (!_refOk(r['account_id'], accountIds)) return false;
      if (!_refOk(r['to_account_id'], accountIds)) return false;
      if (!_refOk(r['category_id'], categoryIds)) return false;
    }
    for (final r in d.recurring) {
      if (!_refOk(r['template_id'], templateIds)) return false;
    }
    return true;
  }

  Set<Object?> _ids(List<Map<String, Object?>> rows) =>
      rows.map((r) => r['id']).toSet();

  bool _hasDupKey(List<Map<String, Object?>> rows, String key) =>
      rows.map((r) => r[key]).toSet().length != rows.length;

  /// A foreign key is OK when it is null (no reference) or resolves to a parent.
  bool _refOk(Object? fk, Set<Object?> parentIds) =>
      fk == null || parentIds.contains(fk);
}
