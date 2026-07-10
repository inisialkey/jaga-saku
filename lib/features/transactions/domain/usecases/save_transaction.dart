import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/repositories/transaction_repository.dart';

/// Creates or updates a transaction (insert when [Transaction.id] is null).
/// Returns the row id.
class SaveTransaction extends UseCase<int, Transaction> {
  SaveTransaction(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, int>> call(Transaction params) =>
      _repository.saveTransaction(params);
}
