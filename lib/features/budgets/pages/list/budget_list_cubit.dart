import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_cycle.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/delete_budget.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/get_budgets_for_period.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';

part 'budget_list_state.dart';
part 'budget_list_cubit.freezed.dart';

/// Drives the Budget screen: loads the selected cycle's budgets (each with its
/// derived spent) + the expense categories that name them, moves between cycles,
/// and deletes. The cycle window is derived from the global start-day in
/// [AppSettingsCubit] (V2-M1) — at start-day 1 it is the calendar month.
/// Subscribes to [TxChangeNotifier] so spent refreshes live when a transaction
/// OR the start-day changes anywhere; its own delete also pings the bus so the
/// Home guard recomputes (plan §6). The subscription is cancelled in [close]
/// (rule 7) and every emit is guarded by [isClosed] (rule 5).
class BudgetListCubit extends Cubit<BudgetListState> {
  BudgetListCubit({
    required GetBudgetsForPeriod getBudgetsForPeriod,
    required DeleteBudget deleteBudget,
    required GetCategories getCategories,
    required TxChangeNotifier txChangeNotifier,
    required AppSettingsCubit appSettings,
  }) : _getBudgetsForPeriod = getBudgetsForPeriod,
       _deleteBudget = deleteBudget,
       _getCategories = getCategories,
       _txChanges = txChangeNotifier,
       _appSettings = appSettings,
       super(const BudgetListState.initial()) {
    _reference = DateTime.now();
    _txSub = _txChanges.changes.listen((_) => load());
  }

  final GetBudgetsForPeriod _getBudgetsForPeriod;
  final DeleteBudget _deleteBudget;
  final GetCategories _getCategories;
  final TxChangeNotifier _txChanges;
  final AppSettingsCubit _appSettings;
  late final StreamSubscription<void> _txSub;

  /// A moment inside the currently-viewed cycle; the cycle window is recomputed
  /// from it + the live start-day on every [load] (so a start-day change picks a
  /// new window for the same reference).
  late DateTime _reference;

  int get _startDay => _appSettings.state.budgetCycleStartDay;

  /// Loads the current cycle's budgets + expense categories. Keeps the loaded
  /// list on screen while reloading (no loading flash on a cycle change or a
  /// notifier ping); only the first load shows the skeleton.
  Future<void> load() async {
    if (state is! BudgetListLoaded) emit(const BudgetListState.loading());
    final cycle = BudgetCycle.range(startDay: _startDay, reference: _reference);
    final period = periodKey(DateTime.fromMillisecondsSinceEpoch(cycle.start));
    final budgetsResult = await _getBudgetsForPeriod(period);
    final catsResult = await _getCategories(CategoryType.expense);
    if (isClosed) return;

    final failure =
        budgetsResult.getLeft().toNullable() ??
        catsResult.getLeft().toNullable();
    if (failure != null) {
      emit(BudgetListState.error(failure));
      return;
    }

    final budgets = budgetsResult.getRight().toNullable() ?? const <Budget>[];
    final cats = catsResult.getRight().toNullable() ?? const <Category>[];
    emit(
      BudgetListState.loaded(
        cycleStart: cycle.start,
        cycleEnd: cycle.end,
        budgets: budgets,
        categoriesById: {
          for (final c in cats)
            if (c.id != null) c.id!: c,
        },
      ),
    );
  }

  void previousCycle() {
    final prev = BudgetCycle.previous(
      startDay: _startDay,
      reference: _reference,
    );
    _reference = DateTime.fromMillisecondsSinceEpoch(prev.start);
    load();
  }

  void nextCycle() {
    final next = BudgetCycle.next(startDay: _startDay, reference: _reference);
    _reference = DateTime.fromMillisecondsSinceEpoch(next.start);
    load();
  }

  Future<void> delete(int id) async {
    final result = await _deleteBudget(id);
    if (isClosed) return;
    final failure = result.getLeft().toNullable();
    if (failure != null) {
      emit(BudgetListState.error(failure));
      return;
    }
    // A budget change is a derived-money-view change: ping so the Home guard
    // recomputes; then reload this list.
    _txChanges.ping();
    await load();
  }

  @override
  Future<void> close() {
    _txSub.cancel();
    return super.close();
  }
}
