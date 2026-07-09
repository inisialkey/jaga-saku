import 'package:get_it/get_it.dart';
import 'package:jaga_saku/core/core.dart';

GetIt sl = GetIt.instance;

/// Registers app-wide singletons. Per-feature datasources / repositories /
/// usecases / cubits are added here as milestones land (follow the reference
/// pattern once M1 introduces the first feature).
///
/// [AppDatabase] must already be opened (see `main()`).
Future<void> serviceLocator({bool isUnitTest = false}) async {
  if (isUnitTest) {
    await sl.reset();
  }

  sl.registerSingleton<AppDatabase>(AppDatabase.instance);
  sl.registerLazySingleton<SettingsService>(() => SettingsService(sl()));
}
