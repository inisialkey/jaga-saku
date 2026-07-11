import 'package:sqflite/sqflite.dart';

/// Shared `sort_order` helpers for tables with an integer `sort_order` column
/// (accounts, categories) — one home for the append/reorder SQL.
class SortOrderDao {
  SortOrderDao._();

  /// Next `sort_order` for [table]: one past the current max (`0` when empty).
  /// [where]/[whereArgs] scope the max to a subset (categories number per-type).
  static Future<int> nextSortOrder(
    DatabaseExecutor db,
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final rows = await db.rawQuery(
      'SELECT COALESCE(MAX(sort_order), -1) + 1 AS next FROM $table'
      '${where == null ? '' : ' WHERE $where'}',
      whereArgs,
    );
    return rows.first['next']! as int;
  }

  /// Rewrites `sort_order` in [table] to match [orderedIds] in one transaction.
  static Future<void> reorder(
    Database db,
    String table,
    List<int> orderedIds,
  ) => db.transaction((txn) async {
    for (var i = 0; i < orderedIds.length; i++) {
      await txn.update(
        table,
        {'sort_order': i},
        where: 'id = ?',
        whereArgs: [orderedIds[i]],
      );
    }
  });
}
