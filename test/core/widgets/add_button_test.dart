import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AddButton', () {
    testWidgets('renders the plus icon and invokes onPressed when tapped', (
      tester,
    ) async {
      var tapped = false;
      await pumpApp(tester, AddButton(onPressed: () => tapped = true));
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      await tester.tap(find.byType(AddButton));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('exposes a localized "Add" semantics label', (tester) async {
      await pumpApp(tester, AddButton(onPressed: () {}));
      expect(find.bySemanticsLabel('Add'), findsOneWidget);
    });
  });
}
