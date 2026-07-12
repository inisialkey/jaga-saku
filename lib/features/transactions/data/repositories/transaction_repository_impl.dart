import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/core/utils/services/receipt_storage_service.dart';
import 'package:jaga_saku/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';
import 'package:jaga_saku/features/transactions/data/models/transaction_model.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/repositories/transaction_repository.dart';
// sqflite exports its own `Transaction` (a DB txn handle) — hide it so it does
// not collide with our domain entity of the same name.
import 'package:sqflite/sqflite.dart' hide Transaction;

/// Wraps [TransactionLocalDatasource] and never throws: every datasource call
/// is guarded and mapped to `Right`/`Left(Failure)` (rule 4). A sqflite
/// [DatabaseException] becomes [CacheFailure] (there is no unique constraint on
/// the table, but the mapping mirrors the accounts repository for uniformity).
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._datasource, this._receiptStorage);

  final TransactionLocalDatasource _datasource;
  final ReceiptStorageService _receiptStorage;

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByMonth(
    DateTime month,
  ) => _guard(() async {
    final models = await _datasource.getByMonth(month);
    return models.map((m) => m.toEntity()).toList();
  });

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDay(
    DateTime day,
  ) => _guard(() async {
    final models = await _datasource.getByDay(day);
    return models.map((m) => m.toEntity()).toList();
  });

  @override
  Future<Either<Failure, List<Transaction>>> getRecentTransactions(int limit) =>
      _guard(() async {
        final models = await _datasource.getRecent(limit);
        return models.map((m) => m.toEntity()).toList();
      });

  @override
  Future<Either<Failure, int>> saveTransaction(Transaction transaction) =>
      _guard(() async {
        final model = TransactionModel.fromEntity(transaction);
        if (transaction.id == null) return _datasource.insert(model);
        await _datasource.update(model);
        return transaction.id!;
      });

  @override
  Future<Either<Failure, Unit>> deleteTransaction(int id) => _guard(() async {
    // Read the receipt path before the row goes, so every delete caller (edit
    // form, any future swipe-to-delete) frees the file — the root-cause fix.
    final path = await _datasource.getReceiptPath(id);
    await _datasource.delete(id);
    // No-throw (logs on failure) → a stale file never blocks the row delete.
    if (path != null) await _receiptStorage.delete(path);
    return unit;
  });

  @override
  Future<Either<Failure, List<MonthDelta>>> monthlyNetDeltas(
    int startMillis,
    int endMillis,
  ) => _guard(() => _datasource.monthlyNetDeltas(startMillis, endMillis));

  /// Runs [action], mapping any failure to a [Failure]. Errors are logged (not
  /// surfaced raw) so the UI only ever sees a localized [Failure].
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DatabaseException catch (e, s) {
      log.e('Transaction DB failure', error: e, stackTrace: s);
      return Left(
        e.isUniqueConstraintError()
            ? const ConflictFailure()
            : const CacheFailure(),
      );
    } catch (e, s) {
      log.e('Transaction failure', error: e, stackTrace: s);
      return const Left(CacheFailure());
    }
  }
}
