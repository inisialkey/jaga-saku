import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/core/database/seed.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// M0 DB smoke test: opens an in-memory database via sqflite_common_ffi, runs
/// the v1 schema + seed exactly as `AppDatabase._onCreate` does, and asserts
/// the default rows exist and the schema is queryable.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<Database> openSeeded() => databaseFactory.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      version: Migrations.latestVersion,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, _) async {
        await Migrations.onCreate(db);
        await Seed.run(db);
      },
    ),
  );

  test('creates all v1 tables', () async {
    final db = await openSeeded();
    addTearDown(db.close);

    final tables = await db.query(
      'sqlite_master',
      columns: ['name'],
      where: 'type = ?',
      whereArgs: ['table'],
    );
    final names = tables.map((r) => r['name']! as String).toSet();

    expect(
      names,
      containsAll(<String>[
        'settings',
        'accounts',
        'categories',
        'transactions',
        'budgets',
      ]),
    );
  });

  test(
    'seeds NO accounts — onboarding owns the first account (V5-M1)',
    () async {
      final db = await openSeeded();
      addTearDown(db.close);

      expect(await db.query('accounts'), isEmpty);
    },
  );

  test('seeds expense + income categories with colors', () async {
    final db = await openSeeded();
    addTearDown(db.close);

    final expense = await db.query(
      'categories',
      where: 'type = ?',
      whereArgs: ['expense'],
      orderBy: 'sort_order',
    );
    expect(
      expense.map((r) => r['name']),
      containsAllInOrder(<String>[
        'Makan',
        'Transport',
        'Kopi',
        'Belanja',
        'Hiburan',
        'Lainnya',
      ]),
    );
    // Every expense category has a donut color assigned.
    expect(expense.every((r) => r['color'] != null), isTrue);

    final income = await db.query(
      'categories',
      where: 'type = ?',
      whereArgs: ['income'],
      orderBy: 'sort_order',
    );
    expect(
      income.map((r) => r['name']),
      containsAll(<String>['Gaji', 'Lainnya']),
    );
  });

  test('SettingsService KV round-trips via the settings table', () async {
    final db = await openSeeded();
    addTearDown(db.close);

    await db.insert('settings', {'key': 'theme', 'value': 'light'});
    final rows = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['theme'],
    );
    expect(rows.single['value'], 'light');
  });
}
