import 'package:equatable/equatable.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';

/// Persisted reminder preferences (V3-M5). Every value lives in the `settings`
/// kv table via `SettingsService` (string-encoded, exactly like
/// `AppSettingsCubit`) — **no new sqflite table, no schema migration**. Pure
/// value type: `Equatable`, no codegen, imports only domain + `equatable`
/// (rule 19), so it unit-tests like `BudgetStatus`.
class ReminderConfig extends Equatable {
  const ReminderConfig({
    this.dailyEnabled = false,
    this.dailyHour = 20,
    this.dailyMinute = 0,
    this.recurringDueEnabled = false,
    this.budgetWarningEnabled = false,
  });

  /// Daily check-in nudge on/off. Default off (opt-in, no permission at boot).
  final bool dailyEnabled;

  /// Hour-of-day (0..23) for the daily nudge. Default 20 (8pm).
  final int dailyHour;

  /// Minute-of-hour (0..59) for the daily nudge. Default 0.
  final int dailyMinute;

  /// Recurring-due aggregate nudge on/off. Default off.
  final bool recurringDueEnabled;

  /// Budget warning (80% / 100% crossing) nudge on/off. Default off.
  final bool budgetWarningEnabled;

  // ── Settings kv keys (the `settings.key` column values, NOT ARB keys) ──────
  /// `"1"`/`"0"`.
  static const String dailyEnabledKey = 'reminder_daily_enabled';

  /// `"HH:mm"` (SettingsService is TEXT-only, so the time is string-encoded,
  /// mirroring `budget_cycle_start_day`).
  static const String dailyTimeKey = 'reminder_daily_time';

  /// `"1"`/`"0"`.
  static const String recurringEnabledKey = 'reminder_recurring_enabled';

  /// `"1"`/`"0"`.
  static const String budgetEnabledKey = 'reminder_budget_enabled';

  /// The dedupe marker key for ONE budget crossing ONE [level] in ONE [period]
  /// (`'YYYY-MM'`). Shared by the datasource probe and `CheckBudgetWarnings` so
  /// the format lives in exactly one place. Self-scopes to
  /// `{budgetId}_{period}_{level}` so the marker resets automatically when the
  /// period key rolls over (no cleanup needed).
  static String budgetMarkerKey(
    int budgetId,
    String period,
    BudgetStatusLevel level,
  ) => 'reminder_budget_warned_${budgetId}_${period}_${level.name}';

  @override
  List<Object?> get props => [
    dailyEnabled,
    dailyHour,
    dailyMinute,
    recurringDueEnabled,
    budgetWarningEnabled,
  ];
}
