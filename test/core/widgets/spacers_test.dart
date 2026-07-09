import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  SizedBox boxOf(WidgetTester tester, Type widget) => tester.widget<SizedBox>(
    find.descendant(of: find.byType(widget), matching: find.byType(SizedBox)),
  );

  group('SpacerH', () {
    testWidgets('defaults to the small spacing width', (tester) async {
      await pumpApp(tester, const SpacerH());
      expect(boxOf(tester, SpacerH).width, AppSpacing.sm);
    });

    testWidgets('honours a custom width', (tester) async {
      await pumpApp(tester, const SpacerH(value: 24));
      expect(boxOf(tester, SpacerH).width, 24);
    });
  });

  group('SpacerV', () {
    testWidgets('defaults to the small spacing height', (tester) async {
      await pumpApp(tester, const SpacerV());
      expect(boxOf(tester, SpacerV).height, AppSpacing.sm);
    });

    testWidgets('honours a custom height', (tester) async {
      await pumpApp(tester, const SpacerV(value: 24));
      expect(boxOf(tester, SpacerV).height, 24);
    });
  });
}
