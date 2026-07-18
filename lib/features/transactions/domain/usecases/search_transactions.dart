import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/repositories/transaction_repository.dart';

/// Runs a multi-facet transaction search (V3-M3). Thin pass-through to the
/// repository, which pushes the keyword + filters + sort into a single dynamic
/// DAO query.
class SearchTransactions
    extends UseCase<List<Transaction>, SearchTransactionParams> {
  SearchTransactions(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, List<Transaction>>> call(
    SearchTransactionParams params,
  ) => _repository.search(params);
}
