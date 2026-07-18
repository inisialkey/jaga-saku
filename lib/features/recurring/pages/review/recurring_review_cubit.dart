import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/confirm_occurrence.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/get_due_occurrences.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/skip_occurrence.dart';

part 'recurring_review_state.dart';
part 'recurring_review_cubit.freezed.dart';

/// Drives the recurring review screen (V2-M5). Loads the projected pending
/// occurrences via [GetDueOccurrences] (a pure read — writes nothing), then
/// confirms (writes a real tx + advances the cursor), confirms all, or skips
/// (advances only). Each action re-projects, so a rule with 3 overdue leaves 2
/// after one confirm (the cursor moved exactly one step). The money-changed
/// broadcast lives behind the write seam now (V4-M1): the transaction + recurring
/// repos ping `TxChangeNotifier` on every successful write, so Home + Calendar +
/// the badge refresh — skip's `advanceCursor` pings too, dropping the badge even
/// though no tx was written. Every emit is guarded by [isClosed] (rule 5).
class RecurringReviewCubit extends Cubit<RecurringReviewState> {
  RecurringReviewCubit({
    required GetDueOccurrences getDueOccurrences,
    required ConfirmOccurrence confirmOccurrence,
    required SkipOccurrence skipOccurrence,
  }) : _getDueOccurrences = getDueOccurrences,
       _confirmOccurrence = confirmOccurrence,
       _skipOccurrence = skipOccurrence,
       super(const RecurringReviewState.loading());

  final GetDueOccurrences _getDueOccurrences;
  final ConfirmOccurrence _confirmOccurrence;
  final SkipOccurrence _skipOccurrence;

  Future<void> load() async {
    emit(const RecurringReviewState.loading());
    final result = await _getDueOccurrences(NoParams());
    if (isClosed) return;
    emit(
      result.fold(
        RecurringReviewState.error,
        (pending) => pending.isEmpty
            ? const RecurringReviewState.empty()
            : RecurringReviewState.loaded(pending: pending),
      ),
    );
  }

  Future<void> confirm(PendingOccurrence occurrence) async {
    // D3: ignore a tap while any write is already in flight, and flag `busy` so
    // the page disables the actions until the re-projection lands.
    final s = state;
    if (s is! RecurringReviewLoaded || s.busy) return;
    emit(s.copyWith(busy: true));
    final result = await _confirmOccurrence(occurrence);
    if (isClosed) return;
    final failure = result.getLeft().toNullable();
    if (failure != null) {
      emit(RecurringReviewState.error(failure));
      return;
    }
    await load();
  }

  // ponytail: each confirm fires 2 repo pings (saveTransaction + advanceCursor),
  // so confirmAll(N) broadcasts ≤2N and every live subscriber full-reloads per
  // ping — fine on local sqflite; add a trailing Timer coalesce in
  // TxChangeNotifier if it ever janks (V4-M1 D1).
  Future<void> confirmAll() async {
    final s = state;
    // D3: re-entrancy guard — a second Confirm-all mid-write is a no-op, so the
    // ≤60 real tx writes never double-fire.
    if (s is! RecurringReviewLoaded || s.busy) return;
    emit(s.copyWith(busy: true));
    // `s.pending` is globally ascending ⇒ per-rule ascending, so each rule's
    // last confirm lands its cursor past its last occurrence.
    for (final occurrence in s.pending) {
      await _confirmOccurrence(occurrence);
    }
    if (isClosed) return;
    await load();
  }

  Future<void> skip(PendingOccurrence occurrence) async {
    final s = state;
    if (s is! RecurringReviewLoaded || s.busy) return;
    emit(s.copyWith(busy: true));
    final result = await _skipOccurrence(occurrence);
    if (isClosed) return;
    final failure = result.getLeft().toNullable();
    if (failure != null) {
      emit(RecurringReviewState.error(failure));
      return;
    }
    await load();
  }
}
