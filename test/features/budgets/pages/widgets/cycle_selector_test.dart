import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/budgets/pages/widgets/cycle_selector.dart';

import '../../../../helpers/pump_app.dart';

/// The Budget-only cycle stepper (V2-M1). Renders the INCLUSIVE end of the
/// half-open `[start, end)` window and fires its chevron callbacks. MonthSelector
/// is FROZEN — this is a separate widget, so Insight/MoneyStory carry no risk.
void main() {
  int ms(int y, int m, int d) => DateTime(y, m, d).millisecondsSinceEpoch;

  testWidgets('renders the inclusive cycle range (25 Jul – 24 Agu)', (
    tester,
  ) async {
    await pumpApp(
      tester,
      CycleSelector(
        start: ms(2026, 7, 25),
        end: ms(2026, 8, 25), // half-open → inclusive end is 24 Agu
        onPrevious: () {},
        onNext: () {},
      ),
    );

    // One Text widget carrying "25 Jul – 24 Agu" (end − 1 day, hand-rolled ID
    // short months). Substring matches avoid depending on the en-dash byte.
    expect(find.textContaining('25 Jul'), findsOneWidget);
    expect(find.textContaining('24 Agu'), findsOneWidget);
  });

  testWidgets('chevrons fire onPrevious / onNext', (tester) async {
    var prev = 0;
    var next = 0;
    await pumpApp(
      tester,
      CycleSelector(
        start: ms(2026, 7, 25),
        end: ms(2026, 8, 25),
        onPrevious: () => prev++,
        onNext: () => next++,
      ),
    );

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pump();

    expect(prev, 1);
    expect(next, 1);
  });
}
