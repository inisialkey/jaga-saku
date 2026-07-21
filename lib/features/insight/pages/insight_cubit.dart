import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/resources/category_colors.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_cycle.dart';
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
/// Insight live, and to [AppSettingsCubit]'s own stream so a budget cycle
/// start-day change re-keys the budget lookup (same wiring as `home/`); both
/// subscriptions are cancelled in [close] (rule 7) and every emit is guarded by
/// [isClosed] (rule 5).
class InsightCubit extends Cubit<InsightState> {
  InsightCubit({
    required GetTransactionsByMonth getTransactionsByMonth,
    required GetCategories getCategories,
    required GetBudgetsForPeriod getBudgetsForPeriod,
    required TxChangeNotifier txChangeNotifier,
    required AppSettingsCubit appSettings,
  }) : _getTransactionsByMonth = getTransactionsByMonth,
       _getCategories = getCategories,
       _getBudgetsForPeriod = getBudgetsForPeriod,
       _txChanges = txChangeNotifier,
       _appSettings = appSettings,
       super(const InsightState.initial()) {
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    // Any add / edit / delete or budget write pings — recompute the same month.
    // Cancelled in [close] (rule 7). Never pings itself (no refresh loop).
    _txSub = _txChanges.changes.listen((_) => load(_focusedMonth));
    // The budget lookup is keyed off the cycle window, so reload when the global
    // start-day changes — off the cubit's own stream, not the tx bus (V4-M2).
    _cycleSub = _appSettings.onCycleStartDayChanged(() => load(_focusedMonth));
  }

  final GetTransactionsByMonth _getTransactionsByMonth;
  final GetCategories _getCategories;
  final GetBudgetsForPeriod _getBudgetsForPeriod;
  final TxChangeNotifier _txChanges;
  final AppSettingsCubit _appSettings;
  late final StreamSubscription<void> _txSub;
  late final StreamSubscription<AppSettingsState> _cycleSub;

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
    // A budget is keyed by its CYCLE-START month, not the calendar month — at a
    // custom start-day the two differ, so keying off `_focusedMonth` raw asked
    // for the next cycle (usually not created yet) and the budget card silently
    // vanished for the first `startDay - 1` days of every cycle. Mirrors the
    // Home guard's derivation.
    final cycle = BudgetCycle.range(
      startDay: _appSettings.state.budgetCycleStartDay,
      reference: _focusedMonth,
    );
    final budgetsResult = await _getBudgetsForPeriod(
      periodKey(DateTime.fromMillisecondsSinceEpoch(cycle.start)),
    );
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

    // V2-M6: every report fold skips reserved/adjustment rows (a reconcile
    // correction moves balance, not income/expense). Bound once so no fold —
    // here or in the private helpers below — can forget it.
    final agg = TransactionAggregator.excluding(categories);

    // ── Overview ──────────────────────────────────────────────────────────
    final (:income, :expense) = agg.incomeExpense(currentTx);

    // ── Expense by category (current month) ───────────────────────────────
    final currentByCategory = agg.expenseByCategory(currentTx);
    final sorted = currentByCategory.entries.map((e) {
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
    // A category with no stored color gets a distinct swatch by sorted position
    // so adjacent donut wedges never collide (single source of truth — the
    // legend reads slice.color, so it matches the donut automatically). Ceiling:
    // >10 colorless categories in one month repeat a swatch — acceptable.
    final slices = [
      for (final (i, slice) in sorted.indexed)
        slice.copyWith(
          color:
              slice.color ??
              CategoryColors.swatches[i % CategoryColors.swatches.length],
        ),
    ];

    // ── Planned vs. unplanned (typed subset) ──────────────────────────────
    final plannedSplit = _plannedSplit(agg, currentTx);

    // ── Need vs. want (typed subset) ──────────────────────────────────────
    final needVsWant = spendingSlicesFrom(agg.needVsWant(currentTx));

    // ── Spending insights (pure engine) ───────────────────────────────────
    final insights = _computeInsights(
      agg: agg,
      budgets: budgets,
      categoriesById: categoriesById,
      currentByCategory: currentByCategory,
      previousTx: previousTx,
      currentUnplanned: plannedSplit.unplanned,
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

  /// Shapes [TransactionAggregator.plannedSplit] into the view type — the fold
  /// is delegated; only the 0..1 pcts (÷0-guarded) are computed here.
  PlannedSplit _plannedSplit(TransactionAggregator agg, List<Transaction> txs) {
    final (:planned, :unplanned) = agg.plannedSplit(txs);
    final total = planned + unplanned;
    return PlannedSplit(
      planned: planned,
      unplanned: unplanned,
      plannedPct: total > 0 ? planned / total : 0,
      unplannedPct: total > 0 ? unplanned / total : 0,
    );
  }

  /// Prepares the pure-engine inputs (budget gauges via [BudgetStatus], the
  /// per-category month-over-month trends and last month's unplanned total) and
  /// runs [computeInsights].
  List<InsightItem> _computeInsights({
    required TransactionAggregator agg,
    required List<Budget> budgets,
    required Map<int, Category> categoriesById,
    required Map<int, int> currentByCategory,
    required List<Transaction> previousTx,
    required int currentUnplanned,
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
        periodStart: b.periodStart,
        periodEnd: b.periodEnd,
      );
      gauges.add(BudgetGauge(categoryName: name, percent: status.percent));
    }

    // The month-over-month trend fold — a last-month adjustment must not
    // surface as a category trend; the bound `agg` guarantees it.
    final previousByCategory = agg.expenseByCategory(previousTx);
    final trends = <CategoryTrend>[
      for (final id in {...currentByCategory.keys, ...previousByCategory.keys})
        CategoryTrend(
          categoryName: categoriesById[id]?.name ?? '',
          current: currentByCategory[id] ?? 0,
          previous: previousByCategory[id] ?? 0,
        ),
    ];

    final previousUnplanned = agg.plannedSplit(previousTx).unplanned;

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
    _cycleSub.cancel();
    return super.close();
  }
}
