import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter/services.dart' show FontLoader, rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/home/pages/home_cubit.dart';
import 'package:jaga_saku/features/home/pages/widgets/favorites_strip.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

import '../../../../helpers/pump_app.dart';

/// Guards the Home favorites chip against clipped text. The chip is narrow, so
/// in the real Plus Jakarta Sans two things used to get cut: a big amount
/// (`Rp 999.999.999` in `bodySmall`) and a three-word name
/// (`Uang Makan Mingguan`). The fixes: the amount is wrapped in a
/// `FittedBox(scaleDown)` (the hero / transaction-tile idiom) and the chip is
/// wide enough for a two-line label. This loads the REAL font (the default test
/// font is narrower and masks the clip), then asserts the amount is scale-fitted
/// and the label fits two lines (never a clipped third) at 1.0× and does not
/// overflow at 1.3×.
void main() {
  setUpAll(() async {
    final loader = FontLoader('Plus Jakarta Sans')
      ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans-Variable.ttf'));
    await loader.load();
  });

  const dashboard = HomeDashboard(
    totalBalance: 0,
    monthIncome: 0,
    monthExpense: 0,
    todaySpent: 0,
    todayUnplanned: 0,
  );

  // The real name that reported the clip: three words, must fit two lines.
  const longName = 'Uang Makan Mingguan';

  Widget strip() => const SizedBox(
    width: 375,
    child: FavoritesStrip(
      favorites: [
        TxTemplate(
          id: 1,
          label: longName,
          type: TransactionType.expense,
          accountId: 1,
          amount: 999999999,
          categoryId: 1,
        ),
      ],
      dashboard: dashboard,
    ),
  );

  testWidgets('the chip fits the amount and a two-line label at 1.0×', (
    tester,
  ) async {
    await pumpApp(tester, strip());
    expect(tester.takeException(), isNull);
    // The amount is scale-fitted (not ellipsis-clipped) so the full value shows.
    expect(
      find.ancestor(
        of: find.text('Rp 999.999.999'),
        matching: find.byType(FittedBox),
      ),
      findsOneWidget,
    );
    // The label fits within two lines in the real font — no clipped third line,
    // so `Uang Makan Mingguan` shows in full.
    final label = tester.renderObject<RenderParagraph>(find.text(longName));
    expect(label.didExceedMaxLines, isFalse);
  });

  testWidgets('the chip does not overflow in the real font at 1.3×', (
    tester,
  ) async {
    await pumpApp(tester, strip(), textScaler: const TextScaler.linear(1.3));
    expect(tester.takeException(), isNull);
  });
}
