import 'package:jaga_saku/features/reminders/domain/entities/reminder_config.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_decisions.dart';

/// PURE decision (rule 19, no `tz`/plugin/Flutter): given the [ReminderConfig]
/// and the current clock, decide whether to cancel the daily check-in or the
/// first instant it should fire. The service repeats it daily with
/// `DateTimeComponents.time`, so this only needs the FIRST fire.
class ScheduleDailyReminder {
  const ScheduleDailyReminder();

  DailyReminderDecision call({
    required ReminderConfig config,
    required DateTime now,
  }) {
    if (!config.dailyEnabled) return const DailyReminderDecision.cancel();
    return DailyReminderDecision.at(
      _nextTimeOfDay(
        now,
        config.dailyHour,
        config.dailyMinute,
      ).millisecondsSinceEpoch,
    );
  }

  /// Today at `h:m` if that is strictly after [now]; otherwise tomorrow at
  /// `h:m`. Reconstructed via `DateTime(y, m, d+1, …)` (not `Duration`) to match
  /// the codebase's local-midnight idiom — exact in WIB (no DST).
  DateTime _nextTimeOfDay(DateTime now, int hour, int minute) {
    final today = DateTime(now.year, now.month, now.day, hour, minute);
    if (today.isAfter(now)) return today;
    return DateTime(now.year, now.month, now.day + 1, hour, minute);
  }
}
