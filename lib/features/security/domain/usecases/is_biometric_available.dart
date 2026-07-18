import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/security/domain/repositories/security_repository.dart';

/// Whether the device supports + has enrolled biometrics — gates the biometric
/// toggle's visibility on the Security page.
class IsBiometricAvailable extends UseCase<bool, NoParams> {
  IsBiometricAvailable(this._repository);

  final SecurityRepository _repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      _repository.isBiometricAvailable();
}
