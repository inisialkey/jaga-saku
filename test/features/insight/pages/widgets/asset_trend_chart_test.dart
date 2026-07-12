import 'package:fl_chart/fl_chart.dart';
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
}
