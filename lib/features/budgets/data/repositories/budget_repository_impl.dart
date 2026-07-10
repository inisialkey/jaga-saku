import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/features/budgets/data/datasources/budget_local_datasource.dart';
import 'package:jaga_saku/features/budgets/data/models/budget_model.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/repositories/budget_repository.dart';
import 'package:sqflite/sqflite.dart';

/// Wraps [BudgetLocalDatasource] and never throws: every datasource call is
/// guarded and mapped to `Right`/`Left(Failure)` (rule 4). A unique-constraint
/// violation (duplicate `category_id, period`) becomes [ConflictFailure]; any
/// other sqflite [DatabaseException] (or unexpected error) becomes
/// [CacheFailure].
class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._datasource);

  final BudgetLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<Budget>>> getBudgetsForPeriod(String period) =>
      _guard(() async {
        final models = await _datasource.getBudgetsForPeriod(period);
        return models.map((m) => m.toEntity()).toList();
      });

  @override
  Future<Either<Failure, int>> saveBudget(Budget budget) => _guard(() async {
    final model = BudgetModel.fromEntity(budget);
    if (budget.id == null) return _datasource.insert(model);
    await _datasource.update(model);
    return budget.id!;
  });

  @override
  Future<Either<Failure, Unit>> deleteBudget(int id) => _guard(() async {
    await _datasource.delete(id);
    return unit;
  });

  /// Runs [action], mapping any failure to a [Failure]. Errors are logged (not
  /// surfaced raw) so the UI only ever sees a localized [Failure].
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DatabaseException catch (e, s) {
      log.e('Budget DB failure', error: e, stackTrace: s);
      return Left(
        e.isUniqueConstraintError()
            ? const ConflictFailure()
            : const CacheFailure(),
      );
    } catch (e, s) {
      log.e('Budget failure', error: e, stackTrace: s);
      return const Left(CacheFailure());
    }
  }
}
