import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/backup/data/models/backup_serializer.dart';
import 'package:jaga_saku/features/backup/data/models/backup_validator.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_validation.dart';

void main() {
  const validator = BackupValidator();
  const serializer = BackupSerializer();

  // A referentially-sound minimal backup: 1 account, 1 category, 1 tx wiring both.
  BackupData validData() => const BackupData(
    accounts: [
      <String, Object?>{
        'id': 1,
        'name': 'Cash',
        'type': 'cash',
        'created_at': 0,
      },
    ],
    categories: [
      <String, Object?>{
        'id': 1,
        'name': 'Makan',
        'type': 'expense',
        'created_at': 0,
      },
    ],
    transactions: [
      <String, Object?>{
        'id': 1,
        'type': 'expense',
        'amount': 1000,
        'account_id': 1,
        'category_id': 1,
        'date': 0,
        'created_at': 0,
      },
    ],
  );

  String envelope(int schemaVersion, BackupData data) => serializer.encode(
    schemaVersion: schemaVersion,
    exportedAt: 123,
    data: data,
  );

  test('rejects non-JSON with notJson', () {
    final r = validator.validate('hello');
    expect(r.valid, isFalse);
    expect(r.reason, BackupValidationReason.notJson);
  });

  test('rejects a JSON object missing the envelope keys', () {
    expect(
      validator.validate('{}').reason,
      BackupValidationReason.missingEnvelope,
    );
  });

  test('rejects a schemaVersion newer than the app', () {
    expect(
      validator
          .validate(envelope(Migrations.latestVersion + 1, validData()))
          .reason,
      BackupValidationReason.unsupportedSchemaVersion,
    );
  });

  test('rejects a duplicate id within a table as corrupt', () {
    const data = BackupData(
      accounts: [
        <String, Object?>{
          'id': 1,
          'name': 'A',
          'type': 'cash',
          'created_at': 0,
        },
        <String, Object?>{
          'id': 1,
          'name': 'B',
          'type': 'cash',
          'created_at': 0,
        },
      ],
    );
    expect(
      validator.validate(envelope(Migrations.latestVersion, data)).reason,
      BackupValidationReason.corruptData,
    );
  });

  test('rejects a dangling foreign key as corrupt', () {
    const data = BackupData(
      accounts: [
        <String, Object?>{
          'id': 1,
          'name': 'A',
          'type': 'cash',
          'created_at': 0,
        },
      ],
      transactions: [
        <String, Object?>{
          'id': 1,
          'type': 'expense',
          'amount': 1,
          'account_id': 999, // no such account
          'date': 0,
          'created_at': 0,
        },
      ],
    );
    expect(
      validator.validate(envelope(Migrations.latestVersion, data)).reason,
      BackupValidationReason.corruptData,
    );
  });

  test('accepts an older schemaVersion (DB already migrated forward)', () {
    final r = validator.validate(
      envelope(Migrations.latestVersion - 1, validData()),
    );
    expect(r.valid, isTrue);
    expect(r.reason, BackupValidationReason.ok);
  });

  test('accepts a fully valid backup, exposing parsed data + exportedAt', () {
    final r = validator.validate(
      envelope(Migrations.latestVersion, validData()),
    );
    expect(r.valid, isTrue);
    expect(r.reason, BackupValidationReason.ok);
    expect(r.exportedAt, 123);
    expect(r.data, isNotNull);
    expect(r.data!.accounts, hasLength(1));
  });
}
