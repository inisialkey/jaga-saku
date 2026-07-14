import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/insight/pages/widgets/asset_trend_chart.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';

import '../../../../helpers/pump_app.dart';

/// Widget tests for the app's first [LineChart] — NOT goldens (repo convention).
/// Proves it renders across the multi-point, single-point and negative cases.
void main() {
  int m(int year, int month) => DateTime(year, month).millisecondsSinceEpoch;

  group('AssetTrendChart', () {
    testWidgets('renders a LineChart for a multi-point trend', (tester) async {
      await pumpApp(
        tester,
        AssetTrendChart(
          points: [
            TrendPoint(monthMillis: m(2026, 3), netWorth: 1000000),
            TrendPoint(monthMillis: m(2026, 4), netWorth: 1200000),
            TrendPoint(monthMillis: m(2026, 5), netWorth: 900000),
            TrendPoint(monthMillis: m(2026, 6), netWorth: 1500000),
            TrendPoint(monthMillis: m(2026, 7), netWorth: 1800000),
          ],
        ),
      );
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('renders a LineChart (dot) for a single seeded point', (
      tester,
    ) async {
      await pumpApp(
        tester,
        AssetTrendChart(
          points: [TrendPoint(monthMillis: m(2026, 7), netWorth: 500000)],
        ),
      );
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('renders a negative-net-worth point without throwing', (
      tester,
    ) async {
      await pumpApp(
        tester,
        AssetTrendChart(
          points: [
            TrendPoint(monthMillis: m(2026, 6), netWorth: 100000),
            TrendPoint(monthMillis: m(2026, 7), netWorth: -50000),
          ],
        ),
      );
      expect(find.byType(LineChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  // ── Tranche C: tooltip (C1), semantics (C2), reduced motion (C5) ──────────
  group('AssetTrendChart interactions', () {
    testWidgets('tapping a point builds a tooltip without throwing', (
      tester,
    ) async {
      await pumpApp(
        tester,
        AssetTrendChart(
          points: [
            TrendPoint(monthMillis: m(2026, 5), netWorth: 900000),
            TrendPoint(monthMillis: m(2026, 6), netWorth: 1200000),
            TrendPoint(monthMillis: m(2026, 7), netWorth: 1800000),
          ],
        ),
      );
      // A tap exercises getTooltipItems → points[spotIndex] mapping.
      await tester.tap(find.byType(LineChart));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'tapping the single seeded point does not crash (spotIndex 0)',
      (tester) async {
        await pumpApp(
          tester,
          AssetTrendChart(
            points: [TrendPoint(monthMillis: m(2026, 7), netWorth: 500000)],
          ),
        );
        await tester.tap(find.byType(LineChart));
        await tester.pump();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('exposes a localized net-worth trend semantics label', (
      tester,
    ) async {
      await pumpApp(
        tester,
        AssetTrendChart(
          points: [
            TrendPoint(monthMillis: m(2026, 6), netWorth: 1200000),
            TrendPoint(monthMillis: m(2026, 7), netWorth: 1800000),
          ],
        ),
      );
      // Voices the current (last) figure via chartTrendSemantics(amount).
      expect(
        find.bySemanticsLabel(RegExp('Net worth trend chart, currently')),
        findsOneWidget,
      );
    });

    testWidgets('renders without the entrance animation under reduced motion', (
      tester,
    ) async {
      await pumpApp(
        tester,
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: AssetTrendChart(
              points: [
                TrendPoint(monthMillis: m(2026, 6), netWorth: 1200000),
                TrendPoint(monthMillis: m(2026, 7), netWorth: 1800000),
              ],
            ),
          ),
        ),
      );
      expect(find.byType(LineChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
