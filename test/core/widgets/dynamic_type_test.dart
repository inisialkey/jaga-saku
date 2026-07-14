import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/home/pages/home_cubit.dart';
import 'package:jaga_saku/features/home/pages/widgets/favorites_strip.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

import '../../helpers/pump_app.dart';

/// Dynamic Type regression suite (UI Tranche E): every text-bearing core widget
/// re-flowed at the clamp ceiling `TextScaler.linear(1.3)` (matching
/// `lib/app.dart`'s `clamp(1.0, 1.3)`), asserting it lays out without a
/// RenderFlex/overflow exception and still shows its representative label.
///
/// Seven of these are "leave-as-is" guards (their touch-target boxes already
/// have 11–36px of vertical slack at 1.3×). Two are the definite-height fixers
/// ([AppBottomNav], [FavoritesStrip]) — for those we also assert the box grew to
/// ~1.3× its base so the fix (scaling the height) can never silently regress to
/// a fixed height.
void main() {
  const scale = 1.3;
  const scaler = TextScaler.linear(scale);

  Future<void> pumpAt13(
    WidgetTester tester,
    Widget child, {
    bool scaffold = true,
  }) => pumpApp(tester, child, scaffold: scaffold, textScaler: scaler);

  group('Dynamic Type 1.3× — leave-as-is guards', () {
    testWidgets('SegmentedControl', (tester) async {
      await pumpAt13(
        tester,
        SegmentedControl<String>(
          options: const [
            SegmentOption(value: 'expense', label: 'Expense'),
            SegmentOption(value: 'income', label: 'Income'),
          ],
          selected: 'expense',
          onChanged: (_) {},
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Expense'), findsOneWidget);
    });

    testWidgets('PrimaryButton', (tester) async {
      await pumpAt13(tester, PrimaryButton(label: 'Save', onPressed: () {}));
      expect(tester.takeException(), isNull);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('SecondaryButton', (tester) async {
      await pumpAt13(
        tester,
        SecondaryButton(label: 'Cancel', onPressed: () {}),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('ChoiceChipGroup', (tester) async {
      await pumpAt13(
        tester,
        ChoiceChipGroup<int>(
          options: const [
            ChipOption(value: 1, label: 'Food'),
            ChipOption(value: 2, label: 'Transport'),
          ],
          selected: 1,
          onChanged: (_) {},
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Food'), findsOneWidget);
    });

    testWidgets('AmountInputField', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await pumpAt13(tester, AmountInputField(controller: controller));
      expect(tester.takeException(), isNull);
      expect(find.text('Rp'), findsOneWidget);
    });

    testWidgets('SelectorField', (tester) async {
      await pumpAt13(
        tester,
        SelectorField(label: 'Category', value: 'Food', onTap: () {}),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Category'), findsOneWidget);
    });

    testWidgets('ConfirmSheet (longest real message)', (tester) async {
      await pumpAt13(
        tester,
        const ConfirmSheet(
          title: 'Leave without saving?',
          // The longest ConfirmSheet copy in the app (unsavedChangesMessage).
          message: 'You have unsaved changes. Leaving now will discard them.',
          confirmLabel: 'Discard',
          cancelLabel: 'Keep editing',
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Discard'), findsOneWidget);
    });

    testWidgets('CalculatorKeypadSheet', (tester) async {
      await pumpAt13(tester, const CalculatorKeypadSheet());
      expect(tester.takeException(), isNull);
      expect(find.text('= Rp 0'), findsOneWidget);
    });
  });

  group('Dynamic Type 1.3× — definite-height fixers', () {
    const navItems = [
      BottomNavItem(icon: Icons.home_outlined, label: 'Home'),
      BottomNavItem(icon: Icons.bar_chart_outlined, label: 'Reports'),
      BottomNavItem(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Budget',
      ),
      BottomNavItem(icon: Icons.person_outline, label: 'Profile'),
    ];

    testWidgets('AppBottomNav grows its height with the text', (tester) async {
      await pumpAt13(
        tester,
        AppBottomNav(items: navItems, currentIndex: 0, onTap: (_) {}),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Home'), findsOneWidget);
      // Base height 72 scaled by 1.3× — proves the fix stays scaled, never a
      // fixed 72 that would clip the 2-line labels.
      expect(
        tester.getSize(find.byType(AppBottomNav)).height,
        closeTo(72 * scale, 0.5),
      );
    });

    testWidgets('FavoritesStrip grows its strip height with the text', (
      tester,
    ) async {
      const dashboard = HomeDashboard(
        totalBalance: 0,
        monthIncome: 0,
        monthExpense: 0,
        todaySpent: 0,
        todayUnplanned: 0,
      );
      const favorites = [
        TxTemplate(
          id: 1,
          label: 'Coffee',
          type: TransactionType.expense,
          accountId: 1,
          amount: 15000,
          categoryId: 1,
        ),
      ];
      await pumpAt13(
        tester,
        const FavoritesStrip(favorites: favorites, dashboard: dashboard),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Coffee'), findsOneWidget);
      // The strip's SizedBox (base 108) scaled by 1.3× — measured via its
      // horizontal ListView which fills that box exactly.
      final strip = find.descendant(
        of: find.byType(FavoritesStrip),
        matching: find.byType(ListView),
      );
      expect(tester.getSize(strip).height, closeTo(108 * scale, 0.5));
    });
  });
}
