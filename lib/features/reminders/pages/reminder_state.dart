part of 'reminder_cubit.dart';

/// Reminders settings screen state (V3-M5), mirroring `AppSettingsState`'s
/// string-encoded-kv shape. [permissionDenied] is a transient flag the page
/// listens on to revert the switch + show the "grant in system settings" hint.
@freezed
abstract class ReminderState with _$ReminderState {
  const factory ReminderState({
    @Default(false) bool dailyEnabled,

    /// Hour/minute of the daily nudge (default 20:00).
    @Default(20) int dailyHour,
    @Default(0) int dailyMinute,
    @Default(false) bool recurringDueEnabled,
    @Default(false) bool budgetWarningEnabled,

    /// Set true when the last enable was blocked by an OS permission denial;
    /// cleared on the next successful toggle.
    @Default(false) bool permissionDenied,
  }) = _ReminderState;
}
