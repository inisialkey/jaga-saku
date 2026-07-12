import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';

/// Pure unit tests for [AssetTrendCalculator] — no ffi, no Flutter (rule 19,
/// mirrors `transaction_aggregator_test.dart`). Pins the net-worth reconstruction
/// identity: `running = baseline; running += delta` per month, in order.
void main() {
  int m(int year, int month) => DateTime(year, month).millisecondsSinceEpoch;

  group('AssetTrendCalculator.cumulate', () {
    test('cumulates one point per delta, in order, from the baseline', () {
      final points = AssetTrendCalculator.cumulate(
        baseline: 1000000,
        deltas: [
          MonthDelta(monthMillis: m(2026, 1), delta: 500000),
          MonthDelta(monthMillis: m(2026, 2), delta: -200000),
          MonthDelta(monthMillis: m(2026, 3), delta: 100000),
        ],
      );

      expect(points.map((p) => p.netWorth).toList(), [
        1500000,
        1300000,
        1400000,
      ]);
      // Month millis pass through untouched, in order.
      expect(points.map((p) => p.monthMillis).toList(), [
        m(2026, 1),
        m(2026, 2),
        m(2026, 3),
      ]);
    });

    test('empty deltas yield no points (caller seeds a baseline dot)', () {
      expect(
        AssetTrendCalculator.cumulate(baseline: 1000000, deltas: const []),
        isEmpty,
      );
    });

    test('a negative running total renders (no clamp to zero)', () {
      final points = AssetTrendCalculator.cumulate(
        baseline: 0,
        deltas: [MonthDelta(monthMillis: m(2026, 1), delta: -50000)],
      );
      expect(points.single.netWorth, -50000);
    });

    test('order is preserved even when deltas swing the total around', () {
      final points = AssetTrendCalculator.cumulate(
        baseline: 100,
        deltas: [
          MonthDelta(monthMillis: m(2025, 12), delta: -300),
          MonthDelta(monthMillis: m(2026, 1), delta: 500),
        ],
      );
      expect(points.map((p) => p.netWorth).toList(), [-200, 300]);
    });
  });
}
