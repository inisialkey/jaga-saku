import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('EmptyStateView', () {
    testWidgets('renders title, message and the default icon', (tester) async {
      await pumpApp(
        tester,
        const EmptyStateView(
          title: 'Nothing here',
          message: 'Add one to start',
        ),
      );
      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Add one to start'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('shows no action button when actionLabel is absent', (
      tester,
    ) async {
      await pumpApp(tester, const EmptyStateView(title: 'Empty'));
      expect(find.byType(PrimaryButton), findsNothing);
    });

    testWidgets('renders a CTA that invokes onAction when tapped', (
      tester,
    ) async {
      var tapped = false;
      await pumpApp(
        tester,
        EmptyStateView(
          title: 'Empty',
          actionLabel: 'Add',
          onAction: () => tapped = true,
        ),
      );
      expect(find.text('Add'), findsOneWidget);
      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  group('ErrorStateView', () {
    testWidgets('renders title and its default error icon', (tester) async {
      await pumpApp(tester, const ErrorStateView(title: 'Something broke'));
      expect(find.text('Something broke'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('renders a retry CTA that invokes onRetry when tapped', (
      tester,
    ) async {
      var retried = false;
      await pumpApp(
        tester,
        ErrorStateView(
          title: 'Failed',
          retryLabel: 'Try again',
          onRetry: () => retried = true,
        ),
      );
      await tester.tap(find.text('Try again'));
      await tester.pump();
      expect(retried, isTrue);
    });
  });
}
