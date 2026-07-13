import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/pages/widgets/budget_item_card.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/home/pages/home_cubit.dart';
import 'package:jaga_saku/features/home/pages/widgets/budget_guard_card.dart';
import 'package:jaga_saku/features/home/pages/widgets/daily_review_card.dart';
import 'package:jaga_saku/features/home/pages/widgets/total_balance_card.dart';
import 'package:jaga_saku/features/insight/pages/insight_rules.dart';
import 'package:jaga_saku/features/insight/pages/widgets/insight_card.dart';
import 'package:jaga_saku/features/insight/pages/widgets/monthly_overview_card.dart';
import 'package:jaga_saku/features/settings/pages/widgets/setting_option_tile.dart';

import 'helpers/pump_app.dart';

/// Dark-theme render smoke test (M6 §8). Dark mode became app-reachable in M6
/// (Appearance → Dark/System), so the M1–M5 cards render under [AppPalette.dark]
/// for the first time. This is an automated **no-crash proxy**: it pumps the
/// heaviest `context.colors` consumers under [AppTheme.dark] and asserts they
/// build with no exception — proving the dark palette extension resolves
/// everywhere (no missing-color / null crash). A true VISUAL dark spot-check
/// still needs the app run on a device/emulator (manual step).
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
    // Settings option rows (Appearance / language selectors).
    HairlineCard(
      children: [
        SettingOptionTile(label: 'Dark', selected: true, onTap: () {}),
        SettingOptionTile(label: 'Light', selected: false, onTap: () {}),
      ],
    ),
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
  });
}
