part of 'recurring_review_cubit.dart';

/// State machine for the recurring review screen. `loaded` carries the pending
/// occurrences (ascending by due date); `empty` is the "nothing to confirm"
/// state (distinct from `error`).
@freezed
sealed class RecurringReviewState with _$RecurringReviewState {
  const factory RecurringReviewState.loading() = RecurringReviewLoading;

  const factory RecurringReviewState.loaded({
    required List<PendingOccurrence> pending,
  }) = RecurringReviewLoaded;

  const factory RecurringReviewState.empty() = RecurringReviewEmpty;

  const factory RecurringReviewState.error(Failure failure) =
      RecurringReviewError;
}
