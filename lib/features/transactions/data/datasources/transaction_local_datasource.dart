import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/features/transactions/data/models/transaction_model.dart';

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
