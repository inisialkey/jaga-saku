import 'package:jaga_saku/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:jaga_saku/features/settings/domain/repositories/settings_repository.dart';
import 'package:jaga_saku/core/utils/utils.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDatasource _datasource;

  const SettingsRepositoryImpl(this._datasource);

  @override
  String? getTheme() => _datasource.getTheme();

  @override
  String? getLocale() => _datasource.getLocale();

  @override
  Future<void> saveTheme(String themeName) => _datasource.saveTheme(themeName);

  @override
  Future<void> saveLocale(String locale) => _datasource.saveLocale(locale);

  @override
  ActiveTheme resolveTheme() {
    final themeName = _datasource.getTheme() ?? ActiveTheme.system.name;
    return ActiveTheme.values.singleWhere(
      (e) => e.name == themeName,
      orElse: () => ActiveTheme.system,
    );
  }
}
