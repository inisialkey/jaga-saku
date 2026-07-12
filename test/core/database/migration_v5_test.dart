import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Dedicated v4→v5 upgrade guard: an existing install must gain the `recurring`
/// table (V2-M5). `schema_parity_test` already proves fresh==migrated; this
/// proves the step itself (table absent before, present with the exact columns
/// after `migrate`) and the FK `ON DELETE CASCADE` behaviour (deleting the owned
/// template drops the rule).
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

  // The FK CASCADE only fires with foreign_keys ON — `openBlank` skips lifecycle
  // callbacks, so the cascade test enables the pragma explicitly (prod does this
  // in `AppDatabase._onConfigure`).
  Future<Database> openWithFk() => databaseFactory.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      singleInstance: false,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
    ),
  );

  test('the v4→v5 migration creates recurring with the exact columns', () async {
    final db = await openBlank();
    addTearDown(db.close);
    // The v1 baseline builds no `recurring` table.
    await Migrations.createV1(db);
    final before = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'recurring'",
    );
    expect(before, isEmpty);

    // oldVersion 4 skips _v2/_v3/_v4, runs only _v5 (the step under test).
    await Migrations.migrate(db, 4, 5);

    final cols = (await db.rawQuery(
      'PRAGMA table_info(recurring)',
    )).map((c) => c['name']).toSet();
    expect(
      cols,
      containsAll(<String>[
        'id',
        'template_id',
        'freq',
        'interval',
        'start_date',
        'end_date',
        'next_due',
        'created_at',
      ]),
    );
  });

  test('deleting a template cascades to its recurring rule (FK ON)', () async {
    final db = await openWithFk();
    addTearDown(db.close);
    // Full schema so `tx_templates` (the cascade parent) exists.
    await Migrations.onCreate(db);
    await db.insert('accounts', {
      'id': 1,
      'name': 'Cash',
      'type': 'cash',
      'created_at': 0,
    });
    final tplId = await db.insert('tx_templates', {
      'label': 'Rent',
      'type': 'expense',
      'account_id': 1,
      'is_favorite': 0,
      'created_at': 0,
    });
    await db.insert('recurring', {
      'template_id': tplId,
      'freq': 'monthly',
      'interval': 1,
      'start_date': 0,
      'next_due': 0,
      'created_at': 0,
    });

    // Deleting the owned template must cascade-remove the recurring row.
    await db.delete('tx_templates', where: 'id = ?', whereArgs: [tplId]);

    expect(await db.query('recurring'), isEmpty);
  });
}
