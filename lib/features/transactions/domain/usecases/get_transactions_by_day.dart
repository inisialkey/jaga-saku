import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/repositories/transaction_repository.dart';

/// Loads a single day's transactions — the calendar's selected-day list.
class GetTransactionsByDay extends UseCase<List<Transaction>, DateTime> {
  GetTransactionsByDay(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, List<Transaction>>> call(DateTime params) =>
      _repository.getTransactionsByDay(params);
}
