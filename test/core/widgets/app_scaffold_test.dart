import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppScaffold', () {
    testWidgets('renders its body', (tester) async {
      await pumpApp(
        tester,
        const AppScaffold(body: Text('Home')),
        scaffold: false,
      );
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('renders the provided app bar', (tester) async {
      await pumpApp(
        tester,
        AppScaffold(
          appBar: AppBar(title: const Text('Wallet')),
          body: const SizedBox.shrink(),
        ),
        scaffold: false,
      );
      expect(find.text('Wallet'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('wraps the body in page padding when padded is true', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const AppScaffold(padded: true, body: Text('Padded')),
        scaffold: false,
      );
      final padding = tester.widget<Padding>(
        find
            .ancestor(of: find.text('Padded'), matching: find.byType(Padding))
            .first,
      );
      expect(
        padding.padding,
        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      );
    });
  });
}
