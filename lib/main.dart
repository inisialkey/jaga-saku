import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jaga_saku/app.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load Indonesian date symbols so DateFormat(..., 'id') renders month/day
  // names in the app's primary locale instead of throwing LocaleDataException.
  await initializeDateFormatting('id');

  // Open (and, on first run, create + seed) the local database before the
  // service locator so datasources can resolve their connection synchronously.
  await AppDatabase.instance.open();

  await serviceLocator();

  runApp(const App());
}
