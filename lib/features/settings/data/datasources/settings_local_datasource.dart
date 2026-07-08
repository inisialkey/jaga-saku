import 'package:jaga_saku/core/utils/utils.dart';

abstract class SettingsLocalDatasource {
  Future<void> saveTheme(String themeName);
  String? getTheme();
  Future<void> saveLocale(String locale);
  String? getLocale();
}

class SettingsLocalDatasourceImpl implements SettingsLocalDatasource {
  final MainBoxMixin _box;

  SettingsLocalDatasourceImpl(this._box);

  @override
  Future<void> saveTheme(String themeName) =>
      _box.addData(MainBoxKeys.theme, themeName);

  @override
  String? getTheme() => _box.getData<String?>(MainBoxKeys.theme);

  @override
  Future<void> saveLocale(String locale) =>
      _box.addData(MainBoxKeys.locale, locale);

  @override
  String? getLocale() => _box.getData<String?>(MainBoxKeys.locale);
}
