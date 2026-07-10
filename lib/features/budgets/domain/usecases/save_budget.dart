import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/repositories/budget_repository.dart';

/// Creates or updates a budget (insert when [Budget.id] is null). Returns the
/// row id. The form resolves an existing `(category, period)` to an update
/// before calling this, so a [ConflictFailure] here is the race-condition safety
/// net rather than the happy path.
class SaveBudget extends UseCase<int, Budget> {
  SaveBudget(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Either<Failure, int>> call(Budget params) =>
      _repository.saveBudget(params);
}
