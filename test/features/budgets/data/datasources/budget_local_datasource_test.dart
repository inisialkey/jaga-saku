import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/budgets/data/datasources/budget_local_datasource.dart';
import 'package:jaga_saku/features/budgets/data/models/budget_model.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../helpers/mocks.dart';

/// Exercises [BudgetLocalDatasource] against a real in-memory sqflite (ffi)
/// database. The headline check: the SQL `spent` join buckets a transaction into
/// exactly the period `periodKey` derives for the same date — proven at a month
/// boundary so a tz-off-by-one would fail loudly.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late BudgetLocalDatasource datasource;

  BudgetModel budgetModel({
    required int categoryId,
    required String period,
    int limit = 500000,
  }) => BudgetModel(
    categoryId: categoryId,
    period: period,
    limitAmount: limit,
    createdAt: 1,
  );

  Future<void> insertTx({
    required String type,
    required int amount,
    required int categoryId,
    required DateTime date,
  }) => db.insert('transactions', {
    'type': type,
    'amount': amount,
    'account_id': 1,
    'category_id': categoryId,
    'date': date.millisecondsSinceEpoch,
    'created_at': 0,
  });

  setUp(() async {
    db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: Migrations.latestVersion,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, _) async {
          await Migrations.onCreate(db);
          // V2-M6: _v6 seeds the reserved "Penyesuaian" pair. This suite
          // predates it and seeds its own category fixtures at explicit ids, so
          // drop the pair to keep the clean slate it was written against
          // (getBySystemKey is covered in the categories suite).
          await db.delete('categories', where: 'system_key IS NOT NULL');
        },
      ),
    );
    // Parent rows the budget/transaction FKs need.
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
    await db.insert('categories', {
      'id': 2,
      'name': 'Transport',
      'type': 'expense',
      'created_at': 0,
    });
    final appDatabase = MockAppDatabase();
    when(() => appDatabase.db).thenReturn(db);
    datasource = BudgetLocalDatasource(appDatabase);
  });

  tearDown(() => db.close());

  test('spent sums only that category+period expenses (income/transfer/other '
      'category/other month excluded)', () async {
    await datasource.insert(budgetModel(categoryId: 1, period: '2026-01'));

    await insertTx(
      type: 'expense',
      amount: 30000,
      categoryId: 1,
      date: DateTime(2026, 1, 15),
    );
    await insertTx(
      type: 'expense',
      amount: 20000,
      categoryId: 1,
      date: DateTime(2026, 1, 20),
    );
    // Excluded: income + transfer on the same category & month.
    await insertTx(
      type: 'income',
      amount: 99999,
      categoryId: 1,
      date: DateTime(2026, 1, 15),
    );
    await insertTx(
      type: 'transfer',
      amount: 88888,
      categoryId: 1,
      date: DateTime(2026, 1, 15),
    );
    // Excluded: another category, and the same category in another month.
    await insertTx(
      type: 'expense',
      amount: 70000,
      categoryId: 2,
      date: DateTime(2026, 1, 15),
    );
    await insertTx(
      type: 'expense',
      amount: 40000,
      categoryId: 1,
      date: DateTime(2026, 2, 15),
    );

    final rows = await datasource.getBudgetsForPeriod('2026-01');
    expect(rows, hasLength(1));
    expect(rows.first.spent, 50000); // 30000 + 20000 only
  });

  test(
    'month boundary: the SQL period bucket matches the Dart periodKey',
    () async {
      // Two budgets straddling the Jan/Feb boundary.
      await datasource.insert(budgetModel(categoryId: 1, period: '2026-01'));
      await datasource.insert(budgetModel(categoryId: 1, period: '2026-02'));

      final lastDayJan = DateTime(2026, 1, 31);
      final firstDayFeb = DateTime(2026, 2);
      // Sanity: Dart buckets these exactly on either side of the boundary.
      expect(periodKey(lastDayJan), '2026-01');
      expect(periodKey(firstDayFeb), '2026-02');

      await insertTx(
        type: 'expense',
        amount: 11000,
        categoryId: 1,
        date: lastDayJan,
      );
      await insertTx(
        type: 'expense',
        amount: 22000,
        categoryId: 1,
        date: firstDayFeb,
      );

      final jan = await datasource.getBudgetsForPeriod('2026-01');
      final feb = await datasource.getBudgetsForPeriod('2026-02');
      // The SQL strftime bucket lands each tx in the same period Dart would.
      expect(jan.single.spent, 11000);
      expect(feb.single.spent, 22000);
    },
  );

  test(
    'a duplicate (category, period) violates the UNIQUE constraint',
    () async {
      await datasource.insert(budgetModel(categoryId: 1, period: '2026-01'));
      await expectLater(
        datasource.insert(budgetModel(categoryId: 1, period: '2026-01')),
        throwsA(isA<DatabaseException>()),
      );
    },
  );

  test('update persists the changed limit', () async {
    final id = await datasource.insert(
      budgetModel(categoryId: 1, period: '2026-01'),
    );
    await datasource.update(
      budgetModel(
        categoryId: 1,
        period: '2026-01',
        limit: 750000,
      ).copyWith(id: id),
    );

    final rows = await datasource.getBudgetsForPeriod('2026-01');
    expect(rows.single.limitAmount, 750000);
  });

  test('delete removes the row and returns the delete count', () async {
    final id = await datasource.insert(
      budgetModel(categoryId: 1, period: '2026-01'),
    );
    final removed = await datasource.delete(id);

    expect(removed, 1);
    expect(await datasource.getBudgetsForPeriod('2026-01'), isEmpty);
  });
}
