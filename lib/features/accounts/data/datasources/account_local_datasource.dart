import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/features/accounts/data/models/account_model.dart';

/// sqflite DAO for the `accounts` table. Reads/writes through the shared
/// [AppDatabase] connection (resolved per call via `.db`); never opens its own.
class AccountLocalDatasource {
  AccountLocalDatasource(this._database);

  final AppDatabase _database;

  static const String _table = 'accounts';

  /// Accounts with a derived `balance` = opening balance +/- signed transaction
  /// sums. The `transactions` table is empty in M1, so `balance` equals
  /// `opening_balance` today; the query is already correct once M2 lands.
  Future<List<AccountModel>> getAccounts({bool includeArchived = false}) async {
    final where = includeArchived ? '' : 'WHERE a.archived = 0';
    final rows = await _database.db.rawQuery('''
      SELECT a.*,
        a.opening_balance
        + COALESCE((SELECT SUM(amount) FROM transactions WHERE type = 'income'   AND account_id    = a.id), 0)
        + COALESCE((SELECT SUM(amount) FROM transactions WHERE type = 'transfer' AND to_account_id = a.id), 0)
        - COALESCE((SELECT SUM(amount) FROM transactions WHERE type = 'expense'  AND account_id    = a.id), 0)
        - COALESCE((SELECT SUM(amount) FROM transactions WHERE type = 'transfer' AND account_id    = a.id), 0)
          AS balance
      FROM $_table a
      $where
      ORDER BY a.sort_order, a.id
    ''');
    return rows.map(AccountModel.fromMap).toList();
  }

  /// Next `sort_order` for a new row: one past the current max, so inserts
  /// append to the end of the list instead of jumping to the top. Returns `0`
  /// for the first row (`-1 + 1`).
  Future<int> nextSortOrder() async {
    final rows = await _database.db.rawQuery(
      'SELECT COALESCE(MAX(sort_order), -1) + 1 AS next FROM $_table',
    );
    return rows.first['next']! as int;
  }

  /// Inserts a row appended to the end (via [nextSortOrder]), returning the new
  /// id. Insert is only ever a create, so the row's `sort_order` is always the
  /// next free slot.
  Future<int> insert(AccountModel account) async {
    final sortOrder = await nextSortOrder();
    return _database.db.insert(_table, {
      ...account.toMap(),
      'sort_order': sortOrder,
    });
  }

  Future<void> update(AccountModel account) => _database.db.update(
    _table,
    account.toMap(),
    where: 'id = ?',
    whereArgs: [account.id],
  );

  /// Deletes a row, returning the number of rows removed.
  Future<int> delete(int id) =>
      _database.db.delete(_table, where: 'id = ?', whereArgs: [id]);

  Future<void> setArchived(int id, {required bool archived}) =>
      _database.db.update(
        _table,
        {'archived': archived ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );

  /// Rewrites `sort_order` to match [orderedIds] in a single transaction.
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
