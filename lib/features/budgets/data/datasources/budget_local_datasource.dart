import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/features/budgets/data/models/budget_model.dart';

/// sqflite DAO for the `budgets` table. Reads/writes through the shared
/// [AppDatabase] connection (resolved per call via `.db`); never opens its own.
///
/// The derived `spent` per budget is computed in SQL by summing the matching
/// category's expenses whose period bucket equals the budget's `period`. The
/// bucket is derived with `strftime('%Y-%m', datetime(date/1000,'unixepoch',
/// 'localtime'))` — the `localtime` conversion mirrors how Dart derives a tx's
/// period from its midnight-local `date` (see `periodKey`), so a tx counts under
/// exactly the month it displays in (proven by the month-boundary datasource
/// test).
class BudgetLocalDatasource {
  BudgetLocalDatasource(this._database);

  final AppDatabase _database;

  static const String _table = 'budgets';

  /// Budgets for [period] ('YYYY-MM'), each left-joined to the sum of its
  /// category's expenses in the same period (`spent`, 0 when none), ordered by
  /// insertion.
  Future<List<BudgetModel>> getBudgetsForPeriod(String period) async {
    final rows = await _database.db.rawQuery(
      '''
      SELECT b.*,
        COALESCE((
          SELECT SUM(t.amount) FROM transactions t
          WHERE t.category_id = b.category_id
            AND t.type = 'expense'
            AND strftime('%Y-%m', datetime(t.date / 1000, 'unixepoch', 'localtime')) = b.period
        ), 0) AS spent
      FROM $_table b
      WHERE b.period = ?
      ORDER BY b.created_at, b.id
    ''',
      [period],
    );
    return rows.map(BudgetModel.fromMap).toList();
  }

  /// Inserts a new budget row, returning the new id. A duplicate
  /// `(category_id, period)` hits the UNIQUE constraint (the repo maps it to a
  /// conflict).
  Future<int> insert(BudgetModel budget) =>
      _database.db.insert(_table, budget.toMap());

  Future<void> update(BudgetModel budget) => _database.db.update(
    _table,
    budget.toMap(),
    where: 'id = ?',
    whereArgs: [budget.id],
  );

  /// Deletes a row, returning the number of rows removed.
  Future<int> delete(int id) =>
      _database.db.delete(_table, where: 'id = ?', whereArgs: [id]);
}
