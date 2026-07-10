import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/repositories/transaction_repository.dart';

/// Loads a whole month of transactions (any day in that month) — feeds the
/// calendar grid's per-day event dots.
class GetTransactionsByMonth extends UseCase<List<Transaction>, DateTime> {
  GetTransactionsByMonth(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, List<Transaction>>> call(DateTime params) =>
      _repository.getTransactionsByMonth(params);
}
