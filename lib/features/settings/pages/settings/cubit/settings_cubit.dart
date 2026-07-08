import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/settings/domain/usecases/get_settings.dart';
import 'package:jaga_saku/features/settings/domain/usecases/update_language.dart';
import 'package:jaga_saku/features/settings/domain/usecases/update_theme.dart';
import 'package:jaga_saku/core/utils/utils.dart';

part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettings _getSettings;
  final UpdateTheme _updateTheme;
  final UpdateLanguage _updateLanguage;

  SettingsCubit(this._getSettings, this._updateTheme, this._updateLanguage)
    : super(const SettingsState.initial());

  void loadSettings() {
    final settings = _getSettings();
    emit(
      SettingsState.loaded(
        activeTheme: settings.activeTheme,
        locale: settings.locale,
      ),
    );
  }

  Future<void> updateTheme(ActiveTheme activeTheme) async {
    await _updateTheme(activeTheme.name);
    final locale = _currentLocale;
    emit(SettingsState.loaded(activeTheme: activeTheme, locale: locale));
  }

  Future<void> updateLanguage(String locale) async {
    await _updateLanguage(locale);
    final theme = _currentTheme;
    emit(SettingsState.loaded(activeTheme: theme, locale: locale));
  }

  ActiveTheme get _currentTheme => switch (state) {
    SettingsStateLoaded(:final activeTheme) => activeTheme,
    _ => ActiveTheme.system,
  };

  String get _currentLocale => switch (state) {
    SettingsStateLoaded(:final locale) => locale,
    _ => 'en',
  };
}

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = SettingsStateInitial;
  const factory SettingsState.loaded({
    required ActiveTheme activeTheme,
    required String locale,
  }) = SettingsStateLoaded;
}
