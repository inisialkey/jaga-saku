import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/home/pages/home_cubit.dart';
import 'package:jaga_saku/features/home/pages/widgets/budget_guard_card.dart';
import 'package:jaga_saku/features/home/pages/widgets/daily_review_card.dart';
import 'package:jaga_saku/features/home/pages/widgets/home_header.dart';
import 'package:jaga_saku/features/home/pages/widgets/total_balance_card.dart';

import '../../../../helpers/pump_app.dart';

/// Focused widget tests for the Home cards. They render pure value-in widgets
/// (no cubit / router), so they exercise the M3 UI without pulling the whole
/// app graph into coverage. Strings resolve in EN (pumpApp default).
void main() {
  group('HomeHeader', () {
    testWidgets('greets a known user by name', (tester) async {
      await pumpApp(tester, const HomeHeader(userName: 'Oki'));
      expect(find.text('Hi, Oki 👋'), findsOneWidget);
      // Tagline (reused appTagline) is shown under the greeting.
      expect(find.text('Track spending, understand habits.'), findsOneWidget);
    });

    testWidgets('falls back to the guest greeting when the name is null', (
      tester,
    ) async {
      await pumpApp(tester, const HomeHeader(userName: null));
      expect(find.text('Hi 👋'), findsOneWidget);
    });

    testWidgets('treats a blank name as guest', (tester) async {
      await pumpApp(tester, const HomeHeader(userName: '   '));
      expect(find.text('Hi 👋'), findsOneWidget);
    });
  });

  group('TotalBalanceCard', () {
    testWidgets('shows the label, balance and month income/expense', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const TotalBalanceCard(
          totalBalance: 8450000,
          monthIncome: 7000000,
          monthExpense: 3250000,
        ),
      );
      expect(find.text('Total Balance'), findsOneWidget);
      expect(find.text('Rp 8.450.000'), findsOneWidget);
      expect(find.text('Rp 7.000.000'), findsOneWidget);
      expect(find.text('Rp 3.250.000'), findsOneWidget);
    });
  });

  group('BudgetGuardCard', () {
    testWidgets('empty state now has a live CTA and no "coming soon" badge', (
      tester,
    ) async {
      await pumpApp(tester, const BudgetGuardCard());
      expect(find.text('Budget Guard'), findsOneWidget);
      expect(find.text('No budget yet'), findsOneWidget);
      // M4: the deferral badge is gone and the CTA now routes to the Budget
      // screen (onPressed != null).
      expect(find.text('Coming soon'), findsNothing);
      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Create Budget'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('renders the most at-risk budget when guard is set', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const BudgetGuardCard(
          guard: BudgetGuardView(
            categoryName: 'Makan',
            remaining: 250000,
            safeDaily: 25000,
            ratio: 0.9,
            level: BudgetStatusLevel.warning,
          ),
        ),
      );
      expect(find.text('Makan'), findsOneWidget);
      expect(find.text('Rp 250.000 left'), findsOneWidget);
      expect(find.text('Safe daily: Rp 25.000/day'), findsOneWidget);
      // Warning status badge → "Caution"; the empty-state copy is gone.
      expect(find.text('Caution'), findsOneWidget);
      expect(find.text('No budget yet'), findsNothing);
    });
  });

  group('DailyReviewCard', () {
    testWidgets(
      'shows spent, top category and unplanned when money was spent',
      (tester) async {
        await pumpApp(
          tester,
          const DailyReviewCard(
            todaySpent: 128000,
            todayUnplanned: 45000,
            topCategoryName: 'Makan',
          ),
        );
        expect(find.text('Daily Review'), findsOneWidget);
        expect(find.text("You've spent Rp 128.000"), findsOneWidget);
        expect(find.text('Top category: Makan'), findsOneWidget);
        expect(find.text('Unplanned: Rp 45.000'), findsOneWidget);
      },
    );

    testWidgets('shows the friendly zero-state when nothing was spent', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const DailyReviewCard(todaySpent: 0, todayUnplanned: 0),
      );
      expect(find.text('No spending today'), findsOneWidget);
      expect(find.textContaining("You've spent"), findsNothing);
    });
  });
}
