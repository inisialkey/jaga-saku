import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/features/transactions/data/datasources/transaction_query.dart';
import 'package:jaga_saku/features/transactions/data/models/transaction_model.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';

/// sqflite DAO for the `transactions` table. Reads/writes through the shared
/// [AppDatabase] connection (resolved per call via `.db`); never opens its own.
///
/// Date-range reads (`getByMonth` / `getByDay`) compute their `[start, end)`
/// epoch-millis bounds in Dart from midnight-local dates and hit the
/// `idx_tx_date` index. The upper bound is exclusive so the last millisecond of
/// a day/month is never double-counted.
class TransactionLocalDatasource {
  TransactionLocalDatasource(this._database);

  final AppDatabase _database;

  static const String _table = 'transactions';

  Future<int> insert(TransactionModel transaction) =>
      _database.db.insert(_table, transaction.toMap());

  Future<void> update(TransactionModel transaction) => _database.db.update(
    _table,
    transaction.toMap(),
    where: 'id = ?',
    whereArgs: [transaction.id],
  );

  /// Deletes a row, returning the number of rows removed.
  Future<int> delete(int id) =>
      _database.db.delete(_table, where: 'id = ?', whereArgs: [id]);

  /// The stored `receipt_path` for [id] (or null if none / row absent). Used by
  /// the repository to clean up the file before deleting the row.
  Future<String?> getReceiptPath(int id) async {
    final rows = await _database.db.query(
      _table,
      columns: ['receipt_path'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['receipt_path'] as String?;
  }

  /// Every transaction whose `date` lands in [month]'s calendar month
  /// (`[monthStart, nextMonthStart)`), newest first.
  Future<List<TransactionModel>> getByMonth(DateTime month) {
    final start = DateTime(month.year, month.month).millisecondsSinceEpoch;
    // month + 1 rolls December → next January (Dart normalizes the overflow).
    final end = DateTime(month.year, month.month + 1).millisecondsSinceEpoch;
    return _range(start, end);
  }

  /// A single day's transactions (`[dayStart, nextDayStart)`), newest first.
  Future<List<TransactionModel>> getByDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day).millisecondsSinceEpoch;
    // day + 1 rolls month/year ends over (Dart normalizes the overflow).
    final end = DateTime(
      day.year,
      day.month,
      day.day + 1,
    ).millisecondsSinceEpoch;
    return _range(start, end);
  }

  /// The [limit] most recent transactions across all accounts, newest first.
  Future<List<TransactionModel>> getRecent(int limit) async {
    final rows = await _database.db.query(
      _table,
      orderBy: 'date DESC, id DESC',
      limit: limit,
    );
    return rows.map(TransactionModel.fromMap).toList();
  }

  /// Signed monthly net deltas (`Σincome − Σexpense`; transfers ⇒ 0) over
  /// `[startMillis, endMillis)`, grouped by the SAME local-month bucket the
  /// budget spend SQL uses (`budget_local_datasource.dart:32`) — no new month
  /// definition. Adjustments are income/expense rows, so they are **included**
  /// (they move real assets — unlike the income/expense report cards, which
  /// exclude them). Ordered oldest→newest; only months with activity appear.
  Future<List<MonthDelta>> monthlyNetDeltas(
    int startMillis,
    int endMillis,
  ) async {
    final rows = await _database.db.rawQuery(
      '''
      SELECT
        strftime('%Y-%m', datetime(date / 1000, 'unixepoch', 'localtime')) AS m,
        SUM(CASE type
              WHEN 'income'  THEN amount
              WHEN 'expense' THEN -amount
              ELSE 0
            END) AS delta
      FROM $_table
      WHERE date >= ? AND date < ?
      GROUP BY m
      ORDER BY m
      ''',
      [startMillis, endMillis],
    );
    return rows.map((r) {
      // GROUP BY m always yields the bucket key, so `m` is never null.
      final parts = (r['m']! as String).split('-');
      final monthMillis = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
      ).millisecondsSinceEpoch;
      return MonthDelta(
        monthMillis: monthMillis,
        delta: (r['delta'] as int?) ?? 0,
      );
    }).toList();
  }

  /// Filtered read for Export (V3-M2) and Search (V3-M3): the `transactions`
  /// rows matching [params], LEFT-JOINed to their account / target-account /
  /// category **names** plus the category `system_key` (which drives the
  /// reconciliation source in the same pass). `LEFT JOIN` (not INNER) so a
  /// transfer's null `category_id` and an income's null `to_account_id` still
  /// yield a row with an empty joined cell. Read-only — one `rawQuery`, no
  /// mutation. Returns neutral column maps (no export-domain import here); the
  /// export repo maps them to `ExportRow`.
  Future<List<Map<String, Object?>>> searchWithNames(
    SearchTransactionParams params,
  ) {
    final (:where, :args) = TransactionQuery.buildWhere(params);
    final whereClause = where.isEmpty ? '' : 'WHERE $where';
    return _database.db.rawQuery('''
      SELECT t.*,
        a.name  AS account_name,
        a2.name AS target_account_name,
        c.name  AS category_name,
        c.system_key AS category_system_key
      FROM $_table t
      LEFT JOIN accounts   a  ON a.id  = t.account_id
      LEFT JOIN accounts   a2 ON a2.id = t.to_account_id
      LEFT JOIN categories c  ON c.id  = t.category_id
      $whereClause
      ORDER BY t.date, t.id
    ''', args);
  }

  Future<List<TransactionModel>> _range(int startMillis, int endMillis) async {
    final rows = await _database.db.query(
      _table,
      where: 'date >= ? AND date < ?',
      whereArgs: [startMillis, endMillis],
      orderBy: 'date DESC, id DESC',
    );
    return rows.map(TransactionModel.fromMap).toList();
  }
}
