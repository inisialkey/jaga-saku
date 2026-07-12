import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  Future<void> tapKey(WidgetTester tester, String id) async {
    await tester.tap(find.byKey(ValueKey(id)));
    await tester.pump();
  }

  group('CalculatorKeypadSheet', () {
    testWidgets('tapping digits builds a grouped expression and live result', (
      tester,
    ) async {
      await pumpApp(tester, const CalculatorKeypadSheet());
      for (final id in const [
        'calcKey_1',
        'calcKey_2',
        'calcKey_0',
        'calcKey_0',
      ]) {
        await tapKey(tester, id);
      }
      expect(find.text('1.200'), findsOneWidget); // expression line
      expect(find.text('= Rp 1.200'), findsOneWidget); // live result
    });

    testWidgets('an operator then equals collapses the expression', (
      tester,
    ) async {
      await pumpApp(tester, const CalculatorKeypadSheet());
      for (final id in const [
        'calcKey_1',
        'calcKey_2',
        'calcKey_0',
        'calcKey_0',
        'calcKey_add',
        'calcKey_5',
        'calcKey_0',
        'calcKey_0',
        'calcKey_equals',
      ]) {
        await tapKey(tester, id);
      }
      expect(find.text('1.700'), findsOneWidget);
      expect(find.text('= Rp 1.700'), findsOneWidget);
    });

    testWidgets('clear empties the expression', (tester) async {
      await pumpApp(tester, const CalculatorKeypadSheet(initial: '999'));
      await tapKey(tester, 'calcKey_clear');
      // '0' collides with the "0" key, so assert on the result line only.
      expect(find.text('= Rp 0'), findsOneWidget);
    });

    testWidgets('backspace removes the last character', (tester) async {
      await pumpApp(tester, const CalculatorKeypadSheet(initial: '1200'));
      await tapKey(tester, 'calcKey_backspace');
      expect(find.text('120'), findsOneWidget);
      expect(find.text('= Rp 120'), findsOneWidget);
    });

    testWidgets('seeds the expression from the initial value', (tester) async {
      await pumpApp(tester, const CalculatorKeypadSheet(initial: '15500'));
      expect(find.text('15.500'), findsOneWidget);
      expect(find.text('= Rp 15.500'), findsOneWidget);
    });

    testWidgets('returns the evaluated integer when Done is tapped', (
      tester,
    ) async {
      int? result;
      await pumpApp(
        tester,
        Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () async {
                result = await CalculatorKeypadSheet.show(context);
              },
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      for (final id in const [
        'calcKey_1',
        'calcKey_5',
        'calcKey_5',
        'calcKey_0',
        'calcKey_0',
      ]) {
        await tapKey(tester, id);
      }
      await tester.tap(find.byKey(const ValueKey('calcDone')));
      await tester.pumpAndSettle();
      expect(result, 15500);
    });

    testWidgets('long-press pastes digits, stripping non-digits', (
      tester,
    ) async {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async => call.method == 'Clipboard.getData'
            ? <String, Object?>{'text': 'Rp 9.999'}
            : null,
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await pumpApp(tester, const CalculatorKeypadSheet());
      // The expression placeholder '0' is the first '0' in tree order.
      await tester.longPress(find.text('0').first);
      await tester.pump();
      expect(find.text('9.999'), findsOneWidget);
      expect(find.text('= Rp 9.999'), findsOneWidget);
    });
  });
}
