import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/repositories/account_repository.dart';

/// Creates or updates an account (insert when [Account.id] is null). Returns
/// the row id.
class SaveAccount extends UseCase<int, Account> {
  SaveAccount(this._repository);

  final AccountRepository _repository;

  @override
  Future<Either<Failure, int>> call(Account params) =>
      _repository.saveAccount(params);
}
