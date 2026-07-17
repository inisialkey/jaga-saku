import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/transactions/data/datasources/transaction_query.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// Pure unit tests for [TransactionQuery.buildWhere] — the shared WHERE builder
/// consumed by Export (V3-M2) and Search (V3-M3). Proves the empty case, each
/// single facet's predicate + arg, the account OR-both-sides clause, the
/// half-open date range, the AND-joined combination in field order, and that
/// every clause is `t.`-qualified (required by the aliased join).
void main() {
  test('no filter → empty where and no args', () {
    final result = TransactionQuery.buildWhere(const SearchTransactionParams());
    expect(result.where, '');
    expect(result.args, isEmpty);
  });

  test('startDate → half-open lower bound', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(startDate: 100),
    );
    expect(result.where, 't.date >= ?');
    expect(result.args, [100]);
  });

  test('endDate → half-open upper bound', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(endDate: 200),
    );
    expect(result.where, 't.date < ?');
    expect(result.args, [200]);
  });

  test('date range → two clauses in order', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(startDate: 100, endDate: 200),
    );
    expect(result.where, 't.date >= ? AND t.date < ?');
    expect(result.args, [100, 200]);
  });

  test('accountId → OR both sides with the id bound twice', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(accountId: 5),
    );
    expect(result.where, '(t.account_id = ? OR t.to_account_id = ?)');
    expect(result.args, [5, 5]);
  });

  test('categoryId → equality', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(categoryId: 9),
    );
    expect(result.where, 't.category_id = ?');
    expect(result.args, [9]);
  });

  test('type → enum .value', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(type: TransactionType.transfer),
    );
    expect(result.where, 't.type = ?');
    expect(result.args, ['transfer']);
  });

  test('plannedStatus → enum .value', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(plannedStatus: PlannedStatus.unplanned),
    );
    expect(result.where, 't.planned_status = ?');
    expect(result.args, ['unplanned']);
  });

  test('spendingType → enum .value', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(spendingType: SpendingType.want),
    );
    expect(result.where, 't.spending_type = ?');
    expect(result.args, ['want']);
  });

  test('combined filters → AND-joined in field order with matching args', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(
        startDate: 100,
        endDate: 200,
        accountId: 5,
        categoryId: 9,
        type: TransactionType.expense,
        plannedStatus: PlannedStatus.planned,
        spendingType: SpendingType.need,
      ),
    );
    expect(
      result.where,
      't.date >= ? AND t.date < ? '
      'AND (t.account_id = ? OR t.to_account_id = ?) '
      'AND t.category_id = ? '
      'AND t.type = ? AND t.planned_status = ? AND t.spending_type = ?',
    );
    expect(result.args, [100, 200, 5, 5, 9, 'expense', 'planned', 'need']);
  });

  test('every emitted clause is t.-qualified', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(
        startDate: 1,
        endDate: 2,
        accountId: 3,
        categoryId: 4,
        type: TransactionType.income,
        plannedStatus: PlannedStatus.planned,
        spendingType: SpendingType.emergency,
      ),
    );
    // Each AND-joined predicate must carry the `t.` alias so the join (which
    // also selects same-named columns off accounts/categories) is never
    // ambiguous.
    for (final clause in result.where.split(' AND ')) {
      expect(
        clause.contains('t.'),
        isTrue,
        reason: 'clause is not t.-qualified: $clause',
      );
    }
  });
}
