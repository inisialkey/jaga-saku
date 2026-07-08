import 'package:jaga_saku/core/utils/utils.dart';

abstract class SettingsRepository {
  String? getTheme();
  String? getLocale();
  Future<void> saveTheme(String themeName);
  Future<void> saveLocale(String locale);
  ActiveTheme resolveTheme();
}
