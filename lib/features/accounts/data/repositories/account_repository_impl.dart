import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:jaga_saku/features/accounts/data/models/account_model.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/repositories/account_repository.dart';
import 'package:sqflite/sqflite.dart';

/// Wraps [AccountLocalDatasource] and never throws: every datasource call is
/// guarded and mapped to `Right`/`Left(Failure)` (rule 4). A sqflite
/// [DatabaseException] becomes [CacheFailure], a unique-constraint violation
/// becomes [ConflictFailure].
class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._datasource);

  final AccountLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<Account>>> getAccounts({
    bool includeArchived = false,
  }) => _guard(() async {
    final models = await _datasource.getAccounts(
      includeArchived: includeArchived,
    );
    return models.map((m) => m.toEntity()).toList();
  });

  @override
  Future<Either<Failure, int>> saveAccount(Account account) => _guard(() async {
    final model = AccountModel.fromEntity(account);
    if (account.id == null) return _datasource.insert(model);
    await _datasource.update(model);
    return account.id!;
  });

  @override
  Future<Either<Failure, Unit>> deleteAccount(int id) => _guard(() async {
    await _datasource.delete(id);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> archiveAccount(
    int id, {
    required bool archived,
  }) => _guard(() async {
    await _datasource.setArchived(id, archived: archived);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> reorderAccounts(List<int> orderedIds) =>
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
      log.e('Account DB failure', error: e, stackTrace: s);
      return Left(
        e.isUniqueConstraintError()
            ? const ConflictFailure()
            : const CacheFailure(),
      );
    } catch (e, s) {
      log.e('Account failure', error: e, stackTrace: s);
      return const Left(CacheFailure());
    }
  }
}
