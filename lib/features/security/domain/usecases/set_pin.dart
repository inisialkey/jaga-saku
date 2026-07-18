import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/security/domain/repositories/security_repository.dart';

/// Hashes + stores a new 6-digit PIN and turns the lock on.
class SetPin extends UseCase<Unit, String> {
  SetPin(this._repository);

  final SecurityRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String params) =>
      _repository.setPin(params);
}
