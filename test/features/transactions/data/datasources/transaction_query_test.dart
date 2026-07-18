import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/transactions/data/datasources/transaction_query.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction_source.dart';

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

  // ── V3-M3 facets (keyword / source / amount / receipt) + orderBy ──────────

  test('keyword → 4 ORed case-insensitive LIKE across note + joined names', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(keyword: 'BCA'),
    );
    expect(
      result.where,
      '(LOWER(t.note) LIKE ? OR LOWER(a.name) LIKE ? '
      'OR LOWER(a2.name) LIKE ? OR LOWER(c.name) LIKE ?)',
    );
    expect(result.args, ['%bca%', '%bca%', '%bca%', '%bca%']);
  });

  test('a whitespace-only keyword emits no clause', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(keyword: '   '),
    );
    expect(result.where, '');
    expect(result.args, isEmpty);
  });

  test('source reconciliation → IN the adjustment key set', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(source: TransactionSource.reconciliation),
    );
    expect(result.where, 'c.system_key IN (?,?)');
    expect(result.args, ['adjustment_in', 'adjustment_out']);
  });

  test('source manual → NULL or NOT IN the adjustment key set', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(source: TransactionSource.manual),
    );
    expect(result.where, '(c.system_key IS NULL OR c.system_key NOT IN (?,?))');
    expect(result.args, ['adjustment_in', 'adjustment_out']);
  });

  test('minAmount → inclusive lower bound', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(minAmount: 5000),
    );
    expect(result.where, 't.amount >= ?');
    expect(result.args, [5000]);
  });

  test('maxAmount → inclusive upper bound', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(maxAmount: 9000),
    );
    expect(result.where, 't.amount <= ?');
    expect(result.args, [9000]);
  });

  test('hasReceipt true → IS NOT NULL with no arg', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(hasReceipt: true),
    );
    expect(result.where, 't.receipt_path IS NOT NULL');
    expect(result.args, isEmpty);
  });

  test('hasReceipt false → IS NULL with no arg', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(hasReceipt: false),
    );
    expect(result.where, 't.receipt_path IS NULL');
    expect(result.args, isEmpty);
  });

  test('the new facets append after the existing seven, in order', () {
    final result = TransactionQuery.buildWhere(
      const SearchTransactionParams(
        startDate: 100,
        keyword: 'x',
        source: TransactionSource.reconciliation,
        minAmount: 1,
        maxAmount: 2,
        hasReceipt: true,
      ),
    );
    expect(
      result.where,
      't.date >= ? '
      'AND (LOWER(t.note) LIKE ? OR LOWER(a.name) LIKE ? '
      'OR LOWER(a2.name) LIKE ? OR LOWER(c.name) LIKE ?) '
      'AND c.system_key IN (?,?) '
      'AND t.amount >= ? AND t.amount <= ? '
      'AND t.receipt_path IS NOT NULL',
    );
    expect(result.args, [
      100,
      '%x%',
      '%x%',
      '%x%',
      '%x%',
      'adjustment_in',
      'adjustment_out',
      1,
      2,
    ]);
  });

  group('orderBy', () {
    test('newest → date then id, descending', () {
      expect(
        TransactionQuery.orderBy(SortOption.newest),
        't.date DESC, t.id DESC',
      );
    });
    test('oldest → date then id, ascending', () {
      expect(
        TransactionQuery.orderBy(SortOption.oldest),
        't.date ASC, t.id ASC',
      );
    });
    test('highest → amount desc, date desc', () {
      expect(
        TransactionQuery.orderBy(SortOption.highest),
        't.amount DESC, t.date DESC',
      );
    });
    test('lowest → amount asc, date desc', () {
      expect(
        TransactionQuery.orderBy(SortOption.lowest),
        't.amount ASC, t.date DESC',
      );
    });
  });
}
