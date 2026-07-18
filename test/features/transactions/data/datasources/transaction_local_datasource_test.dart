import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:jaga_saku/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:jaga_saku/features/transactions/data/models/transaction_model.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction_source.dart';
import 'package:jaga_saku/features/transactions/domain/transaction_aggregator.dart';
import 'package:mocktail/mocktail.dart';
// sqflite_ffi re-exports sqflite's `Transaction`; hide it so it does not clash
// with the domain entity of the same name.
import 'package:sqflite_common_ffi/sqflite_ffi.dart' hide Transaction;

import '../../../../helpers/mocks.dart';

/// Exercises [TransactionLocalDatasource] against a real in-memory sqflite (ffi)
/// database (schema via [Migrations.onCreate]). Two seed accounts (ids 1 & 2)
/// satisfy the `account_id` FK; the balance-integration tests then prove a saved
/// transaction moves the balance the [AccountLocalDatasource] balance query
/// reports.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late TransactionLocalDatasource datasource;
  late AccountLocalDatasource accounts;

  int millis(
    int y,
    int m,
    int d, [
    int h = 0,
    int min = 0,
    int s = 0,
    int ms = 0,
  ]) => DateTime(y, m, d, h, min, s, ms).millisecondsSinceEpoch;

  TransactionModel model({
    TransactionType type = TransactionType.expense,
    int amount = 1000,
    int accountId = 1,
    int? toAccountId,
    int? categoryId,
    PlannedStatus? plannedStatus,
    SpendingType? spendingType,
    int date = 0,
    String? note,
    String? receiptPath,
  }) => TransactionModel(
    type: type,
    amount: amount,
    accountId: accountId,
    toAccountId: toAccountId,
    categoryId: categoryId,
    plannedStatus: plannedStatus,
    spendingType: spendingType,
    date: date,
    note: note,
    createdAt: 1,
    receiptPath: receiptPath,
  );

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
    await db.insert('accounts', {
      'id': 1,
      'name': 'Cash',
      'type': 'cash',
      'opening_balance': 100000,
      'created_at': 0,
    });
    await db.insert('accounts', {
      'id': 2,
      'name': 'BCA',
      'type': 'bank',
      'opening_balance': 50000,
      'created_at': 0,
    });
    // Categories referenced by category_id (FK is enforced above).
    await db.insert('categories', {
      'id': 1,
      'name': 'Makan',
      'type': 'expense',
      'created_at': 0,
    });
    await db.insert('categories', {
      'id': 7,
      'name': 'Gaji',
      'type': 'income',
      'created_at': 0,
    });
    final appDatabase = MockAppDatabase();
    when(() => appDatabase.db).thenReturn(db);
    datasource = TransactionLocalDatasource(appDatabase);
    accounts = AccountLocalDatasource(appDatabase);
  });

  tearDown(() => db.close());

  test('insert expense then getByDay round-trips all fields', () async {
    final id = await datasource.insert(
      model(
        amount: 35000,
        categoryId: 1,
        plannedStatus: PlannedStatus.planned,
        spendingType: SpendingType.need,
        date: millis(2026, 7, 8),
        note: 'Lunch',
      ),
    );

    final rows = await datasource.getByDay(DateTime(2026, 7, 8));
    expect(rows, hasLength(1));
    final row = rows.single;
    expect(row.id, id);
    expect(row.type, TransactionType.expense);
    expect(row.amount, 35000);
    expect(row.categoryId, 1);
    expect(row.plannedStatus, PlannedStatus.planned);
    expect(row.spendingType, SpendingType.need);
    expect(row.note, 'Lunch');
  });

  test('insert income leaves planned/spending null', () async {
    await datasource.insert(
      model(
        type: TransactionType.income,
        amount: 5000000,
        categoryId: 7,
        date: millis(2026, 7, 8),
      ),
    );

    final row = (await datasource.getByDay(DateTime(2026, 7, 8))).single;
    expect(row.type, TransactionType.income);
    expect(row.plannedStatus, isNull);
    expect(row.spendingType, isNull);
  });

  test('insert transfer stores toAccountId and null category', () async {
    await datasource.insert(
      model(
        type: TransactionType.transfer,
        amount: 20000,
        toAccountId: 2,
        date: millis(2026, 7, 8),
      ),
    );

    final row = (await datasource.getByDay(DateTime(2026, 7, 8))).single;
    expect(row.type, TransactionType.transfer);
    expect(row.toAccountId, 2);
    expect(row.categoryId, isNull);
  });

  test(
    'getByMonth includes the last ms of the month, excludes the next',
    () async {
      await datasource.insert(
        model(date: millis(2026, 7, 31, 23, 59, 59, 999)),
      );
      await datasource.insert(model(date: millis(2026, 8, 1)));

      final july = await datasource.getByMonth(DateTime(2026, 7));
      final august = await datasource.getByMonth(DateTime(2026, 8));

      expect(july, hasLength(1));
      expect(july.single.date, millis(2026, 7, 31, 23, 59, 59, 999));
      expect(august, hasLength(1));
      expect(august.single.date, millis(2026, 8, 1));
    },
  );

  test('getByDay includes the last ms of the day, excludes the next', () async {
    await datasource.insert(model(date: millis(2026, 7, 8)));
    await datasource.insert(model(date: millis(2026, 7, 8, 23, 59, 59, 999)));
    await datasource.insert(model(date: millis(2026, 7, 9)));

    final day = await datasource.getByDay(DateTime(2026, 7, 8));
    expect(day, hasLength(2));
    expect(day.every((t) => t.date < millis(2026, 7, 9)), isTrue);
  });

  test('getRecent returns newest first, capped at the limit', () async {
    await datasource.insert(model(amount: 1, date: millis(2026, 7, 1)));
    await datasource.insert(model(amount: 2, date: millis(2026, 7, 2)));
    await datasource.insert(model(amount: 3, date: millis(2026, 7, 3)));

    final recent = await datasource.getRecent(2);
    expect(recent.map((t) => t.amount), [3, 2]);
  });

  test('receipt_path round-trips and getReceiptPath reads it', () async {
    final id = await datasource.insert(
      model(date: millis(2026, 7, 8), receiptPath: 'receipts/1.jpg'),
    );
    final row = (await datasource.getByDay(DateTime(2026, 7, 8))).single;
    expect(row.receiptPath, 'receipts/1.jpg');
    expect(await datasource.getReceiptPath(id), 'receipts/1.jpg');

    // A row with no receipt reads back null (write-through null, not '').
    final id2 = await datasource.insert(model(date: millis(2026, 7, 9)));
    expect(await datasource.getReceiptPath(id2), isNull);
  });

  test('delete removes the row and returns the delete count', () async {
    final id = await datasource.insert(model(date: millis(2026, 7, 8)));
    final removed = await datasource.delete(id);

    expect(removed, 1);
    expect(await datasource.getByDay(DateTime(2026, 7, 8)), isEmpty);
  });

  test('a saved expense reduces the source account balance', () async {
    await datasource.insert(model(amount: 30000, date: millis(2026, 7, 8)));

    final rows = await accounts.getAccounts();
    final cash = rows.firstWhere((a) => a.id == 1);
    expect(cash.balance, 100000 - 30000);
  });

  test('a saved income increases the source account balance', () async {
    await datasource.insert(
      model(
        type: TransactionType.income,
        amount: 75000,
        categoryId: 7,
        date: millis(2026, 7, 8),
      ),
    );

    final rows = await accounts.getAccounts();
    final cash = rows.firstWhere((a) => a.id == 1);
    expect(cash.balance, 100000 + 75000);
  });

  test('a transfer moves funds from the source to the destination', () async {
    await datasource.insert(
      model(
        type: TransactionType.transfer,
        amount: 20000,
        toAccountId: 2,
        date: millis(2026, 7, 8),
      ),
    );

    final rows = await accounts.getAccounts();
    final cash = rows.firstWhere((a) => a.id == 1);
    final bca = rows.firstWhere((a) => a.id == 2);
    expect(cash.balance, 100000 - 20000);
    expect(bca.balance, 50000 + 20000);
  });

  // ── monthlyNetDeltas + asset trend (V2-M7) ───────────────────────────────

  group('monthlyNetDeltas + asset trend', () {
    // A reserved/adjustment expense category the harness normally strips; the
    // trend must still count it (it moves real assets) while the report cards
    // must exclude it.
    Future<void> seedAdjustmentCategory() => db.insert('categories', {
      'id': 8,
      'name': 'Penyesuaian',
      'type': 'expense',
      'system_key': 'adjustment_out',
      'created_at': 0,
    });

    // Full-history window end: start of the month after [now].
    int endOfNextMonth(DateTime now) =>
        DateTime(now.year, now.month + 1).millisecondsSinceEpoch;

    test('income adds and expense subtracts within a month bucket', () async {
      await datasource.insert(
        model(
          type: TransactionType.income,
          amount: 75000,
          categoryId: 7,
          date: millis(2026, 7, 10),
        ),
      );
      await datasource.insert(
        model(amount: 30000, categoryId: 1, date: millis(2026, 7, 20)),
      );

      final deltas = await datasource.monthlyNetDeltas(
        0,
        endOfNextMonth(DateTime(2026, 7, 31)),
      );
      expect(deltas, hasLength(1));
      expect(deltas.single.monthMillis, millis(2026, 7, 1));
      expect(deltas.single.delta, 45000);
    });

    test('a transfer nets to zero in the monthly delta', () async {
      await datasource.insert(
        model(
          type: TransactionType.transfer,
          amount: 20000,
          toAccountId: 2,
          date: millis(2026, 7, 8),
        ),
      );

      final deltas = await datasource.monthlyNetDeltas(
        0,
        endOfNextMonth(DateTime(2026, 7, 31)),
      );
      // A single transfer row still produces its month bucket (SUM over the
      // CASE), but its contribution is 0.
      expect(deltas.single.monthMillis, millis(2026, 7, 1));
      expect(deltas.single.delta, 0);
    });

    test('a reserved adjustment expense is INCLUDED in the delta', () async {
      await seedAdjustmentCategory();
      await datasource.insert(
        model(amount: 40000, categoryId: 8, date: millis(2026, 7, 5)),
      );

      final deltas = await datasource.monthlyNetDeltas(
        0,
        endOfNextMonth(DateTime(2026, 7, 31)),
      );
      // The SQL has no category filter, so the adjustment subtracts real assets.
      expect(deltas.single.delta, -40000);
    });

    test('rows split into distinct buckets across a year boundary', () async {
      await datasource.insert(
        model(
          type: TransactionType.income,
          amount: 10000,
          categoryId: 7,
          date: millis(2025, 12, 31, 23, 59, 59, 999),
        ),
      );
      await datasource.insert(
        model(amount: 5000, categoryId: 1, date: millis(2026, 1, 1)),
      );

      final deltas = await datasource.monthlyNetDeltas(
        0,
        endOfNextMonth(DateTime(2026, 1, 31)),
      );
      // Ordered oldest→newest, one bucket per calendar month.
      expect(deltas.map((d) => d.monthMillis).toList(), [
        millis(2025, 12, 1),
        millis(2026, 1, 1),
      ]);
      expect(deltas.map((d) => d.delta).toList(), [10000, -5000]);
    });

    // ★ C1 — the mandatory anti-drift anchor. A >12-month-old transaction is in
    // the history, so cumulating from the opening baseline over the FULL window
    // must land the last point exactly on the summed account balance (Home's
    // totalBalance). A literal 12-month delta query would drop the old row and
    // fail here.
    test('cumulated trend endpoint equals the summed account balance', () async {
      final now = DateTime(2026, 7, 15);
      // Old expense (>12 months before `now`) — proves full-history cumulation.
      await datasource.insert(
        model(amount: 20000, categoryId: 1, date: millis(2025, 1, 15)),
      );
      // Recent income + expense + transfer in the current month.
      await datasource.insert(
        model(
          type: TransactionType.income,
          amount: 75000,
          categoryId: 7,
          date: millis(2026, 7, 3),
        ),
      );
      await datasource.insert(
        model(amount: 30000, categoryId: 1, date: millis(2026, 7, 9)),
      );
      await datasource.insert(
        model(
          type: TransactionType.transfer,
          amount: 20000,
          toAccountId: 2,
          date: millis(2026, 7, 12),
        ),
      );

      final deltas = await datasource.monthlyNetDeltas(0, endOfNextMonth(now));
      const baseline = 150000; // Σ opening_balance (100_000 + 50_000).
      final points = AssetTrendCalculator.cumulate(
        baseline: baseline,
        deltas: deltas,
      );

      final sumBalance = (await accounts.getAccounts()).fold<int>(
        0,
        (sum, a) => sum + a.balance,
      );
      expect(points.last.netWorth, sumBalance);
    });

    // ★ C2 — two-directional exclusion pinned on the SAME rows. A real expense
    // and a bigger system adjustment sit in one month: the report cards exclude
    // the adjustment (aggregator side), the trend includes it (SQL side).
    test(
      'adjustment moves the trend but not the income/expense cards',
      () async {
        await seedAdjustmentCategory();
        await datasource.insert(
          model(amount: 100000, categoryId: 1, date: millis(2026, 7, 6)),
        );
        await datasource.insert(
          model(amount: 300000, categoryId: 8, date: millis(2026, 7, 7)),
        );

        // Cards side — exclude the adjustment.
        final rows = (await datasource.getByMonth(
          DateTime(2026, 7),
        )).map((m) => m.toEntity()).toList();
        final totals = TransactionAggregator.incomeExpense(
          rows,
          excludeCategoryIds: {8},
        );
        expect(totals.expense, 100000);

        // Trend side — include the adjustment.
        final deltas = await datasource.monthlyNetDeltas(
          0,
          endOfNextMonth(DateTime(2026, 7, 31)),
        );
        expect(deltas.single.delta, -(100000 + 300000));
      },
    );
  });

  // ── searchWithNames (V3-M2 export / M3 search join) ───────────────────────

  group('searchWithNames', () {
    Future<void> seedAdjustmentCategory() => db.insert('categories', {
      'id': 8,
      'name': 'Penyesuaian',
      'type': 'expense',
      'system_key': 'adjustment_out',
      'created_at': 0,
    });

    test('expense row resolves account + category names, no target', () async {
      await datasource.insert(
        model(amount: 35000, categoryId: 1, date: millis(2026, 7, 8)),
      );

      final rows = await datasource.searchWithNames(
        const SearchTransactionParams(),
      );
      expect(rows, hasLength(1));
      final row = rows.single;
      expect(row['account_name'], 'Cash');
      expect(row['category_name'], 'Makan');
      expect(row['target_account_name'], isNull);
      expect(row['category_system_key'], isNull);
    });

    test('transfer row resolves the target account, empty category', () async {
      await datasource.insert(
        model(
          type: TransactionType.transfer,
          amount: 20000,
          toAccountId: 2,
          date: millis(2026, 7, 8),
        ),
      );

      final row = (await datasource.searchWithNames(
        const SearchTransactionParams(),
      )).single;
      expect(row['account_name'], 'Cash');
      expect(row['target_account_name'], 'BCA');
      expect(row['category_name'], isNull);
    });

    test('reconcile category surfaces its system_key', () async {
      await seedAdjustmentCategory();
      await datasource.insert(
        model(amount: 40000, categoryId: 8, date: millis(2026, 7, 5)),
      );

      final row = (await datasource.searchWithNames(
        const SearchTransactionParams(),
      )).single;
      expect(row['category_system_key'], 'adjustment_out');
    });

    test('account filter matches both source and incoming transfer', () async {
      // Outgoing from Cash(1), incoming transfer into Cash(1) from BCA(2), and
      // an unrelated BCA(2) expense that must NOT match the Cash filter.
      await datasource.insert(model(categoryId: 1, date: millis(2026, 7, 1)));
      await datasource.insert(
        model(
          type: TransactionType.transfer,
          amount: 2000,
          accountId: 2,
          toAccountId: 1,
          date: millis(2026, 7, 2),
        ),
      );
      await datasource.insert(
        model(
          amount: 3000,
          accountId: 2,
          categoryId: 1,
          date: millis(2026, 7, 3),
        ),
      );

      final rows = await datasource.searchWithNames(
        const SearchTransactionParams(accountId: 1),
      );
      expect(rows.map((r) => r['amount']), [1000, 2000]);
    });

    test('category / type / planned / spending / date filters', () async {
      await datasource.insert(
        model(
          amount: 100,
          categoryId: 1,
          plannedStatus: PlannedStatus.planned,
          spendingType: SpendingType.need,
          date: millis(2026, 7, 10),
        ),
      );
      await datasource.insert(
        model(
          type: TransactionType.income,
          amount: 200,
          categoryId: 7,
          date: millis(2026, 7, 12),
        ),
      );
      await datasource.insert(
        model(
          amount: 300,
          categoryId: 1,
          plannedStatus: PlannedStatus.unplanned,
          spendingType: SpendingType.want,
          date: millis(2026, 8, 1),
        ),
      );

      Future<List<Object?>> amounts(SearchTransactionParams p) async =>
          (await datasource.searchWithNames(
            p,
          )).map((r) => r['amount']).toList();

      expect(await amounts(const SearchTransactionParams(categoryId: 7)), [
        200,
      ]);
      expect(
        await amounts(
          const SearchTransactionParams(type: TransactionType.income),
        ),
        [200],
      );
      expect(
        await amounts(
          const SearchTransactionParams(plannedStatus: PlannedStatus.planned),
        ),
        [100],
      );
      expect(
        await amounts(
          const SearchTransactionParams(spendingType: SpendingType.want),
        ),
        [300],
      );
      // Half-open [Jul, Aug) keeps the two July rows, drops the Aug 1 row.
      expect(
        await amounts(
          SearchTransactionParams(
            startDate: millis(2026, 7, 1),
            endDate: millis(2026, 8, 1),
          ),
        ),
        [100, 200],
      );
    });

    test('combined filter narrows to the matching subset', () async {
      await datasource.insert(
        model(
          amount: 111,
          categoryId: 1,
          plannedStatus: PlannedStatus.planned,
          date: millis(2026, 7, 10),
        ),
      );
      await datasource.insert(
        model(
          amount: 222,
          categoryId: 1,
          plannedStatus: PlannedStatus.unplanned,
          date: millis(2026, 7, 11),
        ),
      );

      final rows = await datasource.searchWithNames(
        SearchTransactionParams(
          accountId: 1,
          categoryId: 1,
          type: TransactionType.expense,
          plannedStatus: PlannedStatus.planned,
          startDate: millis(2026, 7, 1),
          endDate: millis(2026, 8, 1),
        ),
      );
      expect(rows.map((r) => r['amount']), [111]);
    });

    test('a no-match filter returns an empty list', () async {
      await datasource.insert(
        model(amount: 100, categoryId: 1, date: millis(2026, 7, 10)),
      );

      final rows = await datasource.searchWithNames(
        const SearchTransactionParams(categoryId: 999),
      );
      expect(rows, isEmpty);
    });

    test('is read-only — row counts are unchanged', () async {
      await seedAdjustmentCategory();
      await datasource.insert(
        model(amount: 100, categoryId: 1, date: millis(2026, 7, 10)),
      );
      await datasource.insert(
        model(
          type: TransactionType.transfer,
          amount: 200,
          toAccountId: 2,
          date: millis(2026, 7, 11),
        ),
      );

      Future<int> count(String table) async =>
          (await db.rawQuery('SELECT COUNT(*) AS c FROM $table')).first['c']!
              as int;

      final before = [
        await count('transactions'),
        await count('accounts'),
        await count('categories'),
      ];
      await datasource.searchWithNames(const SearchTransactionParams());
      final after = [
        await count('transactions'),
        await count('accounts'),
        await count('categories'),
      ];
      expect(after, before);
    });
  });

  // ── search (V3-M3): typed reads + the search-only facets + sort ───────────

  group('search', () {
    Future<void> seedAdjustmentCategory() => db.insert('categories', {
      'id': 8,
      'name': 'Penyesuaian',
      'type': 'expense',
      'system_key': 'adjustment_out',
      'created_at': 0,
    });

    Future<List<int>> amounts(SearchTransactionParams p) async =>
        (await datasource.search(p)).map((t) => t.amount).toList();

    test(
      'SELECT t.* round-trips the transaction fields (no column bleed)',
      () async {
        await datasource.insert(
          model(
            amount: 35000,
            categoryId: 1,
            plannedStatus: PlannedStatus.planned,
            spendingType: SpendingType.need,
            date: millis(2026, 7, 8),
            note: 'Lunch',
            receiptPath: 'receipts/1.jpg',
          ),
        );

        final rows = await datasource.search(const SearchTransactionParams());
        expect(rows, hasLength(1));
        final r = rows.single;
        expect(r.type, TransactionType.expense);
        expect(r.amount, 35000);
        expect(r.accountId, 1);
        expect(r.categoryId, 1);
        expect(r.plannedStatus, PlannedStatus.planned);
        expect(r.spendingType, SpendingType.need);
        expect(r.note, 'Lunch');
        expect(r.receiptPath, 'receipts/1.jpg');
      },
    );

    test('keyword matches the note', () async {
      await datasource.insert(
        model(categoryId: 1, date: millis(2026, 7, 1), note: 'Dinner cafe'),
      );
      await datasource.insert(
        model(amount: 2, categoryId: 1, date: millis(2026, 7, 2), note: 'x'),
      );
      expect(await amounts(const SearchTransactionParams(keyword: 'dinner')), [
        1000,
      ]);
    });

    test('keyword matches the source account name', () async {
      await datasource.insert(model(categoryId: 1, date: millis(2026, 7, 1)));
      await datasource.insert(
        model(amount: 2, accountId: 2, categoryId: 1, date: millis(2026, 7, 2)),
      );
      // "cash" matches a.name for the Cash(1) row only.
      expect(await amounts(const SearchTransactionParams(keyword: 'cash')), [
        1000,
      ]);
    });

    test('keyword matches a transfer target account name', () async {
      await datasource.insert(
        model(
          type: TransactionType.transfer,
          amount: 5,
          toAccountId: 2,
          date: millis(2026, 7, 1),
        ),
      );
      // "bca" matches a2.name (the BCA target).
      expect(await amounts(const SearchTransactionParams(keyword: 'bca')), [5]);
    });

    test('keyword matches the category name', () async {
      await datasource.insert(model(categoryId: 1, date: millis(2026, 7, 1)));
      await datasource.insert(
        model(
          type: TransactionType.income,
          amount: 2,
          categoryId: 7,
          date: millis(2026, 7, 2),
        ),
      );
      expect(await amounts(const SearchTransactionParams(keyword: 'makan')), [
        1000,
      ]);
    });

    test('amount range filters inclusively on both bounds', () async {
      await datasource.insert(
        model(amount: 100, categoryId: 1, date: millis(2026, 7, 1)),
      );
      await datasource.insert(
        model(amount: 200, categoryId: 1, date: millis(2026, 7, 2)),
      );
      await datasource.insert(
        model(amount: 300, categoryId: 1, date: millis(2026, 7, 3)),
      );
      expect(
        (await amounts(const SearchTransactionParams(minAmount: 200))).toSet(),
        {200, 300},
      );
      expect(
        (await amounts(const SearchTransactionParams(maxAmount: 200))).toSet(),
        {100, 200},
      );
      expect(
        await amounts(
          const SearchTransactionParams(minAmount: 150, maxAmount: 250),
        ),
        [200],
      );
    });

    test('hasReceipt splits rows with and without a receipt', () async {
      await datasource.insert(
        model(
          amount: 1,
          categoryId: 1,
          date: millis(2026, 7, 1),
          receiptPath: 'receipts/a.jpg',
        ),
      );
      await datasource.insert(
        model(amount: 2, categoryId: 1, date: millis(2026, 7, 2)),
      );
      expect(await amounts(const SearchTransactionParams(hasReceipt: true)), [
        1,
      ]);
      expect(await amounts(const SearchTransactionParams(hasReceipt: false)), [
        2,
      ]);
    });

    test(
      'source reconciliation includes adjustments; manual excludes them',
      () async {
        await seedAdjustmentCategory();
        // manual expense (Makan), manual transfer (null category), reconciliation.
        await datasource.insert(
          model(amount: 100, categoryId: 1, date: millis(2026, 7, 1)),
        );
        await datasource.insert(
          model(
            type: TransactionType.transfer,
            amount: 200,
            toAccountId: 2,
            date: millis(2026, 7, 2),
          ),
        );
        await datasource.insert(
          model(amount: 300, categoryId: 8, date: millis(2026, 7, 3)),
        );

        expect(
          await amounts(
            const SearchTransactionParams(
              source: TransactionSource.reconciliation,
            ),
          ),
          [300],
        );
        expect(
          (await amounts(
            const SearchTransactionParams(source: TransactionSource.manual),
          )).toSet(),
          {100, 200},
        );
      },
    );

    test('sort orders the result set four ways', () async {
      await datasource.insert(
        model(amount: 300, categoryId: 1, date: millis(2026, 7, 1)),
      );
      await datasource.insert(
        model(amount: 100, categoryId: 1, date: millis(2026, 7, 2)),
      );
      await datasource.insert(
        model(amount: 200, categoryId: 1, date: millis(2026, 7, 3)),
      );
      expect(await amounts(const SearchTransactionParams()), [
        200,
        100,
        300,
      ]); // default newest = date DESC
      expect(
        await amounts(const SearchTransactionParams(sort: SortOption.oldest)),
        [300, 100, 200],
      );
      expect(
        await amounts(const SearchTransactionParams(sort: SortOption.highest)),
        [300, 200, 100],
      );
      expect(
        await amounts(const SearchTransactionParams(sort: SortOption.lowest)),
        [100, 200, 300],
      );
    });

    test('combined facets AND together', () async {
      await datasource.insert(
        model(
          amount: 100,
          categoryId: 1,
          plannedStatus: PlannedStatus.planned,
          date: millis(2026, 7, 10),
          note: 'coffee',
        ),
      );
      await datasource.insert(
        model(
          amount: 100,
          categoryId: 1,
          plannedStatus: PlannedStatus.unplanned,
          date: millis(2026, 7, 11),
          note: 'coffee',
        ),
      );
      await datasource.insert(
        model(
          amount: 999,
          categoryId: 1,
          plannedStatus: PlannedStatus.planned,
          date: millis(2026, 7, 12),
          note: 'coffee',
        ),
      );

      final rows = await datasource.search(
        const SearchTransactionParams(
          keyword: 'coffee',
          plannedStatus: PlannedStatus.planned,
          maxAmount: 500,
        ),
      );
      // Only the planned "coffee" under 500 survives all three predicates.
      expect(rows.map((t) => t.amount), [100]);
    });

    test('a no-match query returns an empty list', () async {
      await datasource.insert(model(categoryId: 1, date: millis(2026, 7, 1)));
      expect(
        await datasource.search(const SearchTransactionParams(keyword: 'zzz')),
        isEmpty,
      );
    });
  });
}
