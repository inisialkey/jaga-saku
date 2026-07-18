import 'package:equatable/equatable.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';

/// Whether (and when) to (re)schedule the daily check-in — the pure output of
/// `ScheduleDailyReminder`. `Equatable` so it asserts by value in tests.
class DailyReminderDecision extends Equatable {
  const DailyReminderDecision._(this.schedule, this.firstFireAtMillis);

  /// Daily disabled → cancel the fixed id.
  const DailyReminderDecision.cancel() : this._(false, null);

  /// Daily enabled → (re)schedule so the first fire lands at [millis]
  /// (local-epoch millis). The service repeats it with `DateTimeComponents.time`.
  const DailyReminderDecision.at(int millis) : this._(true, millis);

  /// True → schedule at [firstFireAtMillis]; false → cancel.
  final bool schedule;

  /// The first fire instant (local-epoch millis); `null` when [schedule] false.
  final int? firstFireAtMillis;

  @override
  List<Object?> get props => [schedule, firstFireAtMillis];
}

/// Whether (and when) to (re)schedule the aggregate recurring-due nudge — the
/// pure output of `SyncRecurringReminders`.
class RecurringReminderDecision extends Equatable {
  const RecurringReminderDecision._(this.schedule, this.fireAtMillis);

  /// Disabled or nothing due → cancel the fixed id.
  const RecurringReminderDecision.cancel() : this._(false, null);

  /// Something due → schedule a one-shot at [millis] (local-epoch millis,
  /// 08:00 on/after the earliest due date).
  const RecurringReminderDecision.at(int millis) : this._(true, millis);

  /// True → schedule at [fireAtMillis]; false → cancel.
  final bool schedule;

  /// The one-shot fire instant (local-epoch millis); `null` when not scheduled.
  final int? fireAtMillis;

  @override
  List<Object?> get props => [schedule, fireAtMillis];
}

/// One budget that crossed a warning boundary and has NOT been notified for that
/// `{budgetId, period, level}` yet — the pure output of `CheckBudgetWarnings`.
/// The service resolves [categoryId] → a display name for the body and writes
/// [markerKey] after showing, so the same crossing never re-fires this period.
class BudgetWarning extends Equatable {
  const BudgetWarning({
    required this.budgetId,
    required this.categoryId,
    required this.level,
    required this.markerKey,
  });

  final int budgetId;
  final int categoryId;

  /// `warning` (>=80%) or `critical` (>=100%) — never `safe`.
  final BudgetStatusLevel level;

  /// The dedupe marker (`ReminderConfig.budgetMarkerKey`).
  final String markerKey;

  @override
  List<Object?> get props => [budgetId, categoryId, level, markerKey];
}

/// The composed app-open catch-up plan — the pure output of `ReconcileReminders`
/// (the single unit-tested reconcile composition).
class ReconcilePlan extends Equatable {
  const ReconcilePlan({
    required this.daily,
    required this.recurring,
    required this.budgetWarnings,
  });

  final DailyReminderDecision daily;
  final RecurringReminderDecision recurring;
  final List<BudgetWarning> budgetWarnings;

  @override
  List<Object?> get props => [daily, recurring, budgetWarnings];
}
