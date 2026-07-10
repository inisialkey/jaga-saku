import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';

/// The money core (plan §2.2 / §8): pure, no Flutter, no DB. Covers the status
/// thresholds (0 / 79 / 80 / 99 / 100 / 120%), the month-boundary safe-daily,
/// the divide-by-zero limit, and the past / future period edges.
void main() {
  // A fixed mid-month clock; the threshold cases don't depend on it.
  BudgetStatus statusFor({
    required int limit,
    required int spent,
    DateTime? now,
    String? period,
  }) {
    final clock = now ?? DateTime(2026, 1, 15, 12);
    return BudgetStatus.compute(
      limitAmount: limit,
      spent: spent,
      now: clock,
      period: period ?? periodKey(clock),
    );
  }

  group('periodKey', () {
    test('zero-pads the month to two digits', () {
      expect(periodKey(DateTime(2026, 3, 5)), '2026-03');
      expect(periodKey(DateTime(2026, 11, 30)), '2026-11');
    });
  });

  group('status thresholds', () {
    test('0% is safe with the full limit remaining', () {
      final s = statusFor(limit: 100000, spent: 0);
      expect(s.ratio, 0);
      expect(s.percent, 0);
      expect(s.remaining, 100000);
      expect(s.level, BudgetStatusLevel.safe);
    });

    test('79% stays safe', () {
      expect(
        statusFor(limit: 100000, spent: 79000).level,
        BudgetStatusLevel.safe,
      );
    });

    test('80% tips into warning', () {
      final s = statusFor(limit: 100000, spent: 80000);
      expect(s.percent, 80);
      expect(s.level, BudgetStatusLevel.warning);
    });

    test('99% is still warning', () {
      expect(
        statusFor(limit: 100000, spent: 99000).level,
        BudgetStatusLevel.warning,
      );
    });

    test('100% is critical with nothing remaining', () {
      final s = statusFor(limit: 100000, spent: 100000);
      expect(s.remaining, 0);
      expect(s.level, BudgetStatusLevel.critical);
      expect(s.isOverBudget, isTrue);
    });

    test('120% is critical with a negative remaining', () {
      final s = statusFor(limit: 100000, spent: 120000);
      expect(s.remaining, -20000);
      expect(s.percent, 120);
      expect(s.level, BudgetStatusLevel.critical);
    });
  });

  group('safe-daily', () {
    test('on the last day of the month divides the remaining by 1', () {
      final s = BudgetStatus.compute(
        limitAmount: 100000,
        spent: 40000,
        now: DateTime(2026, 1, 31, 12),
        period: '2026-01',
      );
      expect(s.remainingDays, 1);
      expect(s.safeDaily, 60000);
    });

    test('mid-month divides the remaining by the days left (today counts)', () {
      final s = BudgetStatus.compute(
        limitAmount: 210000,
        spent: 0,
        now: DateTime(2026, 1, 11, 8),
        period: '2026-01',
      );
      expect(s.remainingDays, 21); // 31 - 11 + 1
      expect(s.safeDaily, 10000);
    });

    test('leap February counts 29 days', () {
      final s = BudgetStatus.compute(
        limitAmount: 290000,
        spent: 0,
        now: DateTime(2024, 2),
        period: '2024-02',
      );
      expect(s.remainingDays, 29);
      expect(s.safeDaily, 10000);
    });

    test('over budget floors the safe-daily to 0', () {
      final s = BudgetStatus.compute(
        limitAmount: 100000,
        spent: 150000,
        now: DateTime(2026, 1, 10),
        period: '2026-01',
      );
      expect(s.safeDaily, 0);
      expect(s.isOverBudget, isTrue);
    });
  });

  group('edges', () {
    test('a zero limit does not crash: ratio 0, safe, safe-daily 0', () {
      final s = BudgetStatus.compute(
        limitAmount: 0,
        spent: 5000,
        now: DateTime(2026, 1, 15),
        period: '2026-01',
      );
      expect(s.ratio, 0);
      expect(s.level, BudgetStatusLevel.safe);
      expect(s.remaining, -5000);
      expect(s.safeDaily, 0);
    });

    test('a past period has no days left and no safe-daily', () {
      final s = BudgetStatus.compute(
        limitAmount: 100000,
        spent: 0,
        now: DateTime(2026, 7, 10),
        period: '2020-01',
      );
      expect(s.remainingDays, 0);
      expect(s.safeDaily, 0);
    });

    test('a future period counts the whole month', () {
      final s = BudgetStatus.compute(
        limitAmount: 300000,
        spent: 0,
        now: DateTime(2026, 1, 15),
        period: '2026-03',
      );
      expect(s.remainingDays, 31); // March
      expect(s.safeDaily, 300000 ~/ 31);
    });
  });
}
