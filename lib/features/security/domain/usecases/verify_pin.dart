import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/security/domain/entities/pin_check.dart';
import 'package:jaga_saku/features/security/domain/repositories/security_repository.dart';

/// Verifies a PIN, returning the [PinCheck] state (ok / wrong / lockedOut). The
/// timed backoff is centralised in the datasource, so both the lock gate and
/// settings-verify inherit it.
class VerifyPin extends UseCase<PinCheck, String> {
  VerifyPin(this._repository);

  final SecurityRepository _repository;

  @override
  Future<Either<Failure, PinCheck>> call(String params) =>
      _repository.verifyPin(params);
}
