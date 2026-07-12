import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';

/// Contract for category persistence. Every method returns
/// `Either<Failure, T>` — the repository never throws (rule 4).
abstract class CategoryRepository {
  /// Categories of [type] ordered by `sort_order`, archived rows excluded
  /// unless [includeArchived] is set. The list is flat; the presentation layer
  /// groups it into parent -> child.
  Future<Either<Failure, List<Category>>> getCategories({
    required CategoryType type,
    bool includeArchived = false,
  });

  /// The reserved system category for [systemKey] (`adjustment_in` /
  /// `adjustment_out`), or `Right(null)` when the pair is absent (a botched
  /// migration — the reconcile cubit disables confirm rather than crashing).
  Future<Either<Failure, Category?>> getBySystemKey(String systemKey);

  /// Inserts (when [Category.id] is null) or updates the category. Returns the
  /// row id.
  Future<Either<Failure, int>> saveCategory(Category category);

  /// Hard-deletes the category. Children cascade automatically (self-ref FK is
  /// `ON DELETE CASCADE`).
  Future<Either<Failure, Unit>> deleteCategory(int id);

  Future<Either<Failure, Unit>> archiveCategory(
    int id, {
    required bool archived,
  });

  /// Persists a new ordering — `sort_order` becomes each id's index.
  Future<Either<Failure, Unit>> reorderCategories(List<int> orderedIds);
}
