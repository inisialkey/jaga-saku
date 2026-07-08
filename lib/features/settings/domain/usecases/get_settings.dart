import 'package:jaga_saku/features/settings/domain/repositories/settings_repository.dart';
import 'package:jaga_saku/core/utils/utils.dart';

class GetSettings {
  final SettingsRepository _repo;

  GetSettings(this._repo);

  ({ActiveTheme activeTheme, String locale}) call() {
    final themeName = _repo.getTheme() ?? ActiveTheme.system.name;
    final activeTheme = ActiveTheme.values.singleWhere(
      (e) => e.name == themeName,
      orElse: () => ActiveTheme.system,
    );
    final locale = _repo.getLocale() ?? 'en';
    return (activeTheme: activeTheme, locale: locale);
  }
}
