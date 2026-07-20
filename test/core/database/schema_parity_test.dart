import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/core/utils/services/settings/settings_keys.dart';
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

  test(
    '_v2/_v3/_v5 register the audit + tx_template + recurring indexes',
    () async {
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
          'idx_recurring_due',
        ]),
      );
    },
  );

  test('latestVersion is 8 so existing installs run the v8 grandfather', () {
    expect(Migrations.latestVersion, 8);
  });

  // v8 is a migrate-ONLY data marker (V5-M1). Replaying it under onCreate would
  // mark every fresh install as already-onboarded and defeat the milestone.
  test(
    'onCreate leaves NO onboarding marker — a fresh install onboards',
    () async {
      final db = await openBlank();
      addTearDown(db.close);
      await Migrations.onCreate(db);

      final rows = await db.query(
        'settings',
        where: 'key = ?',
        whereArgs: [SettingsKeys.onboardingCompleted],
      );
      expect(rows, isEmpty);
    },
  );

  test(
    'migrate 7→8 grandfathers an existing install past onboarding',
    () async {
      final db = await openBlank();
      addTearDown(db.close);
      await Migrations.createV1(db);
      await Migrations.migrate(db, 1, Migrations.latestVersion);

      final rows = await db.query(
        'settings',
        where: 'key = ?',
        whereArgs: [SettingsKeys.onboardingCompleted],
      );
      expect(rows.single['value'], '1');
    },
  );

  test('grandfatherOnboarding is idempotent', () async {
    final db = await openBlank();
    addTearDown(db.close);
    await Migrations.onCreate(db);

    await Migrations.grandfatherOnboarding(db);
    await Migrations.grandfatherOnboarding(db);

    final rows = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [SettingsKeys.onboardingCompleted],
    );
    expect(rows, hasLength(1));
  });

  test('_v6 adds categories.system_key on the fresh (onCreate) path', () async {
    final db = await openBlank();
    addTearDown(db.close);
    await Migrations.onCreate(db);
    final cols = (await db.rawQuery(
      'PRAGMA table_info(categories)',
    )).map((c) => c['name']).toSet();
    expect(cols, contains('system_key'));
  });

  test(
    '_v7 adds budgets.period_start/period_end + the unique index (fresh path)',
    () async {
      final db = await openBlank();
      addTearDown(db.close);
      await Migrations.onCreate(db);

      final cols = (await db.rawQuery(
        'PRAGMA table_info(budgets)',
      )).map((c) => c['name']).toSet();
      expect(cols, containsAll(<String>['period_start', 'period_end']));

      final indexes = (await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'index' AND name NOT LIKE 'sqlite_%'",
      )).map((r) => r['name']! as String).toSet();
      expect(indexes, contains('idx_budget_cat_start'));
    },
  );
}
