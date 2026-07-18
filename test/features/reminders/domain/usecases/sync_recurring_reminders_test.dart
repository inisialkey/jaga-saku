import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/reminders/domain/usecases/sync_recurring_reminders.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// [SyncRecurringReminders]: disabled/empty → cancel; otherwise 08:00 on the
/// earliest due date, or the next 08:00 once that has passed. Pure — no plugin.
void main() {
  const usecase = SyncRecurringReminders();

  PendingOccurrence due(DateTime midnight) => PendingOccurrence(
    rule: const RecurringRule(
      templateId: 0,
      freq: RecurrenceFreq.monthly,
      startDate: 0,
      nextDue: 0,
    ),
    template: const TxTemplate(
      label: '',
      type: TransactionType.expense,
      accountId: 0,
    ),
    dueDate: midnight.millisecondsSinceEpoch,
  );

  test('disabled → cancel', () {
    final decision = usecase(
      enabled: false,
      due: [due(DateTime(2026, 7, 18))],
      now: DateTime(2026, 7, 18, 7),
    );
    expect(decision.schedule, isFalse);
    expect(decision.fireAtMillis, isNull);
  });

  test('nothing due → cancel', () {
    final decision = usecase(
      enabled: true,
      due: const [],
      now: DateTime(2026, 7, 18, 7),
    );
    expect(decision.schedule, isFalse);
  });

  test('due today, currently before 08:00 → fires today 08:00', () {
    final decision = usecase(
      enabled: true,
      due: [due(DateTime(2026, 7, 18))],
      now: DateTime(2026, 7, 18, 7),
    );
    expect(
      DateTime.fromMillisecondsSinceEpoch(decision.fireAtMillis!),
      DateTime(2026, 7, 18, 8),
    );
  });

  test('due today, currently after 08:00 → fires tomorrow 08:00', () {
    final decision = usecase(
      enabled: true,
      due: [due(DateTime(2026, 7, 18))],
      now: DateTime(2026, 7, 18, 9),
    );
    expect(
      DateTime.fromMillisecondsSinceEpoch(decision.fireAtMillis!),
      DateTime(2026, 7, 19, 8),
    );
  });

  test('overdue occurrence, now past 08:00 → next 08:00 (tomorrow)', () {
    final decision = usecase(
      enabled: true,
      due: [due(DateTime(2026, 7, 15))],
      now: DateTime(2026, 7, 18, 10),
    );
    expect(
      DateTime.fromMillisecondsSinceEpoch(decision.fireAtMillis!),
      DateTime(2026, 7, 19, 8),
    );
  });

  test('uses the earliest (first) due date', () {
    final decision = usecase(
      enabled: true,
      due: [due(DateTime(2026, 7, 20)), due(DateTime(2026, 7, 25))],
      now: DateTime(2026, 7, 18, 10),
    );
    expect(
      DateTime.fromMillisecondsSinceEpoch(decision.fireAtMillis!),
      DateTime(2026, 7, 20, 8),
    );
  });
}
