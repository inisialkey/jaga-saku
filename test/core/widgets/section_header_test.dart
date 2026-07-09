import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('SectionHeader', () {
    testWidgets('renders its title', (tester) async {
      await pumpApp(tester, const SectionHeader(title: 'Recent'));
      expect(find.text('Recent'), findsOneWidget);
    });

    testWidgets('shows no action when actionLabel is absent', (tester) async {
      await pumpApp(tester, const SectionHeader(title: 'Recent'));
      expect(find.byType(TextButtonX), findsNothing);
    });

    testWidgets('renders a trailing action that fires onAction', (
      tester,
    ) async {
      var tapped = false;
      await pumpApp(
        tester,
        SectionHeader(
          title: 'Recent',
          actionLabel: 'See All',
          onAction: () => tapped = true,
        ),
      );
      expect(find.text('See All'), findsOneWidget);
      await tester.tap(find.text('See All'));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });
}
