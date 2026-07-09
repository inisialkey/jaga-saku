import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/categories/domain/repositories/category_repository.dart';

/// Params for [ArchiveCategory]: which category and the target archived state.
class ArchiveCategoryParams {
  const ArchiveCategoryParams({required this.id, required this.archived});

  final int id;
  final bool archived;
}

/// Archives or unarchives a category.
class ArchiveCategory extends UseCase<Unit, ArchiveCategoryParams> {
  ArchiveCategory(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ArchiveCategoryParams params) =>
      _repository.archiveCategory(params.id, archived: params.archived);
}
