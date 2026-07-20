import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders its label', (tester) async {
      await pumpApp(tester, PrimaryButton(label: 'Save', onPressed: () {}));
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('invokes onPressed when tapped', (tester) async {
      var tapped = false;
      await pumpApp(
        tester,
        PrimaryButton(label: 'Save', onPressed: () => tapped = true),
      );
      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await pumpApp(
        tester,
        const PrimaryButton(label: 'Save', onPressed: null),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows a spinner and is disabled while loading', (
      tester,
    ) async {
      var tapped = false;
      await pumpApp(
        tester,
        PrimaryButton(
          label: 'Save',
          onPressed: () => tapped = true,
          isLoading: true,
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Save'), findsNothing);

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('renders a leading icon when provided', (tester) async {
      await pumpApp(
        tester,
        PrimaryButton(label: 'Add', onPressed: () {}, icon: Icons.add),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });
  });

  group('SecondaryButton', () {
    testWidgets('renders its label and invokes onPressed', (tester) async {
      var tapped = false;
      await pumpApp(
        tester,
        SecondaryButton(label: 'Cancel', onPressed: () => tapped = true),
      );
      expect(find.text('Cancel'), findsOneWidget);
      await tester.tap(find.byType(SecondaryButton));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  group('TextButtonX', () {
    testWidgets('renders its label and invokes onPressed', (tester) async {
      var tapped = false;
      await pumpApp(
        tester,
        TextButtonX(label: 'See All', onPressed: () => tapped = true),
      );
      expect(find.text('See All'), findsOneWidget);
      await tester.tap(find.byType(TextButtonX));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('shows a spinner and is disabled while loading', (
      tester,
    ) async {
      var tapped = false;
      await pumpApp(
        tester,
        TextButtonX(
          label: 'Quick Start',
          onPressed: () => tapped = true,
          isLoading: true,
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Quick Start'), findsNothing);

      await tester.tap(find.byType(TextButtonX));
      await tester.pump();
      expect(tapped, isFalse);
    });
  });
}
