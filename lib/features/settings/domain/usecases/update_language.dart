import 'package:jaga_saku/features/settings/domain/repositories/settings_repository.dart';

class UpdateLanguage {
  final SettingsRepository _repo;

  UpdateLanguage(this._repo);

  Future<void> call(String locale) => _repo.saveLocale(locale);
}
