import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/security/domain/repositories/security_repository.dart';

/// Runs a biometric prompt for the lock screen ([reason] localized). Returns
/// `true` on success; any cancel / failure resolves to `false` (PIN fallback).
class AuthenticateBiometric extends UseCase<bool, String> {
  AuthenticateBiometric(this._repository);

  final SecurityRepository _repository;

  @override
  Future<Either<Failure, bool>> call(String params) =>
      _repository.authenticateBiometric(params);
}
