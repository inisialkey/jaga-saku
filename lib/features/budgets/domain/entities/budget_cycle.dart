/// Pure cycle math (rule 19): the `[start, end)` local-midnight epoch-millis
/// window of a budget cycle for a global [startDay]. NO Flutter, NO DB, NO clock
/// — mirrors [BudgetStatus] as a flutter-free domain helper. `startDay == 1`
/// reproduces the exact calendar month, so every pre-M1 budget is byte-identical
/// (the backward-compat invariant, proven in `budget_cycle_test.dart`).
///
/// Returns a Dart record `({int start, int end})` (matching the codebase's
/// existing record returns, e.g. `TransactionAggregator.incomeExpense`).
class BudgetCycle {
  const BudgetCycle._();

  /// `[start, end)` millis of the cycle CONTAINING [reference]. Half-open: `end`
  /// is the next cycle's start (a tx dated exactly `end` belongs to the NEXT
  /// cycle). [startDay] clamps to the month's last valid day (31 in February ⇒
  /// the 28th/29th).
  static ({int start, int end}) range({
    required int startDay,
    required DateTime reference,
  }) {
    final startThisMonth = _clampDay(reference.year, reference.month, startDay);
    final DateTime start;
    if (reference.day >= startThisMonth) {
      start = DateTime(reference.year, reference.month, startThisMonth);
    } else {
      // reference precedes this month's start day → the cycle began last month.
      // Dart normalizes month 0 → the previous year's December.
      start = DateTime(
        reference.year,
        reference.month - 1,
        _clampDay(reference.year, reference.month - 1, startDay),
      );
    }
    final end = _nextStart(start, startDay);
    return (
      start: start.millisecondsSinceEpoch,
      end: end.millisecondsSinceEpoch,
    );
  }

  /// The cycle immediately AFTER the one containing [reference].
  static ({int start, int end}) next({
    required int startDay,
    required DateTime reference,
  }) => range(
    startDay: startDay,
    reference: DateTime.fromMillisecondsSinceEpoch(
      range(startDay: startDay, reference: reference).end,
    ),
  );

  /// The cycle immediately BEFORE the one containing [reference].
  static ({int start, int end}) previous({
    required int startDay,
    required DateTime reference,
  }) => range(
    startDay: startDay,
    reference: DateTime.fromMillisecondsSinceEpoch(
      range(startDay: startDay, reference: reference).start - 1,
    ),
  );

  /// The start of the cycle that follows the one beginning at [start].
  static DateTime _nextStart(DateTime start, int startDay) {
    // day=1 avoids month-overflow before we re-clamp to the start day.
    final firstOfNext = DateTime(start.year, start.month + 1);
    return DateTime(
      firstOfNext.year,
      firstOfNext.month,
      _clampDay(firstOfNext.year, firstOfNext.month, startDay),
    );
  }

  /// [day] clamped to the last valid day of [year]/[month] (day 0 of the next
  /// month == this month's last day).
  static int _clampDay(int year, int month, int day) {
    final last = DateTime(year, month + 1, 0).day;
    return day < last ? day : last;
  }
}
