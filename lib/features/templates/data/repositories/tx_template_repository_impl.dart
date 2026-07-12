import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/features/templates/data/datasources/tx_template_local_datasource.dart';
import 'package:jaga_saku/features/templates/data/models/tx_template_model.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/templates/domain/repositories/tx_template_repository.dart';
import 'package:sqflite/sqflite.dart';

/// Wraps [TxTemplateLocalDatasource] and never throws: every datasource call is
/// guarded and mapped to `Right`/`Left(Failure)` (rule 4). A sqflite
/// [DatabaseException] becomes [CacheFailure], a unique-constraint violation
/// becomes [ConflictFailure].
class TxTemplateRepositoryImpl implements TxTemplateRepository {
  TxTemplateRepositoryImpl(this._datasource);

  final TxTemplateLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<TxTemplate>>> getFavorites() => _guard(() async {
    final models = await _datasource.getFavorites();
    return models.map((m) => m.toEntity()).toList();
  });

  @override
  Future<Either<Failure, int>> saveTemplate(TxTemplate template) =>
      _guard(() async {
        final model = TxTemplateModel.fromEntity(template);
        if (template.id == null) return _datasource.insert(model);
        await _datasource.update(model);
        return template.id!;
      });

  @override
  Future<Either<Failure, Unit>> deleteTemplate(int id) => _guard(() async {
    await _datasource.delete(id);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> reorderTemplates(List<int> orderedIds) =>
      _guard(() async {
        await _datasource.reorder(orderedIds);
        return unit;
      });

  /// Runs [action], mapping any failure to a [Failure]. Errors are logged (not
  /// surfaced raw) so the UI only ever sees a localized [Failure].
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DatabaseException catch (e, s) {
      log.e('TxTemplate DB failure', error: e, stackTrace: s);
      return Left(
        e.isUniqueConstraintError()
            ? const ConflictFailure()
            : const CacheFailure(),
      );
    } catch (e, s) {
      log.e('TxTemplate failure', error: e, stackTrace: s);
      return const Left(CacheFailure());
    }
  }
}
