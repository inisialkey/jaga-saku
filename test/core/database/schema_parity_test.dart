import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Migration-path guard. The schema a fresh install builds (`onCreate`, which
/// replays every `_vN`) must be identical to the schema an existing install
/// reaches (`_v1` baseline + `migrate(…, 1, latestVersion)`).
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  // `singleInstance: false` forces a fresh, independent in-memory database per
  // open — the default (`true`) caches by path, so both opens would resolve to
  // the same `:memory:` handle and the second `_v1` would hit "table already
  // exists". No `version`/`onCreate` here, so lifecycle callbacks stay skipped.
  Future<Database> openBlank() => databaseFactory.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(singleInstance: false),
  );

  Future<Map<String, Object?>> dumpSchema(Database db) async {
    final master = await db.rawQuery(
      "SELECT type, name, sql FROM sqlite_master WHERE type IN ('table', 'index') AND name NOT LIKE 'sqlite_%' ORDER BY type, name",
    );
    final columns = <String, Object?>{};
    for (final row in master.where((r) => r['type'] == 'table')) {
      final table = row['name']! as String;
      columns[table] = await db.rawQuery('PRAGMA table_info($table)');
    }
    return <String, Object?>{'master': master, 'columns': columns};
  }

  test('fresh onCreate schema equals v1 + migrate schema', () async {
    final fresh = await openBlank();
    addTearDown(fresh.close);
    await Migrations.onCreate(fresh);

    final migrated = await openBlank();
    addTearDown(migrated.close);
    await Migrations.createV1(migrated);
    await Migrations.migrate(migrated, 1, Migrations.latestVersion);

    expect(await dumpSchema(migrated), equals(await dumpSchema(fresh)));
  });

  test('_v2/_v3 register the audit + tx_template indexes', () async {
    final db = await openBlank();
    addTearDown(db.close);
    await Migrations.onCreate(db);
    final indexes = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'index' AND name NOT LIKE 'sqlite_%'",
    );
    final names = indexes.map((r) => r['name']! as String).toSet();
    expect(
      names,
      containsAll(<String>[
        'idx_budget_period',
        'idx_cat_type',
        'idx_tpl_sort',
      ]),
    );
  });

  test('latestVersion is 4 so existing installs run the _v4 upgrade', () {
    expect(Migrations.latestVersion, 4);
  });
}
