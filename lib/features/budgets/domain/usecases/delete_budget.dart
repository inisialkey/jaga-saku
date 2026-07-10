import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/budgets/domain/repositories/budget_repository.dart';

/// Hard-deletes a budget by id.
class DeleteBudget extends UseCase<Unit, int> {
  DeleteBudget(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(int params) =>
      _repository.deleteBudget(params);
}
