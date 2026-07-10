import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/transactions/domain/repositories/transaction_repository.dart';

/// Hard-deletes a transaction by id. Deleting an entry reverses its effect on
/// the account balance (the balance query sums live rows).
class DeleteTransaction extends UseCase<Unit, int> {
  DeleteTransaction(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(int params) =>
      _repository.deleteTransaction(params);
}
