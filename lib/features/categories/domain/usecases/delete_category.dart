import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/categories/domain/repositories/category_repository.dart';

/// Hard-deletes a category by id. Its sub-categories cascade automatically
/// (self-ref FK is `ON DELETE CASCADE`) — the UI warns before confirming.
class DeleteCategory extends UseCase<Unit, int> {
  DeleteCategory(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(int params) =>
      _repository.deleteCategory(params);
}
