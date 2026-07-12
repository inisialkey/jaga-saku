import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/recurrence_schedule.dart';
import 'package:jaga_saku/features/recurring/domain/repositories/recurring_repository.dart';
import 'package:jaga_saku/features/templates/domain/template_to_transaction.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/save_transaction.dart';

/// Confirms one pending occurrence: writes a real, plain, editable transaction
/// at its TRUE due date (via M2's `templateToTransaction`), then advances the
/// cursor to the NEXT occurrence — `nextOccurrence(dueDate, …)`, NOT today, so a
/// 3-overdue rule leaves 2 pending after one confirm (C1). The cursor advances
/// ONLY after a successful write; a save `Left` leaves the occurrence pending.
///
/// The cubit pings `TxChangeNotifier` after a Right (matching
/// `home_cubit.applyFavorite`) — keeping this usecase off the core-service import.
class ConfirmOccurrence extends UseCase<Unit, PendingOccurrence> {
  ConfirmOccurrence(this._saveTransaction, this._repository);

  final SaveTransaction _saveTransaction;
  final RecurringRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(PendingOccurrence params) async {
    // Stamp `createdAt` at persist time (the pure helper is clock-free), like
    // `home_cubit.applyFavorite`.
    final tx = templateToTransaction(
      params.template,
      date: params.dueDate,
    ).copyWith(createdAt: DateTime.now().millisecondsSinceEpoch);

    final saved = await _saveTransaction(tx);
    final failure = saved.getLeft().toNullable();
    if (failure != null) return Left(failure);

    return _repository.advanceCursor(
      params.rule.id!,
      RecurrenceSchedule.nextOccurrence(
        params.dueDate,
        params.rule.freq,
        params.rule.interval,
        startDate: params.rule.startDate,
      ),
    );
  }
}
