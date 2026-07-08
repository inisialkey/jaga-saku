import 'package:jaga_saku/features/settings/domain/repositories/settings_repository.dart';

class UpdateTheme {
  final SettingsRepository _repo;

  UpdateTheme(this._repo);

  Future<void> call(String themeName) => _repo.saveTheme(themeName);
}
