import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/get_budgets_for_period.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/insight/pages/insight_rules.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/transaction_aggregator.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_month.dart';

part 'insight_state.dart';
part 'insight_cubit.freezed.dart';

/// Presentation-only orchestrator for the Insight tab (M5) — like `home/` /
/// `calendar/` it owns no domain / data layer. It composes the focused month's
/// transactions (+ the previous month for month-over-month), the categories and
/// the budgets (all through DI) into an [InsightReport] computed in Dart, with
/// the rule-based cards delegated to the pure [computeInsights]. Subscribes to
/// [TxChangeNotifier] so any transaction / budget change anywhere refreshes
/// Insight live; the subscription is cancelled in [close] (rule 7) and every
/// emit is guarded by [isClosed] (rule 5).
class InsightCubit extends Cubit<InsightState> {
  InsightCubit({
    required GetTransactionsByMonth getTransactionsByMonth,
    required GetCategories getCategories,
    required GetBudgetsForPeriod getBudgetsForPeriod,
    required TxChangeNotifier txChangeNotifier,
  }) : _getTransactionsByMonth = getTransactionsByMonth,
       _getCategories = getCategories,
       _getBudgetsForPeriod = getBudgetsForPeriod,
       _txChanges = txChangeNotifier,
       super(const InsightState.initial()) {
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    // Any add / edit / delete or budget write pings — recompute the same month.
    // Cancelled in [close] (rule 7). Never pings itself (no refresh loop).
    _txSub = _txChanges.changes.listen((_) => load(_focusedMonth));
  }

  final GetTransactionsByMonth _getTransactionsByMonth;
  final GetCategories _getCategories;
  final GetBudgetsForPeriod _getBudgetsForPeriod;
  final TxChangeNotifier _txChanges;
  late final StreamSubscription<void> _txSub;

  /// First-of-month for the currently-viewed period.
  late DateTime _focusedMonth;
  DateTime get focusedMonth => _focusedMonth;

  /// Loads the focused + previous month's transactions, the categories and the
  /// budgets, then folds them into an [InsightReport]. Emits [InsightLoading]
  /// only on the first load; a month change or notifier ping keeps the current
  /// report on screen (no loading flash). Any usecase `Left` → [InsightError];
  /// an empty month is a valid zero-report (each section shows its own empty
  /// state), never an error.
  Future<void> load(DateTime month) async {
    _focusedMonth = DateTime(month.year, month.month);
    if (state is! InsightLoaded) emit(const InsightState.loading());

    final prevMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    final currentResult = await _getTransactionsByMonth(_focusedMonth);
    final previousResult = await _getTransactionsByMonth(prevMonth);
    final expenseCatsResult = await _getCategories(CategoryType.expense);
    final incomeCatsResult = await _getCategories(CategoryType.income);
    final budgetsResult = await _getBudgetsForPeriod(periodKey(_focusedMonth));
    if (isClosed) return;

    final failure =
        currentResult.getLeft().toNullable() ??
        previousResult.getLeft().toNullable() ??
        expenseCatsResult.getLeft().toNullable() ??
        incomeCatsResult.getLeft().toNullable() ??
        budgetsResult.getLeft().toNullable();
    if (failure != null) {
      emit(InsightState.error(failure));
      return;
    }

    final currentTx =
        currentResult.getRight().toNullable() ?? const <Transaction>[];
    final previousTx =
        previousResult.getRight().toNullable() ?? const <Transaction>[];
    final categories = <Category>[
      ...expenseCatsResult.getRight().toNullable() ?? const <Category>[],
      ...incomeCatsResult.getRight().toNullable() ?? const <Category>[],
    ];
    final budgets = budgetsResult.getRight().toNullable() ?? const <Budget>[];

    emit(
      InsightState.loaded(
        _buildReport(
          currentTx: currentTx,
          previousTx: previousTx,
          categories: categories,
          budgets: budgets,
        ),
      ),
    );
  }

  /// Reloads the current month — the error-retry action.
  Future<void> reload() => load(_focusedMonth);

  void previousMonth() =>
      load(DateTime(_focusedMonth.year, _focusedMonth.month - 1));

  void nextMonth() =>
      load(DateTime(_focusedMonth.year, _focusedMonth.month + 1));

