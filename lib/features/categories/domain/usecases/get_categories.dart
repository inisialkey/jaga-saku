import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/repositories/category_repository.dart';

/// Loads all categories (including archived) of the given [CategoryType]. The
/// presentation layer filters archived rows and builds the parent -> child tree.
class GetCategories extends UseCase<List<Category>, CategoryType> {
  GetCategories(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, List<Category>>> call(CategoryType params) =>
      _repository.getCategories(type: params, includeArchived: true);
}
