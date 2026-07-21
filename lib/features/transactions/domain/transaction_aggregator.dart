import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// Pure aggregation over [Transaction] lists — **no Flutter, no DB** (rule 19,
/// mirrors the [BudgetStatus] / `insight_rules` precedent). The single home for
/// every Dart-side **report fold** Home, Insight, Money Story and Calendar
/// derive, plus the one **adjustment-exclusion rule** they all apply — so a new
/// report view reuses these instead of forking a copy.
///
/// **Bound to its exclusion set.** An instance carries the reserved/adjustment
/// category ids to skip, so every fold applies the rule with no per-call
/// argument to thread or forget. Build one with [TransactionAggregator.excluding]
/// from your categories; the folds then take only the transaction list. (The
/// rule used to be an opt-in `excludeCategoryIds` parameter defaulting to `{}` —
/// it was silently dropped from a fold twice, hence this shape: forgetting is
/// now unrepresentable.)
///
/// **Two regimes.** These report folds *exclude* reconcile adjustments (a
/// correction moves a balance, not a report); the SQL-side balance aggregates
/// (per-account balance, budget `spent`, `monthlyNetDeltas`) *include* them —
/// net worth is balance semantics. The include/exclude choice therefore lives
/// in the layer, not in a comment.
///
/// Every method is a deterministic transform of its input list. Scope (a month,
/// a single day, a custom range) lives in the caller — pass the already-filtered
/// list; the helper never looks at dates.
class TransactionAggregator {
  /// Binds the folds to a resolved id set. Prefer [TransactionAggregator.excluding],
  /// which resolves the set from your categories; this low-level ctor is for
  /// callers (and tests) that already hold the ids. `const {}` = no exclusion.
  const TransactionAggregator(this._excludeCategoryIds);

  /// Binds the folds to the [systemCategoryIds] of [categories] so every fold
  /// drops reconcile adjustments (a correction moves balance, not a report)
  /// without the caller threading the set — resolving the rule once, here,
  /// instead of at each report surface.
  factory TransactionAggregator.excluding(Iterable<Category> categories) =>
      TransactionAggregator(systemCategoryIds(categories));

  final Set<int> _excludeCategoryIds;

  /// A reserved/adjustment row this instance drops from every fold.
  bool _isExcluded(Transaction t) =>
      t.categoryId != null && _excludeCategoryIds.contains(t.categoryId);

  /// [txs] with reserved/adjustment rows removed — the row-level form of the
  /// exclusion the folds apply, for callers that need the filtered *list* rather
  /// than a total (e.g. the calendar's event dots, which must match the day
  /// summary those folds produce).
  List<Transaction> withoutAdjustments(List<Transaction> txs) =>
      txs.where((t) => !_isExcluded(t)).toList();

  /// The reserved/adjustment category ids the report folds skip — the single
  /// home of the exclusion rule. Equivalent today to
  /// `system_key ∈ TransactionSource.adjustmentSystemKeys` since the only system
  /// categories are the v6 "Penyesuaian" pair. Public + static so
  /// [TransactionAggregator.excluding] and its tests can resolve it directly.
  static Set<int> systemCategoryIds(Iterable<Category> categories) => {
    for (final c in categories)
      if (c.isSystem && c.id != null) c.id!,
  };

  /// Sums income and expense amounts, **excluding transfers** (internal moves
  /// belong to neither side) and this instance's adjustment categories. Amounts
  /// are positive rupiah ints whose sign is implied by [Transaction.type], so
  /// both totals accumulate `+ t.amount`.
  ({int income, int expense}) incomeExpense(List<Transaction> txs) {
    var income = 0;
    var expense = 0;
    for (final t in txs) {
      if (_isExcluded(t)) continue; // an adjustment moves balance, not reports
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

  /// Sum of expense amounts per (non-null) category id. Non-expense rows,
  /// expenses with a null [Transaction.categoryId], and this instance's reserved
  /// slices are skipped, so the map's keys are exactly the real expense
  /// categories present in [txs] (the donut never shows a "Penyesuaian" wedge).
  Map<int, int> expenseByCategory(List<Transaction> txs) {
    final byCategory = <int, int>{};
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      final categoryId = t.categoryId;
      if (categoryId == null) continue;
      if (_isExcluded(t)) continue; // reserved slice
      byCategory[categoryId] = (byCategory[categoryId] ?? 0) + t.amount;
    }
    return byCategory;
  }

  /// Today's review: total expense [spent] and the [unplanned] subset. Null-category
  /// expenses count toward [spent] (they are not adjustments); transfers/income skip.
  ({int spent, int unplanned}) spentAndUnplanned(List<Transaction> txs) {
    var spent = 0;
    var unplanned = 0;
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      if (_isExcluded(t)) continue;
      spent += t.amount;
      if (t.plannedStatus == PlannedStatus.unplanned) unplanned += t.amount;
    }
    return (spent: spent, unplanned: unplanned);
  }

  /// Planned vs. unplanned over the typed expense subset (null-status rows
  /// excluded — the pcts are of this typed subset, computed caller-side).
  ({int planned, int unplanned}) plannedSplit(List<Transaction> txs) {
    var planned = 0;
    var unplanned = 0;
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      if (_isExcluded(t)) continue;
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
  Map<SpendingType, int> needVsWant(List<Transaction> txs) {
    final byType = <SpendingType, int>{};
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      if (_isExcluded(t)) continue;
      final type = t.spendingType;
      if (type == null) continue;
      byType[type] = (byType[type] ?? 0) + t.amount;
    }
    return byType;
  }

  /// The single largest real expense (first encountered wins a tie).
  Transaction? biggestExpense(List<Transaction> txs) {
    Transaction? biggest;
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      if (_isExcluded(t)) continue;
      if (biggest == null || t.amount > biggest.amount) biggest = t;
    }
    return biggest;
  }
}
