import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/home/pages/home_cubit.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockGetAccounts getAccounts;
  late MockGetTransactionsByMonth getByMonth;
  late MockGetRecentTransactions getRecent;
  late MockGetCategories getCategories;
  late MockGetBudgetsForPeriod getBudgets;
  late TxChangeNotifier txChanges;

  // Anchor everything to the local "today" the cubit computes against.
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  Transaction tx({
    required TransactionType type,
    required int amount,
    required DateTime date,
    int? categoryId,
    PlannedStatus? plannedStatus,
  }) => Transaction(
    type: type,
    amount: amount,
    accountId: 1,
    categoryId: categoryId,
    plannedStatus: plannedStatus,
    date: date.millisecondsSinceEpoch,
  );

  setUp(() {
    getAccounts = MockGetAccounts();
    getByMonth = MockGetTransactionsByMonth();
    getRecent = MockGetRecentTransactions();
    getCategories = MockGetCategories();
    getBudgets = MockGetBudgetsForPeriod();
    txChanges = TxChangeNotifier();
  });

  tearDown(() => txChanges.dispose());

  HomeCubit build() => HomeCubit(
    getAccounts: getAccounts,
    getTransactionsByMonth: getByMonth,
    getRecentTransactions: getRecent,
    getCategories: getCategories,
    getBudgetsForPeriod: getBudgets,
    txChangeNotifier: txChanges,
  );

  void stubAll({
    required List<Account> accounts,
    required List<Transaction> month,
    required List<Transaction> recent,
    List<Category> expenseCats = const [],
    List<Category> incomeCats = const [],
    List<Budget> budgets = const [],
  }) {
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => Right<Failure, List<Account>>(accounts));
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>(month));
    when(
      () => getRecent(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>(recent));
    when(
      () => getCategories(CategoryType.expense),
    ).thenAnswer((_) async => Right<Failure, List<Category>>(expenseCats));
    when(
      () => getCategories(CategoryType.income),
    ).thenAnswer((_) async => Right<Failure, List<Category>>(incomeCats));
    when(
      () => getBudgets(any()),
    ).thenAnswer((_) async => Right<Failure, List<Budget>>(budgets));
  }

  test(
    'load computes totals, today review and recent into a dashboard',
    () async {
      final income = tx(
        type: TransactionType.income,
        amount: 7000000,
        categoryId: 3,
        date: today,
      );
      final month = [
        income,
        tx(
          type: TransactionType.expense,
          amount: 35000,
          categoryId: 1,
          plannedStatus: PlannedStatus.planned,
          date: today,
        ),
        tx(
          type: TransactionType.expense,
          amount: 45000,
          categoryId: 1,
          plannedStatus: PlannedStatus.unplanned,
          date: today,
        ),
        tx(
          type: TransactionType.expense,
          amount: 18000,
          categoryId: 2,
          plannedStatus: PlannedStatus.unplanned,
          date: today,
        ),
        // Earlier this month — counts toward the month total but NOT today.
        tx(
          type: TransactionType.expense,
          amount: 3152000,
          categoryId: 1,
          date: yesterday,
        ),
      ];
      stubAll(
        accounts: const [
          Account(
            id: 1,
            name: 'Cash',
            type: AccountType.cash,
            balance: 5000000,
          ),
          Account(id: 2, name: 'BCA', type: AccountType.bank, balance: 3450000),
          // Archived — excluded from the total balance.
          Account(
            id: 3,
            name: 'Old',
            type: AccountType.cash,
            archived: true,
            balance: 999999,
          ),
        ],
        month: month,
        recent: [income],
        expenseCats: const [
          Category(id: 1, name: 'Makan', type: CategoryType.expense),
          Category(id: 2, name: 'Transport', type: CategoryType.expense),
        ],
        incomeCats: const [
          Category(id: 3, name: 'Gaji', type: CategoryType.income),
        ],
      );

      final cubit = build();
      await cubit.load();

      final state = cubit.state;
      expect(state, isA<HomeLoaded>());
      final d = (state as HomeLoaded).dashboard;
      expect(d.totalBalance, 8450000); // 5.0M + 3.45M, archived excluded
      expect(d.monthIncome, 7000000);
      expect(d.monthExpense, 3250000); // 35k + 45k + 18k + 3.152M
      expect(d.todaySpent, 98000); // 35k + 45k + 18k (today only)
      expect(d.todayUnplanned, 63000); // 45k + 18k
      expect(d.topCategoryName, 'Makan'); // 80k today vs Transport 18k
      expect(d.recent, [income]);
      expect(d.categoriesById[1]?.name, 'Makan');
      expect(d.accountsById[2]?.name, 'BCA');
      await cubit.close();
    },
  );

  test('a Left from any usecase surfaces an error state', () async {
    stubAll(accounts: const [], month: const [], recent: const []);
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Left<Failure, List<Account>>(CacheFailure()),
    );

    final cubit = build();
    await cubit.load();

    expect(cubit.state, isA<HomeError>());
    expect((cubit.state as HomeError).failure, isA<CacheFailure>());
    await cubit.close();
  });

  test('empty first run yields a zero dashboard, not an error', () async {
    stubAll(accounts: const [], month: const [], recent: const []);

    final cubit = build();
    await cubit.load();

    expect(cubit.state, isA<HomeLoaded>());
    final d = (cubit.state as HomeLoaded).dashboard;
    expect(d.totalBalance, 0);
    expect(d.monthIncome, 0);
    expect(d.monthExpense, 0);
    expect(d.todaySpent, 0);
    expect(d.todayUnplanned, 0);
    expect(d.topCategoryName, isNull);
    expect(d.recent, isEmpty);
    await cubit.close();
  });

  test('a notifier ping triggers a reload', () async {
    stubAll(accounts: const [], month: const [], recent: const []);

    final cubit = build();
    await cubit.load();

    txChanges.ping();
    await pumpEventQueue();

    // Two loads: the explicit one + the ping-driven refresh.
    verify(() => getAccounts(any())).called(2);
    expect(cubit.state, isA<HomeLoaded>());
    await cubit.close();
  });

  test('budgetGuard surfaces the most at-risk budget (max ratio)', () async {
    final period = periodKey(now);
    stubAll(
      accounts: const [],
      month: const [],
      recent: const [],
      expenseCats: const [
        Category(id: 1, name: 'Makan', type: CategoryType.expense),
        Category(id: 2, name: 'Transport', type: CategoryType.expense),
      ],
      budgets: [
        // 50% used — safe.
        Budget(
          id: 1,
          categoryId: 1,
          period: period,
          limitAmount: 100000,
          spent: 50000,
        ),
        // 90% used — warning, and the higher ratio, so it wins.
        Budget(
          id: 2,
          categoryId: 2,
          period: period,
          limitAmount: 100000,
          spent: 90000,
        ),
      ],
    );

    final cubit = build();
    await cubit.load();

    final guard = (cubit.state as HomeLoaded).dashboard.budgetGuard;
    expect(guard, isNotNull);
    expect(guard!.categoryName, 'Transport');
    expect(guard.level, BudgetStatusLevel.warning);
    await cubit.close();
  });

  test(
    'budgetGuard tie-break picks the higher-spent budget on equal ratio',
    () async {
      final period = periodKey(now);
      stubAll(
        accounts: const [],
        month: const [],
        recent: const [],
        expenseCats: const [
          Category(id: 1, name: 'Makan', type: CategoryType.expense),
          Category(id: 2, name: 'Transport', type: CategoryType.expense),
        ],
        budgets: [
          // Both exactly 50% used → equal ratio. Makan is listed first, but
          // Transport spent more, so the tie-break must override to Transport.
          Budget(
            id: 1,
            categoryId: 1,
            period: period,
            limitAmount: 100000,
            spent: 50000,
          ),
          Budget(
            id: 2,
            categoryId: 2,
            period: period,
            limitAmount: 200000,
            spent: 100000,
          ),
        ],
      );

      final cubit = build();
      await cubit.load();

      final guard = (cubit.state as HomeLoaded).dashboard.budgetGuard;
      expect(guard, isNotNull);
      expect(guard!.categoryName, 'Transport'); // higher spent breaks the tie
      await cubit.close();
    },
  );

  test('budgetGuard is null when there are no budgets', () async {
    stubAll(accounts: const [], month: const [], recent: const []);

    final cubit = build();
    await cubit.load();

    expect((cubit.state as HomeLoaded).dashboard.budgetGuard, isNull);
    await cubit.close();
  });
}
