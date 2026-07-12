import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/core/database/sort_order_dao.dart';
import 'package:jaga_saku/features/templates/data/models/tx_template_model.dart';

/// sqflite DAO for the `tx_templates` table. Reads/writes through the shared
/// [AppDatabase] connection (resolved per call via `.db`); never opens its own.
/// Only the Home-favorite rows (`is_favorite = 1`) are surfaced — V2-M5's
/// schedule-only shapes (`0`) are read separately, so they never clutter the
/// favorites list/strip.
class TxTemplateLocalDatasource {
  TxTemplateLocalDatasource(this._database);

  final AppDatabase _database;

  static const String _table = 'tx_templates';

  /// Favorites (`is_favorite = 1`) ordered for display: `sort_order` then `id`.
  Future<List<TxTemplateModel>> getFavorites() async {
    final rows = await _database.db.rawQuery(
      'SELECT * FROM $_table WHERE is_favorite = 1 ORDER BY sort_order, id',
    );
    return rows.map(TxTemplateModel.fromMap).toList();
  }

  /// Next `sort_order` for a new row: one past the current max (`0` when empty),
  /// so inserts append to the end instead of jumping to the top.
  Future<int> nextSortOrder() =>
      SortOrderDao.nextSortOrder(_database.db, _table);

  /// Inserts a row appended to the end (via [nextSortOrder]), returning the new
  /// id. Insert is only ever a create, so the row's `sort_order` is always the
  /// next free slot.
  Future<int> insert(TxTemplateModel template) async {
    final sortOrder = await nextSortOrder();
    return _database.db.insert(_table, {
      ...template.toMap(),
      'sort_order': sortOrder,
    });
  }

  Future<void> update(TxTemplateModel template) => _database.db.update(
    _table,
    template.toMap(),
    where: 'id = ?',
    whereArgs: [template.id],
  );

  /// Deletes a row, returning the number of rows removed. `tx_templates` is a
  /// leaf table (nothing references it in M2), so a favorite delete is always a
  /// clean hard-delete — never FK-blocked.
  Future<int> delete(int id) =>
      _database.db.delete(_table, where: 'id = ?', whereArgs: [id]);

  /// Rewrites `sort_order` to match [orderedIds] in a single transaction.
  Future<void> reorder(List<int> orderedIds) =>
      SortOrderDao.reorder(_database.db, _table, orderedIds);
}
