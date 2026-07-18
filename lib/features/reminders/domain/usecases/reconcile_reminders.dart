import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_config.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_decisions.dart';
import 'package:jaga_saku/features/reminders/domain/usecases/check_budget_warnings.dart';
import 'package:jaga_saku/features/reminders/domain/usecases/schedule_daily_reminder.dart';
import 'package:jaga_saku/features/reminders/domain/usecases/sync_recurring_reminders.dart';

/// PURE aggregator (rule 19): the single "app-open catch-up" composition —
/// folds the three decision usecases into one [ReconcilePlan] the service
/// applies. Keeping the composition pure means the whole reconcile projection
/// is unit-tested off the plugin/`tz` edge.
class ReconcileReminders {
  const ReconcileReminders(this._daily, this._recurring, this._budgets);

  final ScheduleDailyReminder _daily;
  final SyncRecurringReminders _recurring;
  final CheckBudgetWarnings _budgets;

  ReconcilePlan call({
    required ReminderConfig config,
    required List<PendingOccurrence> due,
    required List<Budget> budgets,
    required Set<String> warnedMarkers,
    required DateTime now,
  }) => ReconcilePlan(
    daily: _daily(config: config, now: now),
    recurring: _recurring(
      enabled: config.recurringDueEnabled,
      due: due,
      now: now,
    ),
    budgetWarnings: _budgets(
      enabled: config.budgetWarningEnabled,
      budgets: budgets,
      now: now,
      warnedMarkers: warnedMarkers,
    ),
  );
}
