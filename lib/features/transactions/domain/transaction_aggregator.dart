import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// Pure aggregation over [Transaction] lists — **no Flutter, no DB** (rule 19,
/// mirrors the [BudgetStatus] / `insight_rules` precedent). The single home for
/// every Dart-side **report fold** Home, Insight, Money Story and Calendar
/// derive, plus the one **adjustment-exclusion rule** ([systemCategoryIds]) they
/// all apply — so a new report view reuses these instead of forking a copy.
///
/// **Two regimes.** These report folds *exclude* reconcile adjustments (a
/// correction moves a balance, not a report) via [systemCategoryIds]; the
/// SQL-side balance aggregates (per-account balance, budget `spent`,
/// `monthlyNetDeltas`) *include* them — net worth is balance semantics. The
/// include/exclude choice therefore lives in the layer, not in a comment.
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

  /// The reserved/adjustment category ids the report folds must skip — the single
  /// home of the exclusion rule (a reconcile correction moves balance, not
  /// reports). Equivalent today to `system_key ∈ TransactionSource.adjustmentSystemKeys`
  /// since the only system categories are the v6 "Penyesuaian" pair.
  static Set<int> systemCategoryIds(Iterable<Category> categories) => {
    for (final c in categories)
      if (c.isSystem && c.id != null) c.id!,
  };

  /// Today's review: total expense [spent] and the [unplanned] subset. Null-category
  /// expenses count toward [spent] (they are not adjustments); transfers/income skip.
  static ({int spent, int unplanned}) spentAndUnplanned(
    List<Transaction> txs, {
    Set<int> excludeCategoryIds = const {},
  }) {
    var spent = 0;
    var unplanned = 0;
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      if (t.categoryId != null && excludeCategoryIds.contains(t.categoryId)) {
        continue;
      }
      spent += t.amount;
      if (t.plannedStatus == PlannedStatus.unplanned) unplanned += t.amount;
    }
    return (spent: spent, unplanned: unplanned);
  }

  /// Planned vs. unplanned over the typed expense subset (null-status rows
  /// excluded — the pcts are of this typed subset, computed caller-side).
  static ({int planned, int unplanned}) plannedSplit(
    List<Transaction> txs, {
    Set<int> excludeCategoryIds = const {},
  }) {
    var planned = 0;
    var unplanned = 0;
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      if (t.categoryId != null && excludeCategoryIds.contains(t.categoryId)) {
        continue;
      }
      switch (t.plannedStatus) {
        case PlannedStatus.planned:
          planned += t.amount;
        case PlannedStatus.unplanned:
          unplanned += t.amount;
        case null:
          break;
      }
    }
    return (planned: planned, unplanned: unplanned);
  }

  /// Need/want/etc. sums over the typed expense subset (null-type rows excluded).
  static Map<SpendingType, int> needVsWant(
    List<Transaction> txs, {
    Set<int> excludeCategoryIds = const {},
  }) {
    final byType = <SpendingType, int>{};
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      if (t.categoryId != null && excludeCategoryIds.contains(t.categoryId)) {
        continue;
      }
      final type = t.spendingType;
      if (type == null) continue;
      byType[type] = (byType[type] ?? 0) + t.amount;
    }
    return byType;
  }

  /// The single largest real expense (first encountered wins a tie).
  static Transaction? biggestExpense(
    List<Transaction> txs, {
    Set<int> excludeCategoryIds = const {},
  }) {
    Transaction? biggest;
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      if (t.categoryId != null && excludeCategoryIds.contains(t.categoryId)) {
        continue;
      }
      if (biggest == null || t.amount > biggest.amount) biggest = t;
    }
    return biggest;
  }
}
