part of 'app_settings_cubit.dart';

/// App-global preferences (M6 + V2-M1): theme mode, locale, greeting name and
/// the budget cycle start-day, all persisted via [SettingsService].
/// `locale == null` means "follow the device" (System); `userName == null`/blank
/// means the Home guest greeting.
@freezed
abstract class AppSettingsState with _$AppSettingsState {
  const factory AppSettingsState({
    /// Default light per style guide §20; `System` is an explicit user choice.
    @Default(ThemeMode.light) ThemeMode themeMode,

    /// null → follow the device locale (System).
    Locale? locale,

    /// Greeting name; null/blank → guest greeting on Home.
    String? userName,

    /// Day-of-month a budget cycle starts (1..31; V2-M1). Default 1 == the
    /// calendar month, so every existing budget is unchanged. Clamped to the
    /// month's last valid day by `BudgetCycle`.
    @Default(1) int budgetCycleStartDay,
  }) = _AppSettingsState;
}
