import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

import '../../helpers/pump_app.dart';

/// Real-font right-alignment guard for the shared [TransactionTile] money
/// column. The default flutter_test font is far wider than the real Plus Jakarta
/// Sans, so it masks a right-alignment regression: a loose `Flexible` around the
/// trailing `FittedBox` collapses to the amount's natural width, letting money
/// float left of the row's right edge and breaking the ledger column at 1.0× for
/// every user. This loads the REAL font so the amount's true (narrow) width is
/// used, then asserts the amount stays flush with the row's right edge at 1.0×
/// (the tight `Expanded` fix) and does not overflow at 1.3×.
void main() {
  setUpAll(() async {
    final loader = FontLoader('Plus Jakarta Sans')
      ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans-Variable.ttf'));
    await loader.load();
  });

  Widget tile() => const SizedBox(
    width: 359,
    child: TransactionTile(
      icon: 'food',
      title: 'Makan',
      subtitle: 'Makan • Cash',
      amount: 450000,
      sign: MoneySign.expense,
    ),
  );

  // Gap between the amount's right edge and the row's right edge; 0 == flush.
  double moneyFloat(WidgetTester tester) =>
      tester.getRect(find.byType(TransactionTile)).right -
      tester.getRect(find.byType(MoneyText)).right;

  testWidgets('amount pins flush-right in the real font at 1.0×', (
    tester,
  ) async {
    await pumpApp(tester, tile());
    expect(tester.takeException(), isNull);
    // Guard the guard: "Rp 450.000" in the real font is ~91px; in the wide
    // fallback test font it would be ~160px. A narrow width proves the real font
    // loaded, so the float measurement below is meaningful.
    expect(
      tester.getRect(find.byType(MoneyText)).width,
      lessThan(130),
      reason:
          'real Plus Jakarta Sans must be loaded (else the float is masked)',
    );
    // Narrow money, wide column — must still sit flush at the right edge.
    expect(moneyFloat(tester), lessThan(1.0));
  });

  testWidgets('amount stays flush-right and does not overflow at 1.3×', (
    tester,
  ) async {
    await pumpApp(tester, tile(), textScaler: const TextScaler.linear(1.3));
    expect(tester.takeException(), isNull);
    expect(moneyFloat(tester), lessThan(1.0));
  });
}
