import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/pages/widgets/budget_item_card.dart';
import 'package:jaga_saku/features/budgets/pages/widgets/budget_status_badge.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/home/pages/home_cubit.dart';
import 'package:jaga_saku/features/home/pages/widgets/budget_guard_card.dart';
import 'package:jaga_saku/features/home/pages/widgets/daily_review_card.dart';
import 'package:jaga_saku/features/home/pages/widgets/total_balance_card.dart';
import 'package:jaga_saku/features/insight/pages/insight_cubit.dart';
import 'package:jaga_saku/features/insight/pages/insight_rules.dart';
import 'package:jaga_saku/features/insight/pages/widgets/asset_trend_chart.dart';
import 'package:jaga_saku/features/insight/pages/widgets/category_legend.dart';
import 'package:jaga_saku/features/insight/pages/widgets/expense_donut_chart.dart';
import 'package:jaga_saku/features/insight/pages/widgets/insight_card.dart';
import 'package:jaga_saku/features/insight/pages/widgets/monthly_overview_card.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/account_setup_step.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/onboarding_progress_dots.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/setup_summary_step.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/value_proposition_step.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/welcome_step.dart';
import 'package:jaga_saku/features/security/pages/widgets/pin_pad.dart';
import 'package:jaga_saku/features/settings/pages/widgets/setting_option_tile.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/search/widgets/active_filter_chips.dart';

import 'helpers/pump_app.dart';

