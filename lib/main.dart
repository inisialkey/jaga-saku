import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jaga_saku/app.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/features/reminders/data/reminder_service.dart';
import 'package:jaga_saku/features/security/app_lock_service.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

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

  // Initialize the timezone database + pin the local zone BEFORE any
  // zonedSchedule (V3-M5). Asia/Jakarta = WIB, no DST — the invariant the app's
  // money/date math already relies on (OPEN §10). Then init the reminder edge
  // (channel + tap callback + tx-bus subscription) and run an app-open catch-up
  // (a no-op when nothing is enabled). reconcile is fire-and-forget so it never
  // delays the first frame.
  tzdata.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  await sl<ReminderService>().init();
  unawaited(sl<ReminderService>().reconcile());

  runApp(const App());
}
