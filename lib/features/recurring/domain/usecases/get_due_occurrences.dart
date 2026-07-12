import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/recurrence_schedule.dart';
import 'package:jaga_saku/features/recurring/domain/repositories/recurring_repository.dart';

/// The catch-up projection (V2-M5): reads all rules and projects each rule's due
/// occurrences from its `next_due` cursor up to today, flattened + sorted by
/// `dueDate` ascending. **Writes nothing** — it only surfaces what's pending;
/// confirming / skipping is what advances the cursor. Idempotent: re-running
/// without confirming re-surfaces the identical set.
class GetDueOccurrences extends UseCase<List<PendingOccurrence>, NoParams> {
  GetDueOccurrences(this._repository);

  final RecurringRepository _repository;

  @override
  Future<Either<Failure, List<PendingOccurrence>>> call(NoParams params) async {
    // The clock lives here (the pure helper is clock-free): today's midnight is
    // the inclusive upper bound of the projection.
    final now = DateTime.now();
    final until = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final result = await _repository.getRules();
    return result.map((rules) {
      final out = <PendingOccurrence>[];
      for (final rule in rules) {
        final template = rule.template;
        if (template == null) continue; // defensive — getRules always joins it
        for (final dueDate in RecurrenceSchedule.dueOccurrences(
          cursor: rule.nextDue,
          until: until,
          freq: rule.freq,
          interval: rule.interval,
          startDate: rule.startDate,
          endDate: rule.endDate,
        )) {
          out.add(
            PendingOccurrence(rule: rule, template: template, dueDate: dueDate),
          );
        }
      }
      // Global ascending ⇒ per-rule ascending, so confirmAll lands each rule's
      // last confirm past its last occurrence.
      out.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return out;
    });
  }
}
