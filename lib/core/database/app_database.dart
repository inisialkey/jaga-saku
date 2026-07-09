import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/core/database/seed.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Single owner of the app's sqflite [Database] handle.
///
/// Open once in `main()` (`await AppDatabase.instance.open()`) before the
/// service locator so datasources can resolve [db] synchronously. Feature
/// datasources read/write through [db]; they never open their own connection.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const String fileName = 'jaga_saku.db';

  Database? _db;

  /// The open connection. Throws if accessed before [open] — a programming
  /// error, so it fails loud rather than silently opening a second handle.
  Database get db {
    final db = _db;
    if (db == null) {
      throw StateError('AppDatabase.open() must be awaited before using db.');
    }
    return db;
  }

  /// Opens (and if needed creates + seeds) the database. Idempotent.
  Future<Database> open() async {
    if (_db != null) return _db!;

    final basePath = await getDatabasesPath();
    final path = p.join(basePath, fileName);

    _db = await openDatabase(
      path,
      version: Migrations.latestVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: Migrations.migrate,
    );
    log.d('AppDatabase opened at $path');
    return _db!;
  }

  static Future<void> _onConfigure(Database db) =>
      db.execute('PRAGMA foreign_keys = ON');

  static Future<void> _onCreate(Database db, int version) async {
    await Migrations.onCreate(db);
    await Seed.run(db);
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
