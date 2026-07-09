import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/core/utils/services/settings/settings_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _MockAppDatabase extends Mock implements AppDatabase {}

/// Exercises [SettingsService] against a real in-memory sqflite (ffi) database,
/// mocking only [AppDatabase] so the service resolves a live connection without
/// touching the filesystem or the global singleton.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late SettingsService service;

  setUp(() async {
    db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: Migrations.latestVersion,
        onCreate: (db, _) => Migrations.onCreate(db),
      ),
    );
    final appDatabase = _MockAppDatabase();
    when(() => appDatabase.db).thenReturn(db);
    service = SettingsService(appDatabase);
  });

  tearDown(() => db.close());

  test('getString returns null for an unknown key', () async {
    expect(await service.getString('missing'), isNull);
  });

  test('setString then getString round-trips the value', () async {
    await service.setString('theme', 'dark');
    expect(await service.getString('theme'), 'dark');
  });

  test('setString on an existing key replaces the previous value', () async {
    await service.setString('locale', 'en');
    await service.setString('locale', 'id');
    expect(await service.getString('locale'), 'id');
  });

  test('remove deletes the stored value', () async {
    await service.setString('theme', 'light');
    await service.remove('theme');
    expect(await service.getString('theme'), isNull);
  });
}
