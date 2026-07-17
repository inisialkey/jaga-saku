import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';

/// Translates a [SearchTransactionParams] into a parameterised SQL `WHERE`
/// fragment for the filtered-transaction reads shared by Export (V3-M2) and
/// Search (V3-M3). Pure — no DB handle, no I/O — so it is unit-testable in
/// isolation and reused verbatim by both callers.
///
/// Every column is **`t.`-qualified** on purpose: the join that consumes this
/// aliases `transactions` as `t` and also joins `accounts` / `categories`,
/// which carry columns of the same name (`type`, `id`, `name`, …). An
/// unqualified `type = ?` would be ambiguous SQL, so any query using
/// [buildWhere] MUST alias `transactions AS t`.
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

    return (where: clauses.join(' AND '), args: args);
  }
}
