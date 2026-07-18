import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/security/domain/repositories/security_repository.dart';

/// Params for [SetBiometricEnabled]: the target state + the localized [reason]
/// shown in the OS biometric dialog when enabling.
class SetBiometricParams {
  const SetBiometricParams({required this.enabled, required this.reason});

  final bool enabled;
  final String reason;
}

/// Enables / disables biometric unlock. Enabling runs one live biometric
/// confirmation first (repo-side); the result is the state actually persisted
/// (`false` when the user cancelled).
class SetBiometricEnabled extends UseCase<bool, SetBiometricParams> {
  SetBiometricEnabled(this._repository);

  final SecurityRepository _repository;

  @override
  Future<Either<Failure, bool>> call(SetBiometricParams params) => _repository
      .setBiometricEnabled(enabled: params.enabled, reason: params.reason);
}
