import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/resources/category_colors.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/insight/pages/insight_cubit.dart';
import 'package:jaga_saku/features/insight/pages/insight_rules.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/ledger_fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockGetTransactionsByMonth getByMonth;
  late MockGetCategories getCategories;
  late MockGetBudgetsForPeriod getBudgets;
  late TxChangeNotifier txChanges;
  late AppSettingsCubit appSettings;

  final now = DateTime.now();
  final thisMonth = DateTime(now.year, now.month);
  final prevMonth = DateTime(now.year, now.month - 1);

  Transaction tx({
    required int amount,
    required int categoryId,
    TransactionType type = TransactionType.expense,
    PlannedStatus? plannedStatus,
    SpendingType? spendingType,
  }) => Transaction(
    type: type,
    amount: amount,
    accountId: 1,
    categoryId: categoryId,
    plannedStatus: plannedStatus,
    spendingType: spendingType,
    date: thisMonth.millisecondsSinceEpoch,
  );

  setUp(() {
    getByMonth = MockGetTransactionsByMonth();
    getCategories = MockGetCategories();
    getBudgets = MockGetBudgetsForPeriod();
    txChanges = TxChangeNotifier();
    // Default start-day 1 → the budget lookup keys off the calendar month, so
    // every pre-existing assertion here reproduces unchanged. Stubbed (not
    // bare) because the custom-start-day test below drives a real write.
    final appStore = MockSettingsService();
    when(() => appStore.getString(any())).thenAnswer((_) async => null);
    when(() => appStore.setString(any(), any())).thenAnswer((_) async {});
    appSettings = AppSettingsCubit(appStore);
  });

  tearDown(() async {
    await appSettings.close();
    txChanges.dispose();
  });

  InsightCubit build() => InsightCubit(
    getTransactionsByMonth: getByMonth,
    getCategories: getCategories,
    getBudgetsForPeriod: getBudgets,
    txChangeNotifier: txChanges,
    appSettings: appSettings,
  );

  void stub({
    List<Transaction> current = const [],
    List<Transaction> previous = const [],
    List<Category> expenseCats = const [],
    List<Category> incomeCats = const [],
    List<Budget> budgets = const [],
  }) {
    // Default any-month → empty, then the specific current/previous months.
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
      () => getBudgets(any()),
    ).thenAnswer((_) async => Right<Failure, List<Budget>>(budgets));
  }

  const expenseCats = [
    Category(
      id: 1,
      name: 'Makan',
      type: CategoryType.expense,
      color: 0xFFEF4444,
    ),
    Category(id: 2, name: 'Transport', type: CategoryType.expense),
    Category(id: 4, name: 'Kopi', type: CategoryType.expense),
  ];
  const incomeCats = [Category(id: 3, name: 'Gaji', type: CategoryType.income)];

  test('load folds a month into overview, slices, splits and insights', () async {
    stub(
      current: [
        tx(amount: 7000000, categoryId: 3, type: TransactionType.income),
        tx(
          amount: 1000000,
          categoryId: 1,
          plannedStatus: PlannedStatus.planned,
          spendingType: SpendingType.need,
        ),
        tx(
          amount: 600000,
          categoryId: 2,
          plannedStatus: PlannedStatus.planned,
          spendingType: SpendingType.need,
        ),
        tx(
          amount: 400000,
          categoryId: 4,
          plannedStatus: PlannedStatus.unplanned,
          spendingType: SpendingType.want,
        ),
        // A transfer must be excluded from both income and expense.
        tx(amount: 999999, categoryId: 1, type: TransactionType.transfer),
      ],
      previous: [
        tx(amount: 800000, categoryId: 1), // Makan 800k → 1M = +25% (top riser)
        tx(
          amount: 550000,
          categoryId: 2,
        ), // Transport 550k → 600k = +9% (below 15%)
        tx(
          amount: 350000,
          categoryId: 4,
          plannedStatus: PlannedStatus.unplanned,
        ), // Kopi 350k → 400k = +14% (below 15%); unplanned 350k < 400k → tip
      ],
      expenseCats: expenseCats,
      incomeCats: incomeCats,
      budgets: const [
        // Kopi 80% used → warning insight.
        Budget(
          id: 1,
          categoryId: 4,
          period: '2026-01',
          limitAmount: 500000,
          spent: 400000,
        ),
      ],
    );

    final cubit = build();
    await cubit.load(thisMonth);

    expect(cubit.state, isA<InsightLoaded>());
    final r = (cubit.state as InsightLoaded).report;

    // Overview — transfers excluded.
    expect(r.income, 7000000);
    expect(r.expense, 2000000);
    expect(r.saved, 5000000);

    // Slices sorted desc, pcts of total expense summing to 1.0.
    expect(r.expenseByCategory.map((s) => s.name).toList(), [
      'Makan',
      'Transport',
      'Kopi',
    ]);
    expect(r.expenseByCategory.first.amount, 1000000);
    expect(r.expenseByCategory.first.pct, closeTo(0.5, 1e-9));
    expect(r.expenseByCategory.first.color, 0xFFEF4444);
    expect(
      r.expenseByCategory.fold<double>(0, (sum, s) => sum + s.pct),
      closeTo(1.0, 1e-9),
    );

    // Planned vs unplanned over the typed subset (1.6M planned / 0.4M unplanned).
    expect(r.plannedVsUnplanned.planned, 1600000);
    expect(r.plannedVsUnplanned.unplanned, 400000);
    expect(r.plannedVsUnplanned.plannedPct, closeTo(0.8, 1e-9));
    expect(r.plannedVsUnplanned.unplannedPct, closeTo(0.2, 1e-9));

    // Need vs want over the typed subset.
    expect(r.needVsWant[SpendingType.need]?.amount, 1600000);
    expect(r.needVsWant[SpendingType.want]?.amount, 400000);
    expect(r.needVsWant[SpendingType.need]?.pct, closeTo(0.8, 1e-9));

    // Insights: budget warning (Kopi 80%), category up (Makan +25%), unplanned up.
    expect(r.insights.length, 3);
    expect(r.insights[0].type, InsightType.warning);
    expect(r.insights[0].category, 'Kopi');
    expect(r.insights[0].pct, 80);
    expect(r.insights[1].type, InsightType.trendUp);
    expect(r.insights[1].category, 'Makan');
    expect(r.insights[1].pct, 25);
    expect(r.insights[2].type, InsightType.tip);

    await cubit.close();
  });

  test(
    'empty month yields a zero-report with empty sections, not an error',
    () async {
      stub(expenseCats: expenseCats, incomeCats: incomeCats);

      final cubit = build();
      await cubit.load(thisMonth);

      expect(cubit.state, isA<InsightLoaded>());
      final r = (cubit.state as InsightLoaded).report;
      expect(r.income, 0);
      expect(r.expense, 0);
      expect(r.saved, 0);
      expect(r.hasExpense, isFalse);
      expect(r.hasPlannedData, isFalse);
      expect(r.hasSpendingTypeData, isFalse);
      expect(r.hasInsights, isFalse);
      await cubit.close();
    },
  );

  test('a Left from any usecase surfaces an error state', () async {
    stub(expenseCats: expenseCats);
    when(() => getBudgets(any())).thenAnswer(
      (_) async => const Left<Failure, List<Budget>>(CacheFailure()),
    );

    final cubit = build();
    await cubit.load(thisMonth);

    expect(cubit.state, isA<InsightError>());
    expect((cubit.state as InsightError).failure, isA<CacheFailure>());
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
    expect(cubit.state, isA<InsightLoaded>());
    await cubit.close();
  });

  test('previousMonth recomputes against the earlier month', () async {
    stub(expenseCats: expenseCats);

    final cubit = build();
    await cubit.load(thisMonth);
    cubit.previousMonth();
    await pumpEventQueue();

    expect(cubit.focusedMonth, prevMonth);
    expect(cubit.state, isA<InsightLoaded>());
    expect((cubit.state as InsightLoaded).report.month, prevMonth);
    await cubit.close();
  });

  // ── Budget cycle keying (V5-W1) ─────────────────────────────────────────────

  // A budget row is labelled with its CYCLE-START month. Keying the lookup off
  // the raw calendar month asked for a cycle that has not opened yet (usually
  // uncreated), so the budget card silently vanished for the first
  // `startDay - 1` days of every custom cycle.
  test('the budget lookup keys off the cycle-start month, not the calendar '
      'month', () async {
    stub(expenseCats: expenseCats, incomeCats: incomeCats);
    // Applied BEFORE the cubit exists, so the seeded cycle subscription sees no
    // change and `load` below is the only fetch.
    await appSettings.setBudgetCycleStartDay(25);

    final cubit = build();
    await cubit.load(DateTime(2026, 7));

    // 2026-07-01 sits inside the cycle that OPENED 2026-06-25, so the row to
    // read is the one labelled '2026-06'.
    verify(() => getBudgets('2026-06')).called(1);
    verifyNever(() => getBudgets('2026-07'));
    await cubit.close();
  });

  // V4-M2 wiring: the start-day signal rides AppSettingsCubit's own stream, not
  // the tx bus — Insight keys its budget lookup off the cycle, so it must
  // re-window live like Home does.
  test('a budget cycle start-day change reloads Insight', () async {
    stub(expenseCats: expenseCats, incomeCats: incomeCats);

    final cubit = build();
    await cubit.load(thisMonth);
    clearInteractions(getBudgets);

    await appSettings.setBudgetCycleStartDay(15);
    await pumpEventQueue();

    // One reload → one budget fetch, re-keyed off the new cycle.
    verify(() => getBudgets(any())).called(1);
    await cubit.close();
  });

  test('close cancels the cycle-day subscription', () async {
    stub(expenseCats: expenseCats, incomeCats: incomeCats);

    final cubit = build();
    await cubit.load(thisMonth);
    await cubit.close();
    clearInteractions(getBudgets);

    await appSettings.setBudgetCycleStartDay(15);
    await pumpEventQueue();

    verifyNever(() => getBudgets(any()));
  });

  // ── Reserved-category exclusion (V2-M6) ─────────────────────────────────────

  test(
    'reconcile adjustments are excluded from overview, donut slices and trends',
    () async {
      stub(
        current: [
          tx(amount: 100000, categoryId: 1), // Makan — a real expense
          tx(amount: 30000, categoryId: 8), // reconcile adjustment (current)
        ],
        previous: [
          tx(amount: 80000, categoryId: 1), // Makan last month
          tx(amount: 20000, categoryId: 8), // reconcile adjustment (previous)
        ],
        expenseCats: const [...expenseCats, penyesuaianOut],
        incomeCats: incomeCats,
      );

      final cubit = build();
      await cubit.load(thisMonth);

      final r = (cubit.state as InsightLoaded).report;
      // Overview excludes the adjustment.
      expect(r.expense, 100000);
      // The donut has no reserved wedge.
      expect(r.expenseByCategory.map((s) => s.categoryId), isNot(contains(8)));
      // C2: the month-over-month trend fold (:245) excluded it too, so no
      // insight references "Penyesuaian".
      expect(r.insights.every((i) => i.category != 'Penyesuaian'), isTrue);
      await cubit.close();
    },
  );

  // ── Donut color collision (Tranche C, C3) ───────────────────────────────────

  test('colorless categories get distinct swatch colors by position', () async {
    stub(
      current: [
        tx(amount: 600000, categoryId: 2), // Transport — stored color is null
        tx(amount: 400000, categoryId: 4), // Kopi — stored color is null
      ],
      expenseCats: expenseCats,
      incomeCats: incomeCats,
    );

    final cubit = build();
    await cubit.load(thisMonth);

    final slices = (cubit.state as InsightLoaded).report.expenseByCategory;
    // Sorted desc (Transport 600k, Kopi 400k); each colorless category gets a
    // distinct swatch by position so its donut wedge never collides.
    expect(slices.map((s) => s.name).toList(), ['Transport', 'Kopi']);
    expect(slices[0].color, CategoryColors.swatches[0]);
    expect(slices[1].color, CategoryColors.swatches[1]);
    expect(slices[0].color, isNot(slices[1].color));
    await cubit.close();
  });

  test(
    'a category with a stored color keeps it (no swatch override)',
    () async {
      stub(
        current: [
          tx(amount: 500000, categoryId: 1), // Makan — stored color 0xFFEF4444
        ],
        expenseCats: expenseCats,
        incomeCats: incomeCats,
      );

      final cubit = build();
      await cubit.load(thisMonth);

      final slices = (cubit.state as InsightLoaded).report.expenseByCategory;
      expect(slices.single.color, 0xFFEF4444);
      await cubit.close();
    },
  );
}
