import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

/// The V2-M4 receipt indicator on the shared ledger row: a paperclip appears
/// only when `hasReceipt` is true. A widget test (not a golden — the repo keeps
/// zero goldens) proving the optional flag drives the glyph without disturbing
/// the default render.
void main() {
  group('TransactionTile receipt indicator', () {
    testWidgets('shows a paperclip when hasReceipt is true', (tester) async {
      await pumpApp(
        tester,
        const TransactionTile(
          title: 'Kopi',
          amount: 15000,
          sign: MoneySign.expense,
          hasReceipt: true,
        ),
      );

      expect(find.byIcon(Icons.attach_file), findsOneWidget);
    });

    testWidgets('shows no paperclip by default', (tester) async {
      await pumpApp(
        tester,
        const TransactionTile(
          title: 'Kopi',
          amount: 15000,
          sign: MoneySign.expense,
        ),
      );

      expect(find.byIcon(Icons.attach_file), findsNothing);
    });
  });
}
