import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/budgets/data/datasources/budget_local_datasource.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../helpers/mocks.dart';

/// The V2-M1 migration tripwire: a live v6 database with a real `'YYYY-MM'`
/// budget must upgrade to v7 with its `[period_start, period_end)` backfilled to
/// the calendar-month bounds (no budget lost) and its spend UNCHANGED. Also
/// proves the backfill is idempotent under replay and that two budgets on one
/// category survive the new unique-index build.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  // `singleInstance: false` → a fresh in-memory DB per open (see schema_parity).
  Future<Database> openBlank() => databaseFactory.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(singleInstance: false),
  );

  // The pre-_v7 budgets shape. Between v1 and v6 the budgets TABLE is unchanged
  // (v2..v6 add other tables/columns/seeds, never a budget column), so the v1
  // baseline IS the pre-M1 budgets schema; `migrate(_, 6, 7)` then applies
  // exactly `_v7` (its `oldVersion < N` gates skip _v2.._v6). Staging from v1
  // also avoids _v6's system-category seed, keeping category ids free.
  Future<Database> openPreV7() async {
    final db = await openBlank();
    await Migrations.createV1(db);
    return db;
  }

  test(
    'v6→v7 backfills a YYYY-MM budget to its month range and keeps spend',
    () async {
      final db = await openPreV7();
      addTearDown(db.close);

      await db.insert('accounts', {
        'id': 1,
        'name': 'Cash',
        'type': 'cash',
        'created_at': 0,
      });
      await db.insert('categories', {
        'id': 1,
        'name': 'Makan',
        'type': 'expense',
        'created_at': 0,
      });
      final budgetId = await db.insert('budgets', {
        'category_id': 1,
        'period': '2026-03',
        'limit_amount': 500000,
        'created_at': 0,
      });
      // Two March expenses (inside the cycle) + one April expense (outside it).
      for (final (amount, date) in [
        (30000, DateTime(2026, 3, 10)),
        (20000, DateTime(2026, 3, 25)),
        (99000, DateTime(2026, 4, 2)),
      ]) {
        await db.insert('transactions', {
          'type': 'expense',
          'amount': amount,
          'account_id': 1,
          'category_id': 1,
          'date': date.millisecondsSinceEpoch,
          'created_at': 0,
        });
      }

      // The upgrade under test — the backfill runs inside _v7.
      await Migrations.migrate(db, 6, 7);

      final row = (await db.query(
        'budgets',
        where: 'id = ?',
        whereArgs: [budgetId],
      )).single;
      expect(row['period'], '2026-03'); // label KEPT
      expect(row['period_start'], DateTime(2026, 3).millisecondsSinceEpoch);
      expect(row['period_end'], DateTime(2026, 4).millisecondsSinceEpoch);

      // Spend still matches the March total — the range join excludes the April
      // tx exactly as the old strftime bucket did (backward-compat at start-day 1).
      final appDb = MockAppDatabase();
      when(() => appDb.db).thenReturn(db);
      final budgets = await BudgetLocalDatasource(
        appDb,
      ).getBudgetsForPeriod('2026-03');
      expect(budgets.single.spent, 50000); // 30k + 20k, not the April 99k
    },
  );

  test(
    'backfillBudgetRanges is idempotent — a replay never double-writes',
    () async {
      final db = await openPreV7();
      addTearDown(db.close);
      await db.insert('categories', {
        'id': 1,
        'name': 'Makan',
        'type': 'expense',
        'created_at': 0,
      });
      await db.insert('budgets', {
        'category_id': 1,
        'period': '2026-03',
        'limit_amount': 500000,
        'created_at': 0,
      });
      // Add the columns (the once-only ALTER half of _v7) so we can call the
      // factored-out backfill directly, twice, without re-running the ALTER.
      await db.execute('ALTER TABLE budgets ADD COLUMN period_start INTEGER;');
      await db.execute('ALTER TABLE budgets ADD COLUMN period_end INTEGER;');

      await Migrations.backfillBudgetRanges(db);
      final afterFirst = (await db.query('budgets')).single;
      await Migrations.backfillBudgetRanges(db); // replay
      final afterSecond = (await db.query('budgets')).single;

      expect(
        afterFirst['period_start'],
        DateTime(2026, 3).millisecondsSinceEpoch,
      );
      expect(
        afterFirst['period_end'],
        DateTime(2026, 4).millisecondsSinceEpoch,
      );
      expect(
        afterSecond,
        afterFirst,
      ); // stable — the WHERE-guard makes it a no-op
    },
  );

  test('two budgets on one category survive the unique-index build', () async {
    final db = await openPreV7();
    addTearDown(db.close);
    await db.insert('categories', {
      'id': 1,
      'name': 'Makan',
      'type': 'expense',
      'created_at': 0,
    });
    // Same category, adjacent months → distinct period_start after backfill, so
    // the UNIQUE INDEX(category_id, period_start) builds without conflict.
    await db.insert('budgets', {
      'category_id': 1,
      'period': '2026-03',
      'limit_amount': 100000,
      'created_at': 0,
    });
    await db.insert('budgets', {
      'category_id': 1,
      'period': '2026-04',
      'limit_amount': 200000,
      'created_at': 1,
    });

    await Migrations.migrate(db, 6, 7); // ALTER + backfill + unique index

    final rows = await db.query('budgets', orderBy: 'period');
    expect(rows, hasLength(2)); // neither budget lost
    expect(rows[0]['period_start'], DateTime(2026, 3).millisecondsSinceEpoch);
    expect(rows[1]['period_start'], DateTime(2026, 4).millisecondsSinceEpoch);
  });
}
