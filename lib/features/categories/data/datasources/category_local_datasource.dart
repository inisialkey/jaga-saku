import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/features/categories/data/models/category_model.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';

/// sqflite DAO for the `categories` table. Reads/writes through the shared
/// [AppDatabase] connection.
class CategoryLocalDatasource {
  CategoryLocalDatasource(this._database);

  final AppDatabase _database;

  static const String _table = 'categories';

  /// Categories of [type] ordered by `sort_order`, `id`. Returns a flat list
  /// (parents and children); the cubit builds the tree.
  Future<List<CategoryModel>> getCategories({
    required CategoryType type,
    bool includeArchived = false,
  }) async {
    final rows = await _database.db.query(
      _table,
      where: includeArchived ? 'type = ?' : 'type = ? AND archived = 0',
      whereArgs: [type.value],
      orderBy: 'sort_order, id',
    );
    return rows.map(CategoryModel.fromMap).toList();
  }

  /// Next `sort_order` within [type] (numbering is per-type): one past the max,
  /// so a new category appends to its list. Returns `0` for the first row of
  /// that type (`-1 + 1`).
  Future<int> nextSortOrder(CategoryType type) async {
    final rows = await _database.db.rawQuery(
      'SELECT COALESCE(MAX(sort_order), -1) + 1 AS next FROM $_table '
      'WHERE type = ?',
      [type.value],
    );
    return rows.first['next']! as int;
  }

  /// Inserts a row appended to the end of its type (via [nextSortOrder]),
  /// returning the new id. Insert is only ever a create.
  Future<int> insert(CategoryModel category) async {
    final sortOrder = await nextSortOrder(category.type);
    return _database.db.insert(_table, {
      ...category.toMap(),
      'sort_order': sortOrder,
    });
  }

  Future<void> update(CategoryModel category) => _database.db.update(
    _table,
    category.toMap(),
    where: 'id = ?',
    whereArgs: [category.id],
  );

  /// Deletes a row; sub-categories cascade via the self-ref FK. Returns the
  /// number of rows removed (excludes cascaded children).
  Future<int> delete(int id) =>
      _database.db.delete(_table, where: 'id = ?', whereArgs: [id]);

  Future<void> setArchived(int id, {required bool archived}) =>
      _database.db.update(
        _table,
        {'archived': archived ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );

  Future<void> reorder(List<int> orderedIds) =>
      _database.db.transaction((txn) async {
        for (var i = 0; i < orderedIds.length; i++) {
          await txn.update(
            _table,
            {'sort_order': i},
            where: 'id = ?',
            whereArgs: [orderedIds[i]],
          );
        }
      });
}
