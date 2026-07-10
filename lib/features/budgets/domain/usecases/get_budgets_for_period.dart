import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/repositories/budget_repository.dart';

/// Loads every budget for a 'YYYY-MM' [period], each with its derived
/// [Budget.spent]. Reused by the Budget list, the Home guard (current month) and
/// the Add-transaction safe-daily warning.
class GetBudgetsForPeriod extends UseCase<List<Budget>, String> {
  GetBudgetsForPeriod(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Either<Failure, List<Budget>>> call(String params) =>
      _repository.getBudgetsForPeriod(params);
}
