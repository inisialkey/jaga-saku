import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/features/categories/data/datasources/category_local_datasource.dart';
import 'package:jaga_saku/features/categories/data/models/category_model.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/repositories/category_repository.dart';
import 'package:sqflite/sqflite.dart';

/// Wraps [CategoryLocalDatasource] and never throws (rule 4). A sqflite
/// [DatabaseException] becomes [CacheFailure]; a unique-constraint violation
/// becomes [ConflictFailure].
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._datasource);

  final CategoryLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<Category>>> getCategories({
    required CategoryType type,
    bool includeArchived = false,
  }) => _guard(() async {
    final models = await _datasource.getCategories(
      type: type,
      includeArchived: includeArchived,
    );
    return models.map((m) => m.toEntity()).toList();
  });

  @override
  Future<Either<Failure, int>> saveCategory(Category category) =>
      _guard(() async {
        final model = CategoryModel.fromEntity(category);
        if (category.id == null) return _datasource.insert(model);
        await _datasource.update(model);
        return category.id!;
      });

  @override
  Future<Either<Failure, Unit>> deleteCategory(int id) => _guard(() async {
    await _datasource.delete(id);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> archiveCategory(
    int id, {
    required bool archived,
  }) => _guard(() async {
    await _datasource.setArchived(id, archived: archived);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> reorderCategories(List<int> orderedIds) =>
      _guard(() async {
        await _datasource.reorder(orderedIds);
        return unit;
      });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DatabaseException catch (e, s) {
      log.e('Category DB failure', error: e, stackTrace: s);
      return Left(
        e.isUniqueConstraintError()
            ? const ConflictFailure()
            : const CacheFailure(),
      );
    } catch (e, s) {
      log.e('Category failure', error: e, stackTrace: s);
      return const Left(CacheFailure());
    }
  }
}
