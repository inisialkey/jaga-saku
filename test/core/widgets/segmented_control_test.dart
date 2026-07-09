import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  const options = [
    SegmentOption(value: 'expense', label: 'Expense'),
    SegmentOption(value: 'income', label: 'Income'),
  ];

  group('SegmentedControl', () {
    testWidgets('renders every option label', (tester) async {
      await pumpApp(
        tester,
        SegmentedControl<String>(
          options: options,
          selected: 'expense',
          onChanged: (_) {},
        ),
      );
      expect(find.text('Expense'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
    });

    testWidgets('reports the value of the tapped segment', (tester) async {
      String? changed;
      await pumpApp(
        tester,
        SegmentedControl<String>(
          options: options,
          selected: 'expense',
          onChanged: (v) => changed = v,
        ),
      );
      await tester.tap(find.text('Income'));
      await tester.pump();
      expect(changed, 'income');
    });
  });
}
