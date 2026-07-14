part of 'recurring_review_cubit.dart';

/// State machine for the recurring review screen. `loaded` carries the pending
/// occurrences (ascending by due date); `empty` is the "nothing to confirm"
/// state (distinct from `error`).
@freezed
sealed class RecurringReviewState with _$RecurringReviewState {
  const factory RecurringReviewState.loading() = RecurringReviewLoading;

  const factory RecurringReviewState.loaded({
    required List<PendingOccurrence> pending,

    /// True while a confirm / skip / confirm-all write is in flight (D3): the
    /// page disables all three actions and shows a spinner, so a slow bulk
    /// commit can't be double-tapped into duplicate transactions.
    @Default(false) bool busy,
  }) = RecurringReviewLoaded;

  const factory RecurringReviewState.empty() = RecurringReviewEmpty;

  const factory RecurringReviewState.error(Failure failure) =
      RecurringReviewError;
}
