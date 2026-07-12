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
  ///
  /// [excludeCategoryIds] (V2-M6) drops rows tagged a reserved/adjustment
  /// category from both totals — a reconcile correction moves balance, not
  /// reports. Default `const {}` = the pre-M6 behaviour, so legacy callers are
  /// unchanged. The set is passed in, never resolved here (rule 19 — the
  /// aggregator stays pure, Flutter- and DB-free).
  static ({int income, int expense}) incomeExpense(
    List<Transaction> txs, {
    Set<int> excludeCategoryIds = const {},
  }) {
    var income = 0;
    var expense = 0;
    for (final t in txs) {
      if (t.categoryId != null && excludeCategoryIds.contains(t.categoryId)) {
        continue; // an adjustment moves balance, not income/expense
      }
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
  ///
  /// [excludeCategoryIds] (V2-M6) omits reserved/adjustment slices — the same
  /// exclusion the income/expense totals apply, so the donut never shows a
  /// "Penyesuaian" wedge. Default `const {}` keeps legacy callers identical.
  static Map<int, int> expenseByCategory(
    List<Transaction> txs, {
    Set<int> excludeCategoryIds = const {},
  }) {
    final byCategory = <int, int>{};
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      final categoryId = t.categoryId;
      if (categoryId == null) continue;
      if (excludeCategoryIds.contains(categoryId)) continue; // reserved slice
      byCategory[categoryId] = (byCategory[categoryId] ?? 0) + t.amount;
    }
    return byCategory;
  }
}
