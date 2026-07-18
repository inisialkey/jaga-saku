part of 'search_transaction_cubit.dart';

/// State machine for the Advanced Search screen. Every case carries the live
/// [SearchTransactionParams] so the search bar, filter sheet and active-filter
/// chip bar can read the current filter set uniformly (via the shared [params]
/// getter) regardless of the phase. The result count is derived from
/// [SearchResults.items] `.length` — no separate count field.
///
/// - [initial]  — the prompt (no query has been run for the current params).
/// - [loading]  — a query is in flight.
/// - [results]  — one or more matching transactions.
/// - [empty]    — the query ran but matched nothing.
/// - [failure]  — the query failed (DB fault → localized [Failure]).
@freezed
sealed class SearchTransactionState with _$SearchTransactionState {
  const factory SearchTransactionState.initial(SearchTransactionParams params) =
      SearchInitial;

  const factory SearchTransactionState.loading(SearchTransactionParams params) =
      SearchLoading;

  const factory SearchTransactionState.results(
    SearchTransactionParams params,
    List<Transaction> items,
  ) = SearchResults;

  const factory SearchTransactionState.empty(SearchTransactionParams params) =
      SearchEmpty;

  const factory SearchTransactionState.failure(
    SearchTransactionParams params,
    Failure failure,
  ) = SearchFailure;

  const SearchTransactionState._();

  /// The live filter set, whatever the phase.
  @override
  SearchTransactionParams get params => switch (this) {
    SearchInitial(:final params) => params,
    SearchLoading(:final params) => params,
    SearchResults(:final params) => params,
    SearchEmpty(:final params) => params,
    SearchFailure(:final params) => params,
  };
}
