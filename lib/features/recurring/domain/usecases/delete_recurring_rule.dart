import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/repositories/recurring_repository.dart';

/// Deletes a recurring rule. Removes the owned template so the FK cascade drops
/// the rule row (C4) — any pending occurrences vanish (acceptable per the spec).
class DeleteRecurringRule extends UseCase<Unit, RecurringRule> {
  DeleteRecurringRule(this._repository);

  final RecurringRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(RecurringRule params) =>
      _repository.deleteRule(params.templateId);
}
