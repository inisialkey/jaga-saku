import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('MoneyText', () {
    testWidgets('income renders a +Rp amount in the income color', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const MoneyText(amount: 20000, sign: MoneySign.income),
      );
      final text = tester.widget<Text>(find.text('+Rp 20.000'));
      // Light mode resolves to the text-safe income variant (WCAG AA).
      expect(text.style?.color, AppPalette.light.income);
    });

    testWidgets('expense renders a -Rp amount in the expense color', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const MoneyText(amount: 5000, sign: MoneySign.expense),
      );
      final text = tester.widget<Text>(find.text('-Rp 5.000'));
      expect(text.style?.color, AppPalette.light.expense);
    });

    testWidgets(
      'transfer renders an unsigned Rp amount in the transfer color',
      (tester) async {
        await pumpApp(
          tester,
          const MoneyText(amount: 1000, sign: MoneySign.transfer),
        );
        final text = tester.widget<Text>(find.text('Rp 1.000'));
        expect(text.style?.color, AppPalette.light.transfer);
      },
    );

    testWidgets('neutral renders an unsigned Rp amount without a sign', (
      tester,
    ) async {
      await pumpApp(tester, const MoneyText(amount: 100));
      expect(find.text('Rp 100'), findsOneWidget);
    });
  });
}
