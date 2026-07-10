part of 'home_cubit.dart';

/// View-model for the Home dashboard — everything the page renders, computed in
/// [HomeCubit.load] from the accounts + this-month transactions + recent list +
/// category/account lookups. All money fields are positive rupiah ints (the
/// sign is a display concern of [MoneyText]).
@freezed
abstract class HomeDashboard with _$HomeDashboard {
  const factory HomeDashboard({
    /// Σ balance of non-archived accounts (already tx-derived from M1/M2).
    required int totalBalance,

    /// This month's income / expense totals (transfers excluded from both).
    required int monthIncome,
    required int monthExpense,

    /// Today's expense total (the daily review).
    required int todaySpent,

    /// Today's expense sum for [PlannedStatus.unplanned] rows.
    required int todayUnplanned,

    /// Name of today's largest-expense category; null when nothing was spent.
    String? topCategoryName,

    /// Up to 5 most recent transactions, newest first.
    @Default(<Transaction>[]) List<Transaction> recent,

    /// id → Category / Account lookups used to resolve names on the tiles.
    @Default(<int, Category>{}) Map<int, Category> categoriesById,
    @Default(<int, Account>{}) Map<int, Account> accountsById,

    /// The most at-risk budget for the current month, or null when there are no
    /// budgets (the guard card then shows its empty state + a live CTA).
    BudgetGuardView? budgetGuard,
  }) = _HomeDashboard;

  const HomeDashboard._();

  /// True when the user has any expense recorded today (drives the daily-review
  /// zero-state copy).
  bool get hasSpentToday => todaySpent > 0;

  Category? categoryOf(Transaction t) =>
      t.categoryId == null ? null : categoriesById[t.categoryId];

  Account? accountOf(Transaction t) => accountsById[t.accountId];

  Account? toAccountOf(Transaction t) =>
      t.toAccountId == null ? null : accountsById[t.toAccountId];
}

/// Precomputed view-model for the Home Budget Guard card (plan §4): the most
/// at-risk budget's category + its [BudgetStatus] outputs, so the card stays a
/// dumb value-in widget (the money math lives in the cubit).
@freezed
abstract class BudgetGuardView with _$BudgetGuardView {
  const factory BudgetGuardView({
    required String categoryName,
    required int remaining,
    required int safeDaily,
    required double ratio,
    required BudgetStatusLevel level,
    String? categoryIcon,

    /// ARGB color of the category.
    int? categoryColor,
  }) = _BudgetGuardView;
}

/// Home dashboard state machine: `loaded` carries the computed [HomeDashboard].
/// First run (no accounts / transactions) is a zero-filled `loaded`, never an
/// `error`.
@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeInitial;

  const factory HomeState.loading() = HomeLoading;

  const factory HomeState.loaded(HomeDashboard dashboard) = HomeLoaded;

  const factory HomeState.error(Failure failure) = HomeError;
}
