import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/backup/data/models/backup_serializer.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';

/// Representative rows covering every value-shape the backup must preserve:
/// int money, int-1/0 bool flags, null cells, ARGB color ints, explicit ids and
/// dotted settings keys. Typed `<String, Object?>` so heterogeneous rows keep
/// their column value types through the JSON round-trip.
BackupData _sampleData() => const BackupData(
  settings: [
    <String, Object?>{'key': 'theme', 'value': 'dark'},
    <String, Object?>{'key': 'locale', 'value': 'id'},
    <String, Object?>{'key': 'budget.cycleStartDay', 'value': '25'},
  ],
  accounts: [
    <String, Object?>{
      'id': 1,
      'name': 'Cash',
      'type': 'cash',
      'opening_balance': 50000,
      'icon': null,
      'color': 0xFF16A34A,
      'sort_order': 0,
      'archived': 0,
      'created_at': 100,
    },
  ],
  categories: [
    <String, Object?>{
      'id': 1,
      'name': 'Makan',
      'type': 'expense',
      'parent_id': null,
      'color': 0xFFEF4444,
      'system_key': null,
      'created_at': 100,
    },
  ],
  transactions: [
    <String, Object?>{
      'id': 1,
      'type': 'expense',
      'amount': 12500,
      'account_id': 1,
      'to_account_id': null,
      'category_id': 1,
      'date': 200,
      'note': null,
      'receipt_path': null,
      'created_at': 200,
    },
  ],
  budgets: [
    <String, Object?>{
      'id': 1,
      'category_id': 1,
      'period': '2026-07',
      'limit_amount': 1000000,
      'period_start': 300,
      'period_end': 400,
      'created_at': 100,
    },
  ],
  txTemplates: [
    <String, Object?>{
      'id': 1,
      'label': 'Kopi',
      'type': 'expense',
      'amount': 20000,
      'account_id': 1,
      'category_id': 1,
      'is_favorite': 1,
      'sort_order': 0,
      'created_at': 100,
    },
  ],
  recurring: [
    <String, Object?>{
      'id': 1,
      'template_id': 1,
      'freq': 'monthly',
      'interval': 1,
      'start_date': 500,
      'end_date': null,
      'next_due': 600,
      'created_at': 100,
    },
  ],
);

void main() {
  const serializer = BackupSerializer();

  test('encode → decode round-trips schemaVersion, exportedAt and data', () {
    final data = _sampleData();
    final record = serializer.decode(
      serializer.encode(
        schemaVersion: 7,
        exportedAt: 1700000000000,
        data: data,
      ),
    );

    expect(record.schemaVersion, 7);
    expect(record.exportedAt, 1700000000000);
    // Freezed's DeepCollectionEquality over the row lists → structural equality.
    expect(record.data, data);
  });

  test('preserves int money, int-1/0 bools, nulls, ARGB colors and ids', () {
    final decoded = serializer
        .decode(
          serializer.encode(
            schemaVersion: 7,
            exportedAt: 1,
            data: _sampleData(),
          ),
        )
        .data;

    // Money stays int (never a double / string).
    expect(decoded.transactions.single['amount'], 12500);
    expect(decoded.transactions.single['amount'], isA<int>());
    // int-1/0 flag stays int — NOT coerced to a Dart bool.
    expect(decoded.txTemplates.single['is_favorite'], 1);
    expect(decoded.txTemplates.single['is_favorite'], isA<int>());
    // Nullable cells preserved as null.
    expect(decoded.transactions.single['to_account_id'], isNull);
    expect(decoded.accounts.single['icon'], isNull);
    // ARGB color int preserved exactly, explicit primary-key id preserved.
    expect(decoded.accounts.single['color'], 0xFF16A34A);
    expect(decoded.accounts.single['id'], 1);
    // Dotted settings key survives (a runtime value string, not an ARB key).
    expect(
      decoded.settings.map((r) => r['key']),
      containsAll(<String>['theme', 'budget.cycleStartDay']),
    );
  });

  test('a missing table key decodes to an empty list (tolerant)', () {
    const json =
        '{"app":"Jaga Saku","schemaVersion":7,"exportedAt":1,"data":{"accounts":[]}}';
    final decoded = serializer.decode(json).data;

    expect(decoded.accounts, isEmpty);
    expect(decoded.transactions, isEmpty);
    expect(decoded.recurring, isEmpty);
  });
}
