import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';

/// The seventh pure calculation helper (rule 19): occurrence math for recurring
/// rules. **No Flutter, no DB, NO CLOCK** — the caller passes `until =
/// todayMillis`, so results are deterministic and unit-testable (after
/// `BudgetStatus`, `insight_rules`, `TransactionAggregator`, `BudgetCycle`,
/// `templateToTransaction`, `CalcEngine`).
///
/// All dates are midnight-local epoch millis; every result is reconstructed via
/// `DateTime(y, m, d)` so it stays local-midnight across DST (no hour drift).
///
/// The month-end day clamp lives here as a private helper by design: V2-M1's
/// `BudgetCycle` was never shipped, so there is nothing to share — a
/// `core/utils/helper/date_math.dart` would be a dead single-consumer file.
class RecurrenceSchedule {
  const RecurrenceSchedule._();

  /// The occurrence AFTER [fromMillis]. Monthly / yearly clamp the **anchor**
  /// day (the day-of-month of [startDate]) into the target month, so a Jan-31
  /// monthly rule walks Jan-31 → Feb-28 → **Mar-31** (the anchor is preserved,
  /// never lost to the clamped Feb-28) and a Feb-29 yearly rule walks
  /// Feb-29-2024 → Feb-28-2025 → … → **Feb-29-2028**.
  ///
  /// [startDate] is REQUIRED: [fromMillis] alone loses the anchor day after a
  /// clamp — clamping `from.day` instead of the anchor is the silent C1 drift.
  static int nextOccurrence(
    int fromMillis,
    RecurrenceFreq freq,
    int interval, {
    required int startDate,
  }) {
    final from = DateTime.fromMillisecondsSinceEpoch(fromMillis);
    switch (freq) {
      case RecurrenceFreq.daily:
        return DateTime(
          from.year,
          from.month,
          from.day + interval,
        ).millisecondsSinceEpoch;
      case RecurrenceFreq.weekly:
        return DateTime(
          from.year,
          from.month,
          from.day + 7 * interval,
        ).millisecondsSinceEpoch;
      case RecurrenceFreq.monthly:
        final anchorDay = DateTime.fromMillisecondsSinceEpoch(startDate).day;
        // day = 1 first so `from.month + interval` never overflows the day.
        final target = DateTime(from.year, from.month + interval);
        final day = _clamp(anchorDay, _lastDay(target.year, target.month));
        return DateTime(target.year, target.month, day).millisecondsSinceEpoch;
      case RecurrenceFreq.yearly:
        final anchor = DateTime.fromMillisecondsSinceEpoch(startDate);
        final year = from.year + interval;
        final day = _clamp(anchor.day, _lastDay(year, anchor.month));
        return DateTime(year, anchor.month, day).millisecondsSinceEpoch;
    }
  }

  /// Every occurrence in `[cursor, until]` (inclusive), stopping past [endDate].
  /// Empty when `cursor > until`. Capped at [cap] (~60): an old daily rule would
  /// otherwise project thousands on first open.
  // ponytail: hard cap over real paging — add paging only if a real rule count
  // bites; the review header surfaces the overflow.
  static List<int> dueOccurrences({
    required int cursor,
    required int until,
    required RecurrenceFreq freq,
    required int interval,
    required int startDate,
    int? endDate,
    int cap = 60,
  }) {
    final out = <int>[];
    var current = cursor;
    while (current <= until) {
      if (endDate != null && current > endDate) break;
      out.add(current);
      if (out.length >= cap) break;
      current = nextOccurrence(current, freq, interval, startDate: startDate);
    }
    return out;
  }

  /// First occurrence `>= floor` (the schedule-edit cursor reset, C5). Iterates
  /// from [startDate] (occurrences are monotonically increasing); [floor] is
  /// typically `max(startDate, today)` so a re-cadenced rule never backfills its
  /// past.
  static int firstDueOnOrAfter({
    required int startDate,
    required int floor,
    required RecurrenceFreq freq,
    required int interval,
  }) {
    var current = startDate;
    var guard = 0;
    // ponytail: the 100000 guard is a bug-net, not a real bound — it never trips
    // for sane user-chosen starts (a daily rule 273 years back still fits).
    while (current < floor && guard < 100000) {
      current = nextOccurrence(current, freq, interval, startDate: startDate);
      guard++;
    }
    return current;
  }

  /// Last day of `month` in `year` (day 0 of the next month rolls back a day).
  static int _lastDay(int year, int month) => DateTime(year, month + 1, 0).day;

  static int _clamp(int day, int lastDay) => day < lastDay ? day : lastDay;
}
