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

    testWidgets('tapping opens the keypad and keeps the system keyboard shut', (
      tester,
    ) async {
      await pumpApp(tester, AmountInputField(controller: controller));
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(find.byType(CalculatorKeypadSheet), findsOneWidget);
      // A read-only field never opens an input connection.
      expect(tester.testTextInput.hasAnyClients, isFalse);
    });

    testWidgets('an expression confirmed with Done fires onChanged as an int '
        'string', (tester) async {
      String? changed;
      await pumpApp(
        tester,
        AmountInputField(controller: controller, onChanged: (v) => changed = v),
      );
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      for (final id in const [
        'calcKey_1',
        'calcKey_2',
        'calcKey_0',
        'calcKey_0',
        'calcKey_0',
        'calcKey_add',
        'calcKey_3',
        'calcKey_5',
        'calcKey_0',
        'calcKey_0',
      ]) {
        await tester.tap(find.byKey(ValueKey(id)));
        await tester.pump();
      }
      await tester.tap(find.byKey(const ValueKey('calcDone')));
      await tester.pumpAndSettle();
      // 12000 + 3500 evaluated to 15500, emitted as the plain int string.
      expect(controller.text, '15500');
      expect(changed, '15500');
    });
  });
}
