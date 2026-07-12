import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/repositories/recurring_repository.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';

/// Params for [SaveRecurringRule]: the owned template shape + the schedule. The
/// cubit builds both (amount required on the template, `nextDue` precomputed on
/// the rule) so the usecase just routes to insert vs. update.
class SaveRecurringRuleParams {
  const SaveRecurringRuleParams({required this.template, required this.rule});

  final TxTemplate template;
  final RecurringRule rule;
}

/// Creates (two-table insert) or updates a recurring rule. Returns the rule id.
class SaveRecurringRule extends UseCase<int, SaveRecurringRuleParams> {
  SaveRecurringRule(this._repository);

  final RecurringRepository _repository;

  @override
  Future<Either<Failure, int>> call(SaveRecurringRuleParams params) {
    if (params.rule.id == null) {
      return _repository.insertRuleWithTemplate(params.template, params.rule);
    }
    return _repository
        .updateRule(params.template, params.rule)
        .then((r) => r.map((_) => params.rule.id!));
  }
}
