import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_asset_trend.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// Pins the [GetAssetTrend] branches the datasource/cubit suites don't reach:
/// it cumulates the FULL history then trims the tail to `months` (so the last
/// point survives even when history predates the window — the C1 identity), and
/// seeds a single baseline dot for empty history.
void main() {
  late MockTransactionRepository repo;
  late GetAssetTrend usecase;

  final now = DateTime(2026, 7, 15);
  final windowEnd = DateTime(2026, 8).millisecondsSinceEpoch;

  int m(int year, int month) => DateTime(year, month).millisecondsSinceEpoch;

  setUp(() {
    repo = MockTransactionRepository();
    usecase = GetAssetTrend(repo);
  });

  test(
    'queries the FULL history window (start = 0, end = next month)',
    () async {
      when(
        () => repo.monthlyNetDeltas(any(), any()),
      ).thenAnswer((_) async => const Right<Failure, List<MonthDelta>>([]));

      await usecase(AssetTrendParams(baseline: 0, now: now));

      verify(() => repo.monthlyNetDeltas(0, windowEnd)).called(1);
    },
  );

  test(
    'cumulates all history then trims to the trailing months, tail intact',
    () async {
      // 14 monthly deltas of +1000 → the last point must reflect ALL 14 even
      // though only the trailing 12 are returned (the reconciliation identity).
      final deltas = [
        for (var i = 0; i < 14; i++)
          MonthDelta(monthMillis: m(2025, 6 + i), delta: 1000),
      ];
      when(
        () => repo.monthlyNetDeltas(any(), any()),
      ).thenAnswer((_) async => Right<Failure, List<MonthDelta>>(deltas));

      final result = await usecase(
        AssetTrendParams(baseline: 100000, now: now),
      );

      final points = result.getRight().toNullable()!;
      expect(points, hasLength(12)); // trimmed to the default window
      expect(points.last.netWorth, 100000 + 14 * 1000); // full-history endpoint
      expect(points.first.netWorth, 100000 + 3 * 1000); // dropped the first two
    },
  );

  test(
    'returns all points untrimmed when history is shorter than the window',
    () async {
      final deltas = [
        MonthDelta(monthMillis: m(2026, 6), delta: 500),
        MonthDelta(monthMillis: m(2026, 7), delta: -200),
      ];
      when(
        () => repo.monthlyNetDeltas(any(), any()),
      ).thenAnswer((_) async => Right<Failure, List<MonthDelta>>(deltas));

      final result = await usecase(AssetTrendParams(baseline: 1000, now: now));

      final points = result.getRight().toNullable()!;
      expect(points.map((p) => p.netWorth).toList(), [1500, 1300]);
    },
  );

  test(
    'seeds a single baseline dot at the current month for empty history',
    () async {
      when(
        () => repo.monthlyNetDeltas(any(), any()),
      ).thenAnswer((_) async => const Right<Failure, List<MonthDelta>>([]));

      final result = await usecase(
        AssetTrendParams(baseline: 250000, now: now),
      );

      final points = result.getRight().toNullable()!;
      expect(points, hasLength(1));
      expect(points.single.netWorth, 250000);
      expect(points.single.monthMillis, m(2026, 7));
    },
  );

  test('a repository Left propagates unchanged', () async {
    when(() => repo.monthlyNetDeltas(any(), any())).thenAnswer(
      (_) async => const Left<Failure, List<MonthDelta>>(CacheFailure()),
    );

    final result = await usecase(AssetTrendParams(baseline: 0, now: now));

    expect(result.isLeft(), isTrue);
  });
}
