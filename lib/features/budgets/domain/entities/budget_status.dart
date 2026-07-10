import 'dart:math';

/// 'YYYY-MM' period key for [date] (its **local** year-month). Matches the SQL
/// bucket the budget datasource derives with
/// `strftime('%Y-%m', datetime(date/1000,'unixepoch','localtime'))`, so a
/// transaction's Dart period and its SQL period always agree. Pure — the single
/// source of truth for period keys across the app (cubits + [BudgetStatus]).
String periodKey(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$year-$month';
}

/// Severity of a budget's spending against its limit (style guide §13.6).
/// Maps to the success / warning / critical palette. Thresholds from M0 §4:
/// safe `< 0.8`, warning `[0.8, 1.0)`, critical `>= 1.0`.
enum BudgetStatusLevel { safe, warning, critical }

/// Pure money math for one budget in one period — **no Flutter, no DB** (rule
/// 19). Given the limit, the spent-so-far, the current clock and the budget's
/// period, it derives the remaining amount, the spent ratio, the days left, the
/// safe daily spend and the status level.
///
/// This is the correctness core (plan §2.2): unit-tested hard against the
/// threshold boundaries, the month-boundary safe-daily, and the divide-by-zero
/// / past / future edges.
class BudgetStatus {
  /// Computes the derived values from raw ints + the clock. [period] is the
  /// budget's 'YYYY-MM'; [now] is the current time (injected so tests are
  /// deterministic and only the current month drives safe-daily / warnings).
  factory BudgetStatus.compute({
    required int limitAmount,
    required int spent,
    required DateTime now,
    required String period,
  }) {
    final remaining = limitAmount - spent;
    // Guard divide-by-zero: a zero (or invalid) limit has no meaningful ratio,
    // so it reads as 0% rather than crashing. The form blocks limit <= 0, so
    // this only ever fires for degenerate / legacy data.
    final ratio = limitAmount <= 0 ? 0.0 : spent / limitAmount;
    final remainingDays = _remainingDays(now, period);
    // Only a period with days left has a safe-daily; a negative remaining floors
    // to 0 so we never surface a negative daily allowance.
    final safeDaily = remainingDays > 0
        ? max(0, remaining) ~/ remainingDays
        : 0;
    final level = ratio >= 1.0
        ? BudgetStatusLevel.critical
        : ratio >= 0.8
        ? BudgetStatusLevel.warning
        : BudgetStatusLevel.safe;
    return BudgetStatus._(
      remaining: remaining,
      ratio: ratio,
      remainingDays: remainingDays,
      safeDaily: safeDaily,
      level: level,
    );
  }

  const BudgetStatus._({
    required this.remaining,
    required this.ratio,
    required this.remainingDays,
    required this.safeDaily,
    required this.level,
  });

  /// limit − spent (can be negative once over budget).
  final int remaining;

  /// spent / limit (0.0 when the limit is 0). 1.0 == exactly at the limit.
  final double ratio;

  /// Days left in the period *including today* when [period] is the current
  /// month; 0 for a past period; the full month for a future one.
  final int remainingDays;

  /// `max(0, remaining) ~/ remainingDays` — the per-day spend that still lands
  /// on budget; 0 when the period has no days left (past) or nothing remains.
  final int safeDaily;

  final BudgetStatusLevel level;

  /// Spent as a whole-number percentage of the limit (can exceed 100).
  int get percent => (ratio * 100).round();

  /// True once spending has reached or passed the limit.
  bool get isOverBudget => level == BudgetStatusLevel.critical;

  /// Days left in [period]'s month relative to [now]:
  /// - current month → `daysInMonth − now.day + 1` (today counts),
  /// - past month → 0 (safe-daily N/A),
  /// - future month → the full month.
  static int _remainingDays(DateTime now, String period) {
    final parts = period.split('-');
    final year = int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? now.year;
    final month = int.tryParse(parts.length > 1 ? parts[1] : '') ?? now.month;
    // Day 0 of the next month == the last day of this month (Dart normalizes a
    // month of 13 back to January of the next year).
    final daysInMonth = DateTime(year, month + 1, 0).day;

    if (year == now.year && month == now.month) {
      return daysInMonth - now.day + 1;
    }
    final isPast = year < now.year || (year == now.year && month < now.month);
    return isPast ? 0 : daysInMonth;
  }
}
