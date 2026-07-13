import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/features/budgets/data/models/budget_model.dart';

/// sqflite DAO for the `budgets` table. Reads/writes through the shared
/// [AppDatabase] connection (resolved per call via `.db`); never opens its own.
///
/// V2-M1: the derived `spent` per budget is the sum of the matching category's
/// expenses whose `date` falls in the budget's stored half-open cycle window
/// `[period_start, period_end)`. This replaces the old `strftime('%Y-%m', …)`
/// month bucket; at start-day 1 the window is the calendar month, so a tx counts
/// under exactly the cycle it belongs to (proven by the boundary datasource
/// test — a tx one ms before `start` and one at `end` are excluded).
class BudgetLocalDatasource {
  BudgetLocalDatasource(this._database);

  final AppDatabase _database;

  static const String _table = 'budgets';

  /// Budgets whose label is [period] ('YYYY-MM'), each left-joined to the sum of
  /// its category's expenses inside that budget's stored `[period_start,
  /// period_end)` cycle window (`spent`, 0 when none), ordered by insertion.
  Future<List<BudgetModel>> getBudgetsForPeriod(String period) async {
    final rows = await _database.db.rawQuery(
      '''
      SELECT b.*,
        COALESCE((
          SELECT SUM(t.amount) FROM transactions t
          WHERE t.category_id = b.category_id
            AND t.type = 'expense'
            AND t.date >= b.period_start AND t.date < b.period_end
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
