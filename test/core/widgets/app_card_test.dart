import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppCard', () {
    testWidgets('renders its child', (tester) async {
      await pumpApp(tester, const AppCard(child: Text('Balance')));
      expect(find.text('Balance'), findsOneWidget);
    });

    testWidgets('is not tappable (no InkWell) when onTap is null', (
      tester,
    ) async {
      await pumpApp(tester, const AppCard(child: Text('Balance')));
      expect(
        find.descendant(
          of: find.byType(AppCard),
          matching: find.byType(InkWell),
        ),
        findsNothing,
      );
    });

    testWidgets('invokes onTap when tapped', (tester) async {
      var tapped = false;
      await pumpApp(
        tester,
        AppCard(onTap: () => tapped = true, child: const Text('Balance')),
      );
      await tester.tap(find.byType(AppCard));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });
}
