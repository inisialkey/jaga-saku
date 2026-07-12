import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/features/recurring/data/datasources/recurring_local_datasource.dart';
import 'package:jaga_saku/features/recurring/data/models/recurring_model.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/repositories/recurring_repository.dart';
import 'package:jaga_saku/features/templates/data/models/tx_template_model.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:sqflite/sqflite.dart';

/// Wraps [RecurringLocalDatasource] and never throws: every datasource call is
/// guarded and mapped to `Right`/`Left(Failure)` (rule 4). A sqflite
/// [DatabaseException] becomes [CacheFailure], a unique-constraint violation
/// becomes [ConflictFailure]. Entity→model conversion happens inside [_guard].
class RecurringRepositoryImpl implements RecurringRepository {
  RecurringRepositoryImpl(this._datasource);

  final RecurringLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<RecurringRule>>> getRules() =>
      _guard(_datasource.getRules);

  @override
  Future<Either<Failure, int>> insertRuleWithTemplate(
    TxTemplate template,
    RecurringRule rule,
  ) => _guard(
    () => _datasource.insertRuleWithTemplate(
      TxTemplateModel.fromEntity(template),
      RecurringModel.fromEntity(rule),
    ),
  );

  @override
  Future<Either<Failure, Unit>> updateRule(
    TxTemplate template,
    RecurringRule rule,
  ) => _guard(() async {
    await _datasource.updateRule(
      TxTemplateModel.fromEntity(template),
      RecurringModel.fromEntity(rule),
    );
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> deleteRule(int templateId) => _guard(() async {
    await _datasource.deleteRule(templateId);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> advanceCursor(int ruleId, int nextDue) =>
      _guard(() async {
        await _datasource.advanceCursor(ruleId, nextDue);
        return unit;
      });

  /// Runs [action], mapping any failure to a [Failure]. Errors are logged (not
  /// surfaced raw) so the UI only ever sees a localized [Failure].
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DatabaseException catch (e, s) {
      log.e('Recurring DB failure', error: e, stackTrace: s);
      return Left(
        e.isUniqueConstraintError()
            ? const ConflictFailure()
            : const CacheFailure(),
      );
    } catch (e, s) {
      log.e('Recurring failure', error: e, stackTrace: s);
      return const Left(CacheFailure());
    }
  }
}
