import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/repositories/category_repository.dart';

/// Creates or updates a category (insert when [Category.id] is null). Returns
/// the row id.
class SaveCategory extends UseCase<int, Category> {
  SaveCategory(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, int>> call(Category params) =>
      _repository.saveCategory(params);
}
