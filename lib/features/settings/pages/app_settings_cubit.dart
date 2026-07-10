import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/utils/services/settings/settings_service.dart';

part 'app_settings_state.dart';
part 'app_settings_cubit.freezed.dart';

/// The single app-global preferences owner (M6): theme mode + locale + greeting
/// name, each persisted to [SettingsService] and emitted so the whole app
/// reacts live — `app.dart` feeds `themeMode`/`locale` into `MaterialApp`, and
/// the Home greeting reads [AppSettingsState.userName].
///
/// Registered as a DI singleton and [load]ed once before `runApp`, so the first
/// frame already uses the persisted theme/locale (no cold-start flash). Every
/// emit is guarded by [isClosed] (rule 5). App-lifetime singleton — never
/// closed (like `TxChangeNotifier`).
class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit(this._settings) : super(const AppSettingsState());

  final SettingsService _settings;

  static const String _themeKey = 'theme_mode';
  static const String _localeKey = 'locale';
  static const String _nameKey = 'user_name';

  /// Stored value + user choice for "follow the device" (locale System).
  static const String _system = 'system';

  /// Reads the three persisted keys into the state. Defaults when unset: light
  /// theme (style guide §20), system locale (`null`), no name. Called before
  /// `runApp` so the first frame is already correct.
  Future<void> load() async {
    final theme = _themeModeFrom(await _settings.getString(_themeKey));
    final locale = _localeFrom(await _settings.getString(_localeKey));
    final name = _clean(await _settings.getString(_nameKey));
    if (isClosed) return;
    emit(state.copyWith(themeMode: theme, locale: locale, userName: name));
  }

  /// Persists + applies the theme mode (instant, app-wide via `app.dart`).
  Future<void> setThemeMode(ThemeMode mode) async {
    await _settings.setString(_themeKey, mode.name);
    if (isClosed) return;
    emit(state.copyWith(themeMode: mode));
  }

  /// Persists + applies the locale; `null` ⇒ System (follow the device).
  Future<void> setLocale(Locale? locale) async {
    await _settings.setString(_localeKey, locale?.languageCode ?? _system);
    if (isClosed) return;
    emit(state.copyWith(locale: locale));
  }

  /// Persists + applies the greeting name; blank ⇒ guest greeting on Home.
  Future<void> setUserName(String? name) async {
    final clean = _clean(name);
    await _settings.setString(_nameKey, clean ?? '');
    if (isClosed) return;
    emit(state.copyWith(userName: clean));
  }

  ThemeMode _themeModeFrom(String? value) => switch (value) {
    'dark' => ThemeMode.dark,
    'system' => ThemeMode.system,
    // null / 'light' / anything else → light (style guide §20 default).
    _ => ThemeMode.light,
  };

  Locale? _localeFrom(String? value) => switch (value) {
    'id' => const Locale('id'),
    'en' => const Locale('en'),
    // null / 'system' / anything else → follow the device locale.
    _ => null,
  };

  /// Trimmed non-empty string, or null (treats blank as "unset").
  String? _clean(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
