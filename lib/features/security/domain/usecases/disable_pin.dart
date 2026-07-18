import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/security/domain/repositories/security_repository.dart';

/// Turns the lock off: clears the PIN secret + all flags (biometric with it).
class DisablePin extends UseCase<Unit, NoParams> {
  DisablePin(this._repository);

  final SecurityRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.disablePin();
}
