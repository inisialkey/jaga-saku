import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/repositories/transaction_repository.dart';

/// Loads the N most recent transactions. Built in M2 for the Home
/// recent-activity section (wired to Home in M3).
class GetRecentTransactions extends UseCase<List<Transaction>, int> {
  GetRecentTransactions(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, List<Transaction>>> call(int params) =>
      _repository.getRecentTransactions(params);
}
