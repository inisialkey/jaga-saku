import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/accounts/domain/repositories/account_repository.dart';

/// Hard-deletes an account by id. When a delete is blocked (e.g. transactions
/// reference it in M2) the cubit falls back to archiving.
class DeleteAccount extends UseCase<Unit, int> {
  DeleteAccount(this._repository);

  final AccountRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(int params) =>
      _repository.deleteAccount(params);
}
