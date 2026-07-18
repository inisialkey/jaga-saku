part of 'account_list_cubit.dart';

/// State machine for the accounts list. `loaded` carries the full account set
/// (including archived); the page filters by [AccountListLoaded.showArchived].
@freezed
sealed class AccountListState with _$AccountListState {
  const factory AccountListState.initial() = AccountListInitial;

  const factory AccountListState.loading() = AccountListLoading;

  const factory AccountListState.loaded({
    required List<Account> items,
    @Default(false) bool showArchived,
  }) = AccountListLoaded;

  const factory AccountListState.error(Failure failure) = AccountListError;
}

/// Total-asset fold over the loaded account set, kept out of the widget (rule 5)
/// and off the transactions module (D3 — accounts carry no adjustment-exclusion
/// semantics; balances include reconcile corrections by design).
extension AccountListTotals on AccountListState {
  /// Σ balance over non-archived accounts; 0 for any non-loaded state.
  int get totalBalance => switch (this) {
    AccountListLoaded(:final items) =>
      items.where((a) => !a.archived).fold<int>(0, (sum, a) => sum + a.balance),
    _ => 0,
  };
}
