import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/delete_budget.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/get_budgets_for_period.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';

part 'budget_list_state.dart';
part 'budget_list_cubit.freezed.dart';

/// Drives the Budget screen: loads the selected month's budgets (each with its
/// derived spent) + the expense categories that name them, moves between months,
/// and deletes. Subscribes to [TxChangeNotifier] so spent refreshes live when a
/// transaction changes anywhere; its own delete also pings the bus so the Home
/// guard recomputes (plan §6). The subscription is cancelled in [close] (rule 7)
/// and every emit is guarded by [isClosed] (rule 5).
class BudgetListCubit extends Cubit<BudgetListState> {
  BudgetListCubit({
    required GetBudgetsForPeriod getBudgetsForPeriod,
    required DeleteBudget deleteBudget,
    required GetCategories getCategories,
    required TxChangeNotifier txChangeNotifier,
  }) : _getBudgetsForPeriod = getBudgetsForPeriod,
       _deleteBudget = deleteBudget,
       _getCategories = getCategories,
       _txChanges = txChangeNotifier,
       super(const BudgetListState.initial()) {
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _txSub = _txChanges.changes.listen((_) => load());
  }

  final GetBudgetsForPeriod _getBudgetsForPeriod;
  final DeleteBudget _deleteBudget;
  final GetCategories _getCategories;
  final TxChangeNotifier _txChanges;
  late final StreamSubscription<void> _txSub;

  /// First-of-month for the currently-viewed period.
  late DateTime _month;

  /// Loads the current [_month]'s budgets + expense categories. Keeps the loaded
  /// list on screen while reloading (no loading flash on a month change or a
  /// notifier ping); only the first load shows the skeleton.
  Future<void> load() async {
    if (state is! BudgetListLoaded) emit(const BudgetListState.loading());
    final budgetsResult = await _getBudgetsForPeriod(periodKey(_month));
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
        month: _month,
        budgets: budgets,
        categoriesById: {
          for (final c in cats)
            if (c.id != null) c.id!: c,
        },
      ),
    );
  }

  void previousMonth() {
    _month = DateTime(_month.year, _month.month - 1);
    load();
  }

  void nextMonth() {
    _month = DateTime(_month.year, _month.month + 1);
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
