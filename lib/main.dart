import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jaga_saku/app.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/features/security/app_lock_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load Indonesian date symbols so DateFormat(..., 'id') renders month/day
  // names in the app's primary locale instead of throwing LocaleDataException.
  await initializeDateFormatting('id');

  // Open (and, on first run, create + seed) the local database before the
  // service locator so datasources can resolve their connection synchronously.
  await AppDatabase.instance.open();

  await serviceLocator();

  // Load persisted theme / locale / name before the first frame so there is no
  // theme or language flash on cold start (M6).
  await sl<AppSettingsCubit>().load();

  // Load the app-lock config before the first frame so the very first router
  // redirect already knows the lock state — a PIN-enabled app opens straight on
  // the lock screen with no flash-of-content (V3-M4, §4-A).
  await sl<AppLockService>().load();

  runApp(const App());
}
