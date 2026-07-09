import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  const items = [
    BottomNavItem(icon: Icons.home_outlined, label: 'Home'),
    BottomNavItem(icon: Icons.bar_chart_outlined, label: 'Reports'),
    BottomNavItem(icon: Icons.account_balance_wallet_outlined, label: 'Budget'),
    BottomNavItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  group('AppBottomNav', () {
    testWidgets('renders every item label and icon', (tester) async {
      await pumpApp(
        tester,
        AppBottomNav(items: items, currentIndex: 0, onTap: (_) {}),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Reports'), findsOneWidget);
      expect(find.text('Budget'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    });

    testWidgets('reports the tapped index across the center gap', (
      tester,
    ) async {
      int? tappedIndex;
      await pumpApp(
        tester,
        AppBottomNav(
          items: items,
          currentIndex: 0,
          onTap: (i) => tappedIndex = i,
        ),
      );
      // 'Budget' is the first item after the reserved center gap -> index 2.
      await tester.tap(find.text('Budget'));
      await tester.pump();
      expect(tappedIndex, 2);
    });
  });
}
