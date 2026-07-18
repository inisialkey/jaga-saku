import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction_source.dart';

/// Translates a [SearchTransactionParams] into a parameterised SQL `WHERE`
/// fragment (+ an `ORDER BY` clause) for the filtered-transaction reads shared
/// by Export (V3-M2) and Search (V3-M3). Pure — no DB handle, no I/O — so it is
/// unit-testable in isolation and reused verbatim by both callers.
///
/// Every `transactions` column is **`t.`-qualified** on purpose, and the
/// keyword / source facets additionally reference the **joined aliases**
/// `a` (source account), `a2` (transfer target account) and `c` (category):
/// the queries that consume [buildWhere] alias `transactions AS t` and
/// `LEFT JOIN accounts a` / `accounts a2` / `categories c`. `accounts` and
/// `categories` carry columns of the same name as `transactions`
/// (`type`, `id`, `name`, …), so an unqualified predicate would be ambiguous.
/// **Any query using [buildWhere] MUST provide those three joins with those
/// exact aliases** (`searchWithNames` and `search` both do).
class TransactionQuery {
  const TransactionQuery._();

  /// Builds the non-null clauses joined with `AND` (empty string when no filter
  /// is set) plus the positional args in the same order. The account filter
  /// matches **either side** so exporting/searching an account includes its
  /// incoming transfers (`to_account_id`).
  static ({String where, List<Object?> args}) buildWhere(
    SearchTransactionParams p,
  ) {
    final clauses = <String>[];
    final args = <Object?>[];

    if (p.startDate != null) {
      clauses.add('t.date >= ?');
      args.add(p.startDate);
    }
    if (p.endDate != null) {
      clauses.add('t.date < ?');
      args.add(p.endDate);
    }
    if (p.accountId != null) {
      clauses.add('(t.account_id = ? OR t.to_account_id = ?)');
      args
        ..add(p.accountId)
        ..add(p.accountId);
    }
    if (p.categoryId != null) {
      clauses.add('t.category_id = ?');
      args.add(p.categoryId);
    }
    if (p.type != null) {
      clauses.add('t.type = ?');
      args.add(p.type!.value);
    }
    if (p.plannedStatus != null) {
      clauses.add('t.planned_status = ?');
      args.add(p.plannedStatus!.value);
    }
    if (p.spendingType != null) {
      clauses.add('t.spending_type = ?');
      args.add(p.spendingType!.value);
    }

    // ── V3-M3 search-only facets (Export never sets these) ──────────────────
    // Keyword: case-insensitive substring across the note + the three joined
    // names. A leading-wildcard LIKE can't use an index (accepted — personal
    // single-user DB, no FTS engine per scope).
    final keyword = p.keyword?.trim();
    if (keyword != null && keyword.isNotEmpty) {
      final like = '%${keyword.toLowerCase()}%';
      clauses.add(
        '(LOWER(t.note) LIKE ? OR LOWER(a.name) LIKE ? '
        'OR LOWER(a2.name) LIKE ? OR LOWER(c.name) LIKE ?)',
      );
      args
        ..add(like)
        ..add(like)
        ..add(like)
        ..add(like);
    }
    // Source is derived from the joined category system_key. The IN-list
    // placeholders + args are built from the enum's key set (single source of
    // truth), so the SQL always tracks [TransactionSource.adjustmentSystemKeys].
    if (p.source != null) {
      const keys = TransactionSource.adjustmentSystemKeys;
      final placeholders = List.filled(keys.length, '?').join(',');
      clauses.add(
        p.source == TransactionSource.reconciliation
            ? 'c.system_key IN ($placeholders)'
            : '(c.system_key IS NULL OR c.system_key NOT IN ($placeholders))',
      );
      args.addAll(keys);
    }
    if (p.minAmount != null) {
      clauses.add('t.amount >= ?');
      args.add(p.minAmount);
    }
    if (p.maxAmount != null) {
      clauses.add('t.amount <= ?');
      args.add(p.maxAmount);
    }
    if (p.hasReceipt != null) {
      clauses.add(
        p.hasReceipt! ? 't.receipt_path IS NOT NULL' : 't.receipt_path IS NULL',
      );
    }

    return (where: clauses.join(' AND '), args: args);
  }

  /// The `ORDER BY` clause for [sort]. Enum → fixed string (no injection
  /// surface). `id` breaks a same-`date` tie deterministically; `date` breaks a
  /// same-`amount` tie for the amount sorts.
  static String orderBy(SortOption sort) => switch (sort) {
    SortOption.newest => 't.date DESC, t.id DESC',
    SortOption.oldest => 't.date ASC, t.id ASC',
    SortOption.highest => 't.amount DESC, t.date DESC',
    SortOption.lowest => 't.amount ASC, t.date DESC',
  };
}
