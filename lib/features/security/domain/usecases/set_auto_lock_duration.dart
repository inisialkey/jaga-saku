import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/security/domain/entities/auto_lock_duration.dart';
import 'package:jaga_saku/features/security/domain/repositories/security_repository.dart';

/// Persists the auto-lock threshold. Routed through the repo (not written to
/// `settings` from the cubit) so the datasource stays the single owner of the
/// `lock_auto_duration` key.
class SetAutoLockDuration extends UseCase<Unit, AutoLockDuration> {
  SetAutoLockDuration(this._repository);

  final SecurityRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(AutoLockDuration params) =>
      _repository.setAutoLockDuration(params);
}
