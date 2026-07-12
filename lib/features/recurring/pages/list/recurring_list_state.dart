part of 'recurring_list_cubit.dart';

/// State machine for the recurring manage list. `loaded` carries the rules
/// (each with its owned template joined), ordered by `next_due`.
@freezed
sealed class RecurringListState with _$RecurringListState {
  const factory RecurringListState.initial() = RecurringListInitial;

  const factory RecurringListState.loading() = RecurringListLoading;

  const factory RecurringListState.loaded({
    required List<RecurringRule> rules,
  }) = RecurringListLoaded;

  const factory RecurringListState.error(Failure failure) = RecurringListError;
}
