import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  late TextEditingController controller;

  setUp(() => controller = TextEditingController());
  tearDown(() => controller.dispose());

  group('AmountInputField', () {
    testWidgets('renders the Rp prefix and the hint', (tester) async {
      await pumpApp(tester, AmountInputField(controller: controller));
      expect(find.text('Rp'), findsOneWidget);
      expect(find.text('0'), findsOneWidget); // default hint
    });

    testWidgets('writes typed digits to the controller and calls onChanged', (
      tester,
    ) async {
      String? changed;
      await pumpApp(
        tester,
        AmountInputField(controller: controller, onChanged: (v) => changed = v),
      );
      await tester.enterText(find.byType(TextField), '25000');
      await tester.pump();
      expect(controller.text, '25000');
      expect(changed, '25000');
    });

    testWidgets('strips non-digit characters via the input formatter', (
      tester,
    ) async {
      await pumpApp(tester, AmountInputField(controller: controller));
      await tester.enterText(find.byType(TextField), '12a3b');
      await tester.pump();
      expect(controller.text, '123');
    });
  });
}
