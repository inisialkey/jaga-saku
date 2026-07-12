import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/repositories/category_repository.dart';

/// Resolves a reserved system category by its [String] `systemKey`
/// (`adjustment_in` / `adjustment_out`). Returns `Right(null)` when the pair is
/// missing (a botched migration) — the reconcile cubit disables confirm rather
/// than crashing or writing an untagged correction (doc §13).
class GetSystemCategory extends UseCase<Category?, String> {
  GetSystemCategory(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, Category?>> call(String params) =>
      _repository.getBySystemKey(params);
}
