import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Dedicated v3→v4 upgrade guard: an existing install must gain the nullable
/// `transactions.receipt_path` column (V2-M4). `schema_parity_test` already
/// proves fresh==migrated; this proves the step itself (column absent before,
/// present after `migrate`) and that existing rows default to NULL.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  // `singleInstance: false` so each open is a fresh, independent in-memory DB.
  Future<Database> openBlank() => databaseFactory.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(singleInstance: false),
  );

  test('the v3→v4 migration adds receipt_path (existing rows NULL)', () async {
    final db = await openBlank();
    addTearDown(db.close);
    // The v1 baseline builds `transactions` without receipt_path.
    await Migrations.createV1(db);
    await db.insert('accounts', {
      'id': 1,
      'name': 'Cash',
      'type': 'cash',
      'created_at': 0,
    });
    await db.insert('transactions', {
      'type': 'expense',
      'amount': 1000,
      'account_id': 1,
      'date': 0,
      'created_at': 0,
    });
    final before = await db.rawQuery('PRAGMA table_info(transactions)');
    expect(before.map((c) => c['name']), isNot(contains('receipt_path')));

    // oldVersion 3 skips _v2/_v3, runs only _v4 (the step under test).
    await Migrations.migrate(db, 3, 4);

    final after = await db.rawQuery('PRAGMA table_info(transactions)');
    expect(after.map((c) => c['name']), contains('receipt_path'));
    // The pre-existing row keeps its data and defaults the new column to NULL.
    final rows = await db.query('transactions');
    expect(rows.single['amount'], 1000);
    expect(rows.single['receipt_path'], isNull);
  });
}
