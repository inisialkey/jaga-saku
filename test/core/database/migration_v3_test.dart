import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Dedicated v2→v3 upgrade guard: an existing v2 install must gain the
/// `tx_templates` table with the exact 13 columns of the V2-M2 favorites schema.
/// The `schema_parity_test` already proves fresh==migrated; this proves the step
/// itself (table absent at v2, present with the right shape after `migrate`).
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

  Future<Set<String>> tableNames(Database db) async {
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'",
    );
    return rows.map((r) => r['name']! as String).toSet();
  }

  test('the v2→v3 migration creates tx_templates with the exact columns', () async {
    final db = await openBlank();
    addTearDown(db.close);

    // A pre-v3 install has no tx_templates. `migrate` ignores `newVersion` (it
    // applies every step whose guard `oldVersion < N` holds — that is how
    // schema_parity replays everything via `migrate(1, latestVersion)`), so we
    // start from the v1 baseline and run only the v3 step via `migrate(2, 3)`
    // (oldVersion 2 skips `_v2`, runs `_v3`) to exercise the upgrade in isolation.
    await Migrations.createV1(db);
    expect(await tableNames(db), isNot(contains('tx_templates')));

    // The upgrade step under test.
    await Migrations.migrate(db, 2, 3);
    expect(await tableNames(db), contains('tx_templates'));

    final columns = await db.rawQuery('PRAGMA table_info(tx_templates)');
    final columnNames = columns.map((c) => c['name']! as String).toSet();
    expect(columnNames, <String>{
      'id',
      'label',
      'type',
      'amount',
      'account_id',
      'to_account_id',
      'category_id',
      'planned_status',
      'spending_type',
      'note',
      'is_favorite',
      'sort_order',
      'created_at',
    });
  });
}
