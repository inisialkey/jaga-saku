import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/insight/pages/insight_cubit.dart';
import 'package:jaga_saku/features/insight/pages/insight_rules.dart';
import 'package:jaga_saku/features/insight/pages/widgets/expense_donut_chart.dart';
import 'package:jaga_saku/features/insight/pages/widgets/insight_card.dart';
import 'package:jaga_saku/features/insight/pages/widgets/monthly_overview_card.dart';
import 'package:jaga_saku/features/insight/pages/widgets/need_want_card.dart';
import 'package:jaga_saku/features/insight/pages/widgets/planned_unplanned_card.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

import '../../../../helpers/pump_app.dart';

/// Focused value-in widget tests for the Insight cards + their per-section empty
/// states (Strings resolve in EN — pumpApp default).
void main() {
  group('MonthlyOverviewCard', () {
    testWidgets('shows income, expense and saved amounts', (tester) async {
      await pumpApp(
        tester,
        const MonthlyOverviewCard(
          income: 7000000,
          expense: 2000000,
          saved: 5000000,
        ),
      );
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Rp 7.000.000'), findsOneWidget);
      expect(find.text('Rp 2.000.000'), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Rp 5.000.000'), findsOneWidget);
    });
  });

  group('ExpenseDonutChart', () {
    testWidgets('renders the donut + legend with names and percents', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const ExpenseDonutChart(
          totalExpense: 2000000,
          categoriesById: {
            1: Category(id: 1, name: 'Makan', type: CategoryType.expense),
            2: Category(id: 2, name: 'Transport', type: CategoryType.expense),
          },
          slices: [
            CategorySlice(
              categoryId: 1,
              name: 'Makan',
              amount: 1000000,
              pct: 0.5,
              color: 0xFFEF4444,
            ),
            CategorySlice(
              categoryId: 2,
              name: 'Transport',
              amount: 1000000,
              pct: 0.5,
            ),
          ],
        ),
      );
      expect(find.byType(PieChart), findsOneWidget);
      expect(find.text('Makan'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);
      expect(find.text('50%'), findsNWidgets(2));
    });

    testWidgets('empty slices show the friendly empty state, no chart', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const ExpenseDonutChart(
          slices: [],
          totalExpense: 0,
          categoriesById: {},
        ),
      );
      expect(find.byType(PieChart), findsNothing);
      expect(find.text('No expenses this month yet'), findsOneWidget);
    });
  });

  group('PlannedUnplannedCard', () {
    testWidgets('shows both bars with amounts and percents', (tester) async {
      await pumpApp(
        tester,
        const PlannedUnplannedCard(
          split: PlannedSplit(
            planned: 1600000,
            unplanned: 400000,
            plannedPct: 0.8,
            unplannedPct: 0.2,
          ),
        ),
      );
      expect(find.text('Planned'), findsOneWidget);
      expect(find.text('Unplanned'), findsOneWidget);
      expect(find.text('Rp 1.600.000'), findsOneWidget);
      expect(find.text('80%'), findsOneWidget);
      expect(find.text('20%'), findsOneWidget);
    });

    testWidgets('empty split shows the section empty hint', (tester) async {
      await pumpApp(tester, const PlannedUnplannedCard(split: PlannedSplit()));
      expect(find.text('No data this month yet'), findsOneWidget);
    });
  });

  group('NeedWantCard', () {
    testWidgets('shows a row per present spending type', (tester) async {
      await pumpApp(
        tester,
        const NeedWantCard(
          needVsWant: {
            SpendingType.need: SpendingSlice(amount: 1600000, pct: 0.8),
            SpendingType.want: SpendingSlice(amount: 400000, pct: 0.2),
          },
        ),
      );
      expect(find.text('Need'), findsOneWidget);
      expect(find.text('Want'), findsOneWidget);
      expect(find.text('80%'), findsOneWidget);
      expect(find.text('20%'), findsOneWidget);
    });

    testWidgets('empty map shows the section empty hint', (tester) async {
      await pumpApp(tester, const NeedWantCard(needVsWant: {}));
      expect(find.text('No data this month yet'), findsOneWidget);
    });
  });

  group('InsightCard', () {
    testWidgets('renders the localized budget-warning copy', (tester) async {
      await pumpApp(
        tester,
        const InsightCard(
          item: InsightItem(
            type: InsightType.warning,
            category: 'Kopi',
            pct: 80,
          ),
        ),
      );
      expect(find.text('Budget Kopi is 80% used this month.'), findsOneWidget);
    });

    testWidgets('renders the localized category-up copy', (tester) async {
      await pumpApp(
        tester,
        const InsightCard(
          item: InsightItem(
            type: InsightType.trendUp,
            category: 'Makan',
            pct: 25,
          ),
        ),
      );
      expect(
        find.text('Makan spending is up 25% from last month.'),
        findsOneWidget,
      );
    });

    testWidgets('renders the localized unplanned-up tip copy', (tester) async {
      await pumpApp(
        tester,
        const InsightCard(item: InsightItem(type: InsightType.tip)),
      );
      expect(
        find.text('Unplanned spending is higher than last month.'),
        findsOneWidget,
      );
    });

    testWidgets('renders the localized budget-over critical copy + icon', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const InsightCard(
          item: InsightItem(type: InsightType.critical, category: 'Kopi'),
        ),
      );
      expect(
        find.text('Budget Kopi is over the limit this month.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });
  });
}
