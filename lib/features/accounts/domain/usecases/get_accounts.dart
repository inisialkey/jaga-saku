import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/repositories/account_repository.dart';

/// Loads every account (including archived) with its derived balance. The
/// presentation layer filters archived rows via a UI toggle, so this loads the
/// full set once — hence [NoParams].
class GetAccounts extends UseCase<List<Account>, NoParams> {
  GetAccounts(this._repository);

  final AccountRepository _repository;

  @override
  Future<Either<Failure, List<Account>>> call(NoParams params) =>
      _repository.getAccounts(includeArchived: true);
}
