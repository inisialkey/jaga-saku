import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/get_budgets_for_period.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/save_budget.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';

part 'budget_form_state.dart';
part 'budget_form_cubit.freezed.dart';

/// Backs the create/edit budget form. Loads expense categories for the picker,
/// seeds fields from [initial] when editing (else defaults to the list's
/// [month]), and on [submit] resolves a duplicate `(category, period)` to an
/// update — so creating a budget for a category that already has one that month
/// edits it instead of hitting the UNIQUE constraint (plan §3). A successful
/// save pings [TxChangeNotifier] so derived-money views refresh (plan §6). Every
/// emit is guarded by [isClosed] (rule 5).
class BudgetFormCubit extends Cubit<BudgetFormState> {
  BudgetFormCubit({
    required SaveBudget saveBudget,
    required GetCategories getCategories,
    required GetBudgetsForPeriod getBudgetsForPeriod,
    required TxChangeNotifier txChangeNotifier,
    Budget? initial,
    DateTime? month,
  }) : _saveBudget = saveBudget,
       _getCategories = getCategories,
       _getBudgetsForPeriod = getBudgetsForPeriod,
       _txChanges = txChangeNotifier,
       _initial = initial,
       super(
         initial == null
             ? BudgetFormState(month: month ?? _firstOfCurrentMonth())
             : BudgetFormState(
                 month: _monthOfPeriod(initial.period),
                 categoryId: initial.categoryId,
                 limitAmount: initial.limitAmount,
                 isEditing: true,
               ),
       );

  final SaveBudget _saveBudget;
  final GetCategories _getCategories;
  final GetBudgetsForPeriod _getBudgetsForPeriod;
  final TxChangeNotifier _txChanges;
  final Budget? _initial;

  /// Loads active expense categories for the picker. A read failure leaves the
  /// picker empty rather than blocking the form.
  Future<void> load() async {
    final result = await _getCategories(CategoryType.expense);
    if (isClosed) return;
    emit(
      state.copyWith(
        categories: result.getRight().toNullable() ?? const <Category>[],
      ),
    );
  }

  void categoryChanged(int categoryId) =>
      emit(state.copyWith(categoryId: categoryId));

  void limitChanged(int limitAmount) =>
      emit(state.copyWith(limitAmount: limitAmount));

  void previousMonth() => emit(
    state.copyWith(month: DateTime(state.month.year, state.month.month - 1)),
  );

  void nextMonth() => emit(
    state.copyWith(month: DateTime(state.month.year, state.month.month + 1)),
  );

  Future<void> submit() async {
    if (!state.isValid || state.isSaving) return;
    emit(state.copyWith(status: BudgetFormStatus.saving));

    final period = periodKey(state.month);
    var id = _initial?.id;
    var createdAt = _initial?.createdAt;
    // Creating for a (category, period) that already has a budget → update it
    // (avoids the UNIQUE(category, period) conflict), threading BOTH its id and
    // created_at so the update preserves the row's place in the created_at-
    // ordered list instead of bumping it to "now". Editing keeps its own id.
    if (id == null) {
      final existing = await _getBudgetsForPeriod(period);
      if (isClosed) return;
      final match = _existingFor(
        existing.getRight().toNullable(),
        state.categoryId!,
        period,
      );
      id = match?.id;
      createdAt = match?.createdAt;
    }

    final budget = Budget(
      id: id,
      categoryId: state.categoryId!,
      period: period,
      limitAmount: state.limitAmount,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
    );

    final result = await _saveBudget(budget);
    if (isClosed) return;
    if (result.isRight()) _txChanges.ping();
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: BudgetFormStatus.failure, error: failure),
        (_) => state.copyWith(status: BudgetFormStatus.success),
      ),
    );
  }

  /// The existing budget for [categoryId] in [period], or null. Returned whole
  /// (not just its id) so a create-over-existing update preserves the original
  /// row's id AND created_at.
  Budget? _existingFor(List<Budget>? budgets, int categoryId, String period) {
    if (budgets == null) return null;
    for (final b in budgets) {
      if (b.categoryId == categoryId && b.period == period) return b;
    }
    return null;
  }

  static DateTime _firstOfCurrentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  static DateTime _monthOfPeriod(String period) {
    final parts = period.split('-');
    return DateTime(int.parse(parts[0]), int.parse(parts[1]));
  }
}
