import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// Pure aggregation over [Transaction] lists — **no Flutter, no DB** (rule 19,
/// mirrors the [BudgetStatus] / `insight_rules` precedent). The single home for
/// the income/expense + expense-by-category folds that Home and Insight both
/// derive, so a new report view reuses these instead of forking a third copy.
///
/// Every method is a deterministic transform of its input list. Scope (a month,
/// a single day, a custom range) lives in the caller — pass the already-filtered
/// list; the helper never looks at dates.
class TransactionAggregator {
  const TransactionAggregator._();

  /// Sums income and expense amounts, **excluding transfers** (internal moves
  /// belong to neither side). Amounts are positive rupiah ints whose sign is
  /// implied by [Transaction.type], so both totals accumulate `+ t.amount`.
  static ({int income, int expense}) incomeExpense(List<Transaction> txs) {
    var income = 0;
    var expense = 0;
    for (final t in txs) {
      switch (t.type) {
        case TransactionType.income:
          income += t.amount;
        case TransactionType.expense:
          expense += t.amount;
        case TransactionType.transfer:
          break; // internal move — excluded from both
      }
    }
    return (income: income, expense: expense);
  }

  /// Sum of expense amounts per (non-null) category id. Non-expense rows and
  /// expenses with a null [Transaction.categoryId] are skipped, so the map's
  /// keys are exactly the expense categories present in [txs].
  static Map<int, int> expenseByCategory(List<Transaction> txs) {
    final byCategory = <int, int>{};
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      final categoryId = t.categoryId;
      if (categoryId == null) continue;
      byCategory[categoryId] = (byCategory[categoryId] ?? 0) + t.amount;
    }
    return byCategory;
  }
}