/// Dark-theme render smoke test (M6 §8). Dark mode became app-reachable in M6
/// (Appearance → Dark/System), so the M1–M5 cards render under [AppPalette.dark]
/// for the first time. This is an automated **no-crash proxy**: it pumps the
/// heaviest `context.colors` consumers under [AppTheme.dark] and asserts they
/// build with no exception — proving the dark palette extension resolves
/// everywhere (no missing-color / null crash). A true VISUAL dark spot-check
/// still needs the app run on a device/emulator (manual step).
///
/// V3-M6 extends the list with the previously-uncovered high-risk leaves
/// (color-picker ring, donut wedges seeded with the low-luminance slate/violet
/// swatches, legend, trend chart, amount field, segmented/chip controls, a
/// critical budget badge) AND the new V3-M1..M5 feature leaves that render
/// cleanly in isolation (the security PIN pad, the search active-filter chips) —
/// dark render-safety evidence for the new features, whose page-level screens
/// are covered by their own dark tests (calendar / lock screen).
void main() {
  // Fixtures for the two budget cards (BudgetStatus is a runtime factory, so
  // these can't be const): one under-budget, one over-budget — the over case
  // exercises the `remaining < 0` / critical-color branches.
  const period = '2026-07';
  final now = DateTime(2026, 7, 15);
  // The July cycle bounds (== BudgetCycle.range(1, …) at start-day 1).
  final periodStart = DateTime(2026, 7).millisecondsSinceEpoch;
  final periodEnd = DateTime(2026, 8).millisecondsSinceEpoch;
  BudgetStatus statusOf(int spent) => BudgetStatus.compute(
    limitAmount: 1000000,
    spent: spent,
    now: now,
    periodStart: periodStart,
    periodEnd: periodEnd,
  );
  const category = Category(id: 1, name: 'Makan', type: CategoryType.expense);

  // Donut/legend slices seeded with the two lowest-luminance category swatches
  // (slate #64748B + violet #8B5CF6) — the F3 candidates — so the wedges + the
  // legend avatars actually render those hues on the dark surface.
  const donutSlices = [
    CategorySlice(
      categoryId: 1,
      name: 'Slate',
      amount: 300000,
      pct: 0.6,
      color: 0xFF64748B,
    ),
    CategorySlice(
      categoryId: 2,
      name: 'Violet',
      amount: 200000,
      pct: 0.4,
      color: 0xFF8B5CF6,
    ),
  ];

  // Two-point trend so the line (not just a dot) + area fill + axis labels draw.
  final trendPoints = [
    TrendPoint(
      monthMillis: DateTime(2026, 6).millisecondsSinceEpoch,
      netWorth: 5000000,
    ),
    TrendPoint(
      monthMillis: DateTime(2026, 7).millisecondsSinceEpoch,
      netWorth: 5250000,
    ),
  ];

  // The amount field owns its controller; dispose it once after the run.
  final amountController = TextEditingController(text: '25000');
  tearDownAll(amountController.dispose);

  // A representative set of the theme-consuming widgets across M1–M5 + M6.
  final darkWidgets = <Widget>[
    // Home cards.
    const TotalBalanceCard(
      totalBalance: 8450000,
      monthIncome: 7000000,
      monthExpense: 3250000,
    ),
    const DailyReviewCard(
      todaySpent: 128000,
      todayUnplanned: 45000,
      topCategoryName: 'Makan',
    ),
    const BudgetGuardCard(),
    const BudgetGuardCard(
      guard: BudgetGuardView(
        categoryName: 'Makan',
        remaining: -50000,
        safeDaily: 0,
        ratio: 1.2,
        level: BudgetStatusLevel.critical,
      ),
    ),
    // Budget list card — under + over budget.
    BudgetItemCard(
      budget: const Budget(
        categoryId: 1,
        period: period,
        limitAmount: 1000000,
        spent: 300000,
      ),
      status: statusOf(300000),
      category: category,
      onDelete: () {},
    ),
    BudgetItemCard(
      budget: const Budget(
        categoryId: 2,
        period: period,
        limitAmount: 1000000,
        spent: 1200000,
      ),
      status: statusOf(1200000),
      category: category,
    ),
    // Critical budget status pill (warning/critical tint on dark).
    const BudgetStatusBadge(level: BudgetStatusLevel.critical),
    // Core ledger row (subtitle + badges hit surfaceSoft / textSecondary).
    const TransactionTile(
      title: 'Kopi',
      subtitle: 'Makan • Cash',
      amount: 25000,
      sign: MoneySign.expense,
      badges: ['Need', 'Planned'],
    ),
    // Insight cards — all four types hit warning / critical / transfer / info.
    const InsightCard(
      item: InsightItem(type: InsightType.warning, category: 'Kopi', pct: 80),
    ),
    const InsightCard(
      item: InsightItem(type: InsightType.critical, category: 'Kopi'),
    ),
    const InsightCard(
      item: InsightItem(type: InsightType.trendUp, category: 'Makan', pct: 25),
    ),
    const InsightCard(item: InsightItem(type: InsightType.tip)),
    const MonthlyOverviewCard(
      income: 5000000,
      expense: 6000000,
      saved: -1000000,
    ),
    // Insight donut + legend seeded with the low-luminance slate/violet swatches
    // (F3 candidates) — the center total + wedges + legend avatars on dark.
    const ExpenseDonutChart(
      slices: donutSlices,
      totalExpense: 500000,
      categoriesById: {},
    ),
    const CategoryLegend(slices: donutSlices, categoriesById: {}),
    // Money Story trend chart — line + area fill in the income accent on dark.
    AssetTrendChart(points: trendPoints),
    // Amount entry pill (surface/border + Rp prefix on dark).
    AmountInputField(controller: amountController),
    // Segmented control + choice chips (selected primary pill / primaryLight
    // chip on dark).
    SegmentedControl<int>(
      options: const [
        SegmentOption(value: 0, label: 'Day'),
        SegmentOption(value: 1, label: 'Week'),
        SegmentOption(value: 2, label: 'Month'),
      ],
      selected: 0,
      onChanged: (_) {},
    ),
    ChoiceChipGroup<int>(
      options: const [
        ChipOption(value: 0, label: 'Need'),
        ChipOption(value: 1, label: 'Want'),
      ],
      selected: 0,
      onChanged: (_) {},
    ),
    // The shared color-picker sheet — its selection ring (F2) on the dark sheet.
    // Bounded height because AppBottomSheet roots a Flexible, which a Column
    // under unbounded scroll height can't lay out.
    const SizedBox(
      height: 360,
      child: ColorPickerSheet(title: 'Color', selected: 0xFF64748B),
    ),
    // ── New V3-M1..M5 feature leaves (dark render-safety evidence) ──────────
    // Security (M4): the PIN pad dots + numeric keypad on dark.
    PinPad(enteredCount: 3, onDigit: (_) {}, onBackspace: () {}),
    // Search (M3): the active-filter chips — the classic dark-contrast trap.
    ActiveFilterChips(
      params: const SearchTransactionParams(
        type: TransactionType.expense,
        hasReceipt: true,
      ),
      accountName: (_) => null,
      categoryName: (_) => null,
      onRemove: (_) {},
      onClearAll: () {},
    ),
    // Settings option rows (Appearance / language selectors).
    HairlineCard(
      children: [
        SettingOptionTile(label: 'Dark', selected: true, onTap: () {}),
        SettingOptionTile(label: 'Light', selected: false, onTap: () {}),
      ],
    ),
    // ── Onboarding (V5-M1) — icon-led heroes + the summary card on dark ──────
    // These pump WITHOUT a BlocProvider, which is exactly why the step widgets
    // take their data as constructor params.
    const WelcomeStep(),
    const ValuePropositionStep(),
    AccountSetupStep(accounts: const [], onSuggestionTap: (_) {}),
    AccountSetupStep(
      accounts: const [
        Account(
          id: 1,
          name: 'BCA',
          type: AccountType.bank,
          openingBalance: 4500000,
          icon: 'bank',
        ),
        // Rp0 must render as a normal amount, never greyed (§20).
        Account(id: 2, name: 'Cash', type: AccountType.cash, icon: 'wallet'),
      ],
      onSuggestionTap: (_) {},
    ),
    const SetupSummaryStep(accountCount: 3, totalOpeningBalance: 4500000),
    const OnboardingProgressDots(step: OnboardingStep.accounts),
  ];

  testWidgets('theme-consuming cards render under AppTheme.dark with no crash', (
    tester,
  ) async {
    await pumpApp(
      tester,
      // Column (not a lazy ListView) so every card actually builds — a lazy
      // list would cull off-screen cards and skip their dark render.
      SingleChildScrollView(child: Column(children: darkWidgets)),
      theme: AppTheme.dark,
    );

    // The core assertion: the dark AppPalette resolved everywhere, no widget
    // threw during build/layout.
    expect(tester.takeException(), isNull);
    // Sanity: the tree actually built (takeException passes on an empty tree).
    expect(find.byType(InsightCard), findsNWidgets(4));
    expect(find.text('Rp 8.450.000'), findsOneWidget);
    // The new-feature + high-risk leaves are present (not culled).
    expect(find.byType(ExpenseDonutChart), findsOneWidget);
    expect(find.byType(AssetTrendChart), findsOneWidget);
    expect(find.byType(ColorPickerSheet), findsOneWidget);
    expect(find.byType(PinPad), findsOneWidget);
    expect(find.byType(ActiveFilterChips), findsOneWidget);
    expect(find.byType(SetupSummaryStep), findsOneWidget);
    expect(find.byType(OnboardingProgressDots), findsOneWidget);
  });

  testWidgets('dark cards survive 1.3x Dynamic Type with no overflow', (
    tester,
  ) async {
    await pumpApp(
      tester,
      SingleChildScrollView(child: Column(children: darkWidgets)),
      theme: AppTheme.dark,
      textScaler: const TextScaler.linear(1.3),
    );

    // No RenderFlex overflow / layout throw at the 1.3× Dynamic-Type ceiling.
    expect(tester.takeException(), isNull);
  });

  testWidgets('dark cards settle under reduced motion (no infinite animation)', (
    tester,
  ) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: SingleChildScrollView(child: Column(children: darkWidgets)),
        ),
      ),
      theme: AppTheme.dark,
    );

    // Charts/shimmer honour disableAnimations → the frame settles (no infinite
    // pump), and nothing threw building under dark + reduced motion.
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
