import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/recurrence_schedule.dart';
import 'package:jaga_saku/features/recurring/domain/repositories/recurring_repository.dart';

/// Skips one pending occurrence: advances the cursor to the next occurrence
/// (`nextOccurrence(dueDate, …)`, NOT today) WITHOUT writing a transaction. The
/// recurring repo's `advanceCursor` pings `TxChangeNotifier` (V4-M1), so the
/// Home badge drops even though no tx was written.
class SkipOccurrence extends UseCase<Unit, PendingOccurrence> {
  SkipOccurrence(this._repository);

  final RecurringRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(PendingOccurrence params) =>
      _repository.advanceCursor(
        params.rule.id!,
        RecurrenceSchedule.nextOccurrence(
          params.dueDate,
          params.rule.freq,
          params.rule.interval,
          startDate: params.rule.startDate,
        ),
      );
}
