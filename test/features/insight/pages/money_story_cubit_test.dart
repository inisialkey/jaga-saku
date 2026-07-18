import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/insight/pages/money_story_cubit.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/ledger_fixtures.dart';
import '../../../helpers/mocks.dart';

/// [MoneyStoryCubit] mirrors [InsightCubit] — month focus + `TxChangeNotifier`
/// sub + prev/next. `GetAssetTrend` is mocked here (its reconciliation identity
/// is proven in the datasource suite); these tests pin the card assembly, the
/// two-directional system exclusion (cards exclude, trend includes), the deficit
/// and ÷0 paths, and the empty-month zero-story.
void main() {
  setUpAll(registerFallbackValues);

  late MockGetTransactionsByMonth getByMonth;
  late MockGetCategories getCategories;
  late MockGetAccounts getAccounts;
  late MockGetAssetTrend getAssetTrend;
  late TxChangeNotifier txChanges;

  final now = DateTime.now();
  final thisMonth = DateTime(now.year, now.month);
  final prevMonth = DateTime(now.year, now.month - 1);

  Transaction tx({
    required int amount,
    required int categoryId,
    TransactionType type = TransactionType.expense,
    SpendingType? spendingType,
  }) => Transaction(
    type: type,
    amount: amount,
    accountId: 1,
    categoryId: categoryId,
    spendingType: spendingType,
    date: thisMonth.millisecondsSinceEpoch,
  );

  setUp(() {
    getByMonth = MockGetTransactionsByMonth();
    getCategories = MockGetCategories();
    getAccounts = MockGetAccounts();
    getAssetTrend = MockGetAssetTrend();
    txChanges = TxChangeNotifier();
  });

  tearDown(() => txChanges.dispose());

  MoneyStoryCubit build() => MoneyStoryCubit(
    getTransactionsByMonth: getByMonth,
    getCategories: getCategories,
    getAccounts: getAccounts,
    getAssetTrend: getAssetTrend,
    txChangeNotifier: txChanges,
  );

  // Baseline = Σ opening_balance over non-archived accounts = 150_000.
  const defaultAccounts = [
    Account(
      id: 1,
      name: 'Cash',
      type: AccountType.cash,
      openingBalance: 150000,
    ),
  ];

  void stub({
    List<Transaction> current = const [],
    List<Transaction> previous = const [],
    List<Category> expenseCats = const [],
    List<Category> incomeCats = const [],
    List<Account> accounts = defaultAccounts,
    List<TrendPoint>? trend,
  }) {
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getByMonth(thisMonth),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>(current));
    when(
      () => getByMonth(prevMonth),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>(previous));
    when(
      () => getCategories(CategoryType.expense),
    ).thenAnswer((_) async => Right<Failure, List<Category>>(expenseCats));
    when(
      () => getCategories(CategoryType.income),
    ).thenAnswer((_) async => Right<Failure, List<Category>>(incomeCats));
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => Right<Failure, List<Account>>(accounts));
    when(() => getAssetTrend(any())).thenAnswer(
      (_) async => Right<Failure, List<TrendPoint>>(
        trend ??
            [
              TrendPoint(
                monthMillis: thisMonth.millisecondsSinceEpoch,
                netWorth: 0,
              ),
            ],
      ),
    );
  }

  const expenseCats = [
    Category(id: 1, name: 'Makan', type: CategoryType.expense),
    Category(id: 2, name: 'Transport', type: CategoryType.expense),
    Category(id: 4, name: 'Kopi', type: CategoryType.expense),
  ];
  const incomeCats = [Category(id: 3, name: 'Gaji', type: CategoryType.income)];

  test(
    'assembles saved, savings-rate, top, biggest, MoM, need/want, netWorth',
    () async {
      stub(
        current: [
          tx(amount: 7000000, categoryId: 3, type: TransactionType.income),
          tx(amount: 1000000, categoryId: 1, spendingType: SpendingType.need),
          tx(amount: 600000, categoryId: 2, spendingType: SpendingType.need),
          tx(amount: 400000, categoryId: 4, spendingType: SpendingType.want),
        ],
        previous: [
          tx(amount: 6000000, categoryId: 3, type: TransactionType.income),
          tx(amount: 800000, categoryId: 1),
        ],
        expenseCats: expenseCats,
        incomeCats: incomeCats,
        trend: [
          TrendPoint(
            monthMillis: prevMonth.millisecondsSinceEpoch,
            netWorth: 5000000,
          ),
          TrendPoint(
            monthMillis: thisMonth.millisecondsSinceEpoch,
            netWorth: 8000000,
          ),
        ],
      );

      final cubit = build();
      await cubit.load(thisMonth);

      expect(cubit.state, isA<MoneyStoryLoaded>());
      final s = (cubit.state as MoneyStoryLoaded).story;

      expect(s.income, 7000000);
      expect(s.expense, 2000000);
      expect(s.saved, 5000000);
      expect(s.savingsRatePct, 71); // round(5/7 * 100)
      expect(s.isDeficit, isFalse);
      expect(s.topCategoryId, 1);
      expect(s.topCategoryAmount, 1000000);
      expect(s.biggestExpense?.amount, 1000000);
      expect(s.momIncome, 1000000); // 7M − 6M
      expect(s.momExpense, 1200000); // 2M − 0.8M
      expect(s.needVsWant[SpendingType.need]?.amount, 1600000);
      expect(s.needVsWant[SpendingType.want]?.amount, 400000);
      expect(s.netWorth, 8000000); // trend.last
      expect(s.hasData, isTrue);

      await cubit.close();
    },
  );

  test(
    'excludes system categories from the cards (trend proven elsewhere)',
    () async {
      stub(
        current: [
          tx(amount: 100000, categoryId: 1), // Makan — a real expense
          tx(amount: 300000, categoryId: 8), // bigger reconcile adjustment
        ],
        expenseCats: const [...expenseCats, penyesuaianOut],
      );

      final cubit = build();
      await cubit.load(thisMonth);

      final s = (cubit.state as MoneyStoryLoaded).story;
      // The 300k adjustment is excluded, so the real 100k expense wins every card.
      expect(s.expense, 100000);
      expect(s.biggestExpense?.amount, 100000);
      expect(s.topCategoryId, 1);
      await cubit.close();
    },
  );

  test(
    'a deficit month flips saved/isDeficit and the savings-rate sign',
    () async {
      stub(
        current: [
          tx(amount: 1000000, categoryId: 3, type: TransactionType.income),
          tx(amount: 1500000, categoryId: 1),
        ],
        expenseCats: expenseCats,
        incomeCats: incomeCats,
      );

      final cubit = build();
      await cubit.load(thisMonth);

      final s = (cubit.state as MoneyStoryLoaded).story;
      expect(s.saved, -500000);
      expect(s.isDeficit, isTrue);
      expect(s.savingsRatePct, -50);
      await cubit.close();
    },
  );

  test(
    'a zero-income month guards the savings-rate divide (0, no throw)',
    () async {
      stub(
        current: [tx(amount: 50000, categoryId: 1)],
        expenseCats: expenseCats,
      );

      final cubit = build();
      await cubit.load(thisMonth);

      final s = (cubit.state as MoneyStoryLoaded).story;
      expect(s.savingsRatePct, 0);
      expect(s.isDeficit, isTrue);
      await cubit.close();
    },
  );

  test('an empty month is a zero-story with netWorth == baseline', () async {
    stub(expenseCats: expenseCats, incomeCats: incomeCats, trend: const []);

    final cubit = build();
    await cubit.load(thisMonth);

    expect(cubit.state, isA<MoneyStoryLoaded>());
    final s = (cubit.state as MoneyStoryLoaded).story;
    expect(s.hasData, isFalse);
    expect(s.income, 0);
    expect(s.expense, 0);
    expect(s.netWorth, 150000); // falls back to the opening-balance baseline
    await cubit.close();
  });

  test('a notifier ping reloads the focused month (live refresh)', () async {
    stub(expenseCats: expenseCats);

    final cubit = build();
    await cubit.load(thisMonth);

    txChanges.ping();
    await pumpEventQueue();

    // Two loads × two month fetches each (current + previous) = 4.
    verify(() => getByMonth(any())).called(4);
    expect(cubit.state, isA<MoneyStoryLoaded>());
    await cubit.close();
  });

  test('previousMonth recomputes against the earlier month', () async {
    stub(expenseCats: expenseCats);

    final cubit = build();
    await cubit.load(thisMonth);
    cubit.previousMonth();
    await pumpEventQueue();

    expect(cubit.focusedMonth, prevMonth);
    expect(cubit.state, isA<MoneyStoryLoaded>());
    expect((cubit.state as MoneyStoryLoaded).story.month, prevMonth);
    await cubit.close();
  });

  test('a Left from any usecase surfaces an error state', () async {
    stub(expenseCats: expenseCats);
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Left<Failure, List<Account>>(CacheFailure()),
    );

    final cubit = build();
    await cubit.load(thisMonth);

    expect(cubit.state, isA<MoneyStoryError>());
    expect((cubit.state as MoneyStoryError).failure, isA<CacheFailure>());
    await cubit.close();
  });
}
