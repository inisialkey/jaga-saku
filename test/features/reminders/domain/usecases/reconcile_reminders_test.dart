import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_config.dart';
import 'package:jaga_saku/features/reminders/domain/usecases/check_budget_warnings.dart';
import 'package:jaga_saku/features/reminders/domain/usecases/reconcile_reminders.dart';
import 'package:jaga_saku/features/reminders/domain/usecases/schedule_daily_reminder.dart';
import 'package:jaga_saku/features/reminders/domain/usecases/sync_recurring_reminders.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// [ReconcileReminders]: the single app-open catch-up composition. Folds the
/// three pure decisions into one [ReconcilePlan]. Pure — no mocks, no plugin.
void main() {
  const usecase = ReconcileReminders(
    ScheduleDailyReminder(),
    SyncRecurringReminders(),
    CheckBudgetWarnings(),
  );

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

  final overBudget = Budget(
    id: 1,
    categoryId: 7,
    period: '2026-07',
    limitAmount: 100,
    spent: 110,
    periodStart: DateTime(2026, 7).millisecondsSinceEpoch,
    periodEnd: DateTime(2026, 8).millisecondsSinceEpoch,
  );

  test('all three enabled → daily + recurring + budget aggregated', () {
    final plan = usecase(
      config: const ReminderConfig(
        dailyEnabled: true,
        recurringDueEnabled: true,
        budgetWarningEnabled: true,
      ),
      due: [due(DateTime(2026, 7, 18))],
      budgets: [overBudget],
      warnedMarkers: const {},
      now: DateTime(2026, 7, 18, 10),
    );

    // Daily: 20:00 still ahead of 10:00 → today 20:00.
    expect(plan.daily.schedule, isTrue);
    expect(
      DateTime.fromMillisecondsSinceEpoch(plan.daily.firstFireAtMillis!),
      DateTime(2026, 7, 18, 20),
    );

    // Recurring: due today but now is past 08:00 → next 08:00 (tomorrow).
    expect(plan.recurring.schedule, isTrue);
    expect(
      DateTime.fromMillisecondsSinceEpoch(plan.recurring.fireAtMillis!),
      DateTime(2026, 7, 19, 8),
    );

    // Budget: one critical crossing.
    expect(plan.budgetWarnings, hasLength(1));
    expect(plan.budgetWarnings.single.level, BudgetStatusLevel.critical);
  });

  test('all disabled → every leg cancels, no budget warnings', () {
    final plan = usecase(
      config: const ReminderConfig(),
      due: [due(DateTime(2026, 7, 18))],
      budgets: [overBudget],
      warnedMarkers: const {},
      now: DateTime(2026, 7, 18, 10),
    );
    expect(plan.daily.schedule, isFalse);
    expect(plan.recurring.schedule, isFalse);
    expect(plan.budgetWarnings, isEmpty);
  });
}
