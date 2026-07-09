import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/accounts/domain/repositories/account_repository.dart';

/// Params for [ArchiveAccount]: which account and the target archived state.
class ArchiveAccountParams {
  const ArchiveAccountParams({required this.id, required this.archived});

  final int id;
  final bool archived;
}

/// Archives or unarchives an account (soft hide from the active list).
class ArchiveAccount extends UseCase<Unit, ArchiveAccountParams> {
  ArchiveAccount(this._repository);

  final AccountRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ArchiveAccountParams params) =>
      _repository.archiveAccount(params.id, archived: params.archived);
}
