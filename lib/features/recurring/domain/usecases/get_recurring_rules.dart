import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/repositories/recurring_repository.dart';

/// Loads every recurring rule (each with its owned template) for the manage
/// screen and the catch-up projection.
class GetRecurringRules extends UseCase<List<RecurringRule>, NoParams> {
  GetRecurringRules(this._repository);

  final RecurringRepository _repository;

  @override
  Future<Either<Failure, List<RecurringRule>>> call(NoParams params) =>
      _repository.getRules();
}
