import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';

/// Contract for recurring-rule persistence. Implemented in the data layer; every
/// method returns `Either<Failure, T>` — the repository never throws (rule 4).
abstract class RecurringRepository {
  /// Every rule with its owned [RecurringRule.template] populated (join),
  /// ordered by the `next_due` cursor.
  Future<Either<Failure, List<RecurringRule>>> getRules();

  /// Inserts a rule + its owned template in one transaction (C3). Returns the
  /// new rule id.
  Future<Either<Failure, int>> insertRuleWithTemplate(
    TxTemplate template,
    RecurringRule rule,
  );

  /// Updates both the owned template and the rule in one transaction.
  Future<Either<Failure, Unit>> updateRule(
    TxTemplate template,
    RecurringRule rule,
  );

  /// Deletes the owned template so the FK cascade drops the rule (C4). Takes the
  /// `template_id`, not the rule id.
  Future<Either<Failure, Unit>> deleteRule(int templateId);

  /// Moves the idempotency cursor forward after a confirm / skip.
  Future<Either<Failure, Unit>> advanceCursor(int ruleId, int nextDue);
}
