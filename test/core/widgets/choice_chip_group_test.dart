import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  const options = [
    ChipOption(value: 1, label: 'Food'),
    ChipOption(value: 2, label: 'Transport'),
  ];

  group('ChoiceChipGroup', () {
    testWidgets('renders every chip label', (tester) async {
      await pumpApp(
        tester,
        ChoiceChipGroup<int>(options: options, selected: 1, onChanged: (_) {}),
      );
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);
    });

    testWidgets('reports the value of the tapped chip', (tester) async {
      int? changed;
      await pumpApp(
        tester,
        ChoiceChipGroup<int>(
          options: options,
          selected: 1,
          onChanged: (v) => changed = v,
        ),
      );
      await tester.tap(find.text('Transport'));
      await tester.pump();
      expect(changed, 2);
    });
  });
}
