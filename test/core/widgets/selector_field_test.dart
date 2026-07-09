import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('SelectorField', () {
    testWidgets('renders label, value and a trailing chevron', (tester) async {
      await pumpApp(
        tester,
        SelectorField(label: 'Category', value: 'Food', onTap: () {}),
      );
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    });

    testWidgets('renders a leading icon when provided', (tester) async {
      await pumpApp(
        tester,
        SelectorField(label: 'Account', icon: Icons.wallet, onTap: () {}),
      );
      expect(find.byIcon(Icons.wallet), findsOneWidget);
    });

    testWidgets('invokes onTap when tapped', (tester) async {
      var tapped = false;
      await pumpApp(
        tester,
        SelectorField(label: 'Category', onTap: () => tapped = true),
      );
      await tester.tap(find.byType(SelectorField));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });
}
