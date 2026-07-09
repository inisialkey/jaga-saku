import 'package:jaga_saku/core/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

/// Simple key/value store backed by the `settings` table (theme, locale, and
/// other app-level preferences). Values are stored as TEXT; callers encode /
/// decode richer types themselves.
class SettingsService {
  SettingsService(this._database);

  final AppDatabase _database;

  static const String _table = 'settings';

  Future<String?> getString(String key) async {
    final rows = await _database.db.query(
      _table,
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  Future<void> setString(String key, String value) async {
    await _database.db.insert(_table, {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> remove(String key) async {
    await _database.db.delete(_table, where: 'key = ?', whereArgs: [key]);
  }
}
