import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_config.dart';
import 'package:jaga_saku/features/reminders/domain/usecases/schedule_daily_reminder.dart';

/// [ScheduleDailyReminder]: disabled → cancel; enabled → the next `HH:mm`
/// instant (today if still ahead, else tomorrow). Pure — no mocks, no plugin.
void main() {
  const usecase = ScheduleDailyReminder();

  test('disabled config → cancel (no fire)', () {
    final decision = usecase(
      config: const ReminderConfig(),
      now: DateTime(2026, 7, 18, 10),
    );
    expect(decision.schedule, isFalse);
    expect(decision.firstFireAtMillis, isNull);
  });

  test('enabled, time still ahead today → fires today at HH:mm', () {
    final decision = usecase(
      config: const ReminderConfig(dailyEnabled: true),
      now: DateTime(2026, 7, 18, 10),
    );
    expect(decision.schedule, isTrue);
    expect(
      DateTime.fromMillisecondsSinceEpoch(decision.firstFireAtMillis!),
      DateTime(2026, 7, 18, 20),
    );
  });

  test('enabled, time already passed today → fires tomorrow at HH:mm', () {
    final decision = usecase(
      config: const ReminderConfig(dailyEnabled: true),
      now: DateTime(2026, 7, 18, 21),
    );
    expect(
      DateTime.fromMillisecondsSinceEpoch(decision.firstFireAtMillis!),
      DateTime(2026, 7, 19, 20),
    );
  });

  test('enabled, time exactly now → treated as passed → tomorrow', () {
    final decision = usecase(
      config: const ReminderConfig(dailyEnabled: true),
      now: DateTime(2026, 7, 18, 20),
    );
    expect(
      DateTime.fromMillisecondsSinceEpoch(decision.firstFireAtMillis!),
      DateTime(2026, 7, 19, 20),
    );
  });

  test('honours a non-zero minute', () {
    final decision = usecase(
      config: const ReminderConfig(
        dailyEnabled: true,
        dailyHour: 7,
        dailyMinute: 30,
      ),
      now: DateTime(2026, 7, 18, 6),
    );
    expect(
      DateTime.fromMillisecondsSinceEpoch(decision.firstFireAtMillis!),
      DateTime(2026, 7, 18, 7, 30),
    );
  });
}
