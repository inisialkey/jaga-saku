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