  /// Folds the two months into the report. All aggregation is over EXPENSE rows
  /// only (transfers never enter income/expense; the typed splits further
  /// exclude rows whose `plannedStatus` / `spendingType` is null — the pcts are
  /// of the typed subset, not of all expense).
  InsightReport _buildReport({
    required List<Transaction> currentTx,
    required List<Transaction> previousTx,
    required List<Category> categories,
    required List<Budget> budgets,
  }) {
    final categoriesById = <int, Category>{
      for (final c in categories)
        if (c.id != null) c.id!: c,
    };

    // V2-M6: reserved/adjustment category ids every report fold must skip (a
    // reconcile correction moves balance, not income/expense).
    final excludeCategoryIds = <int>{
      for (final c in categories)
        if (c.isSystem && c.id != null) c.id!,
    };

    // ── Overview ──────────────────────────────────────────────────────────
    final (:income, :expense) = TransactionAggregator.incomeExpense(
      currentTx,
      excludeCategoryIds: excludeCategoryIds,
    );

    // ── Expense by category (current month) ───────────────────────────────
    final currentByCategory = TransactionAggregator.expenseByCategory(
      currentTx,
      excludeCategoryIds: excludeCategoryIds,
    );
    final slices = currentByCategory.entries.map((e) {
      final category = categoriesById[e.key];
      return CategorySlice(
        categoryId: e.key,
        name: category?.name ?? '',
        color: category?.color,
        amount: e.value,
        // Denominator is total expense; expenses always carry a category
        // (the form requires one), so the wedges sum to ~100%.
        pct: expense > 0 ? e.value / expense : 0,
      );
    }).toList()..sort((a, b) => b.amount.compareTo(a.amount));

    // ── Planned vs. unplanned (typed subset) ──────────────────────────────
    final plannedSplit = _plannedSplit(currentTx);

    // ── Need vs. want (typed subset) ──────────────────────────────────────
    final needVsWant = _needVsWant(currentTx);

    // ── Spending insights (pure engine) ───────────────────────────────────
    final insights = _computeInsights(
      budgets: budgets,
      categoriesById: categoriesById,
      currentByCategory: currentByCategory,
      previousTx: previousTx,
      currentUnplanned: plannedSplit.unplanned,
      excludeCategoryIds: excludeCategoryIds,
    );

    return InsightReport(
      month: _focusedMonth,
      income: income,
      expense: expense,
      saved: income - expense,
      expenseByCategory: slices,
      plannedVsUnplanned: plannedSplit,
      needVsWant: needVsWant,
      insights: insights,
      categoriesById: categoriesById,
    );
  }

  PlannedSplit _plannedSplit(List<Transaction> txs) {
    var planned = 0;
    var unplanned = 0;
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      switch (t.plannedStatus) {
        case PlannedStatus.planned:
          planned += t.amount;
        case PlannedStatus.unplanned:
          unplanned += t.amount;
        case null:
          break; // excluded from the split
      }
    }
    final total = planned + unplanned;
    return PlannedSplit(
      planned: planned,
      unplanned: unplanned,
      plannedPct: total > 0 ? planned / total : 0,
      unplannedPct: total > 0 ? unplanned / total : 0,
    );
  }

  Map<SpendingType, SpendingSlice> _needVsWant(List<Transaction> txs) {
    final byType = <SpendingType, int>{};
    for (final t in txs) {
      if (t.type != TransactionType.expense) continue;
      final type = t.spendingType;
      if (type == null) continue; // excluded from the split
      byType[type] = (byType[type] ?? 0) + t.amount;
    }
    final total = byType.values.fold(0, (sum, v) => sum + v);
    return {
      for (final e in byType.entries)
        e.key: SpendingSlice(
          amount: e.value,
          pct: total > 0 ? e.value / total : 0,
        ),
    };
  }

  /// Prepares the pure-engine inputs (budget gauges via [BudgetStatus], the
  /// per-category month-over-month trends and last month's unplanned total) and
  /// runs [computeInsights].
  List<InsightItem> _computeInsights({
    required List<Budget> budgets,
    required Map<int, Category> categoriesById,
    required Map<int, int> currentByCategory,
    required List<Transaction> previousTx,
    required int currentUnplanned,
    required Set<int> excludeCategoryIds,
  }) {
    final now = DateTime.now();
    final gauges = <BudgetGauge>[];
    for (final b in budgets) {
      final name = categoriesById[b.categoryId]?.name ?? '';
      if (name.isEmpty)
        continue; // ponytail: skip a budget with no resolvable category
      final status = BudgetStatus.compute(
        limitAmount: b.limitAmount,
        spent: b.spent,
        now: now,
        period: b.period,
      );
      gauges.add(BudgetGauge(categoryName: name, percent: status.percent));
    }

    // C2: the month-over-month trend fold the doc missed — a last-month
    // adjustment must not surface as a category trend.
    final previousByCategory = TransactionAggregator.expenseByCategory(
      previousTx,
      excludeCategoryIds: excludeCategoryIds,
    );
    final trends = <CategoryTrend>[
      for (final id in {...currentByCategory.keys, ...previousByCategory.keys})
        CategoryTrend(
          categoryName: categoriesById[id]?.name ?? '',
          current: currentByCategory[id] ?? 0,
          previous: previousByCategory[id] ?? 0,
        ),
    ];

    var previousUnplanned = 0;
    for (final t in previousTx) {
      if (t.type == TransactionType.expense &&
          t.plannedStatus == PlannedStatus.unplanned) {
        previousUnplanned += t.amount;
      }
    }

    return computeInsights(
      budgets: gauges,
      categoryTrends: trends,
      currentUnplanned: currentUnplanned,
      previousUnplanned: previousUnplanned,
    );
  }

  @override
  Future<void> close() {
    _txSub.cancel();
    return super.close();
  }
}
