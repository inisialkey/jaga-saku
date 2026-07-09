import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/accounts/domain/repositories/account_repository.dart';

/// Persists a new account ordering — each id's `sort_order` becomes its index
/// in [call]'s list.
class ReorderAccounts extends UseCase<Unit, List<int>> {
  ReorderAccounts(this._repository);

  final AccountRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(List<int> params) =>
      _repository.reorderAccounts(params);
}
