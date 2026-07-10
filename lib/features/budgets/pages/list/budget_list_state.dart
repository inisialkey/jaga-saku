part of 'budget_list_cubit.dart';

/// State machine for the Budget screen. `loaded` carries the viewed [month], its
/// [budgets] (each with a derived spent) and a category lookup the cards use to
/// resolve names / icons.
@freezed
sealed class BudgetListState with _$BudgetListState {
  const factory BudgetListState.initial() = BudgetListInitial;

  const factory BudgetListState.loading() = BudgetListLoading;

  const factory BudgetListState.loaded({
    required DateTime month,
    required List<Budget> budgets,
    @Default(<int, Category>{}) Map<int, Category> categoriesById,
  }) = BudgetListLoaded;

  const factory BudgetListState.error(Failure failure) = BudgetListError;
}
