import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:jaga_saku/features/security/domain/repositories/security_repository.dart';

/// Loads the persisted lock config (with the hash-presence fail-safe, §4-E).
class GetLockConfig extends UseCase<LockConfig, NoParams> {
  GetLockConfig(this._repository);

  final SecurityRepository _repository;

  @override
  Future<Either<Failure, LockConfig>> call(NoParams params) =>
      _repository.loadConfig();
}
