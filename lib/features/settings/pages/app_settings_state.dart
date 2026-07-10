part of 'app_settings_cubit.dart';

/// App-global preferences (M6): theme mode, locale and greeting name, all
/// persisted via [SettingsService]. `locale == null` means "follow the device"
/// (System); `userName == null`/blank means the Home guest greeting.
@freezed
abstract class AppSettingsState with _$AppSettingsState {
  const factory AppSettingsState({
    /// Default light per style guide §20; `System` is an explicit user choice.
    @Default(ThemeMode.light) ThemeMode themeMode,

    /// null → follow the device locale (System).
    Locale? locale,

    /// Greeting name; null/blank → guest greeting on Home.
    String? userName,
  }) = _AppSettingsState;
}
