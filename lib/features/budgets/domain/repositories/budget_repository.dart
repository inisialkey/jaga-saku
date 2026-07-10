import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';

/// Contract for budget persistence. Implemented in the data layer; every method
/// returns `Either<Failure, T>` — the repository never throws (rule 4).
abstract class BudgetRepository {
  /// Budgets for [period] ('YYYY-MM'), each carrying its derived [Budget.spent]
  /// (the sum of that category's expenses in the same period), ordered by
  /// `created_at`.
  Future<Either<Failure, List<Budget>>> getBudgetsForPeriod(String period);

  /// Inserts (when [Budget.id] is null) or updates the budget. Returns the row
  /// id. A duplicate `(category_id, period)` on insert surfaces as
  /// [ConflictFailure].
  Future<Either<Failure, int>> saveBudget(Budget budget);

  /// Hard-deletes the budget by id.
  Future<Either<Failure, Unit>> deleteBudget(int id);
}
