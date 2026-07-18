import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_decisions.dart';

/// PURE decision (rule 19): given whether recurring reminders are enabled and
/// the current [GetDueOccurrences] projection, decide whether to cancel the
/// aggregate recurring nudge or the one-shot instant it should fire.
///
/// [due] is sorted ascending by `GetDueOccurrences`, so `due.first.dueDate` is
/// the earliest pending occurrence. Because the projection is derived off the
/// forward-only `next_due` cursor, RESOLVED occurrences are already excluded —
/// this usecase inherits that for free, it never re-derives occurrence state.
class SyncRecurringReminders {
  const SyncRecurringReminders();

  RecurringReminderDecision call({
    required bool enabled,
    required List<PendingOccurrence> due,
    required DateTime now,
  }) {
    if (!enabled || due.isEmpty) {
      return const RecurringReminderDecision.cancel();
    }
    return RecurringReminderDecision.at(
      _eightAmOnOrAfter(due.first.dueDate, now).millisecondsSinceEpoch,
    );
  }

  /// 08:00 on the [dueDateMillis] date (a midnight-local date pinned to 08:00,
  /// decision 4) when that instant is still ahead of [now]; otherwise the next
  /// 08:00 — today if it is currently before 08:00, else tomorrow.
  DateTime _eightAmOnOrAfter(int dueDateMillis, DateTime now) {
    final due = DateTime.fromMillisecondsSinceEpoch(dueDateMillis);
    final base = DateTime(due.year, due.month, due.day, 8);
    if (base.isAfter(now)) return base;
    return now.hour < 8
        ? DateTime(now.year, now.month, now.day, 8)
        : DateTime(now.year, now.month, now.day + 1, 8);
  }
}
