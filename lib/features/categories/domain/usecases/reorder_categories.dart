import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/categories/domain/repositories/category_repository.dart';

/// Persists a new category ordering — each id's `sort_order` becomes its index
/// in [call]'s list.
class ReorderCategories extends UseCase<Unit, List<int>> {
  ReorderCategories(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(List<int> params) =>
      _repository.reorderCategories(params);
}
