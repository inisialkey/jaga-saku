/// The three local reminder kinds (V3-M5). Each carries a stable
/// notification-id base so cancel/reschedule is idempotent (no persisted id
/// map needed), and its [name] is the notification **payload** string routed on
/// tap (see `reminder_routes.dart`). Pure domain — no Flutter / plugin / tz
/// imports (rule 19), so it stays trivially unit-testable.
enum ReminderType {
  /// A repeating daily check-in nudge. Singleton id.
  dailyCheckIn(1),

  /// One aggregate "you have recurring transactions due" nudge. Singleton id.
  recurringDue(2),

  /// Per-budget over/near-limit warning. Base offset by the budget id.
  budgetWarning(3000);

  const ReminderType(this.idBase);

  /// Base for the stable notification id. [dailyCheckIn]/[recurringDue] are
  /// singletons (fixed `1`/`2`); [budgetWarning] is per-budget (`3000 +
  /// budgetId`) so each budget cancels / dedupes independently.
  final int idBase;

  /// The stable notification id for this type. [budgetId] offsets [idBase] for
  /// [budgetWarning] (required there); it is ignored for the singleton types.
  int notificationId({int? budgetId}) =>
      this == ReminderType.budgetWarning ? idBase + (budgetId ?? 0) : idBase;
}
