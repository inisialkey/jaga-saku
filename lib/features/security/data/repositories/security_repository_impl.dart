import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/features/security/data/datasources/biometric_auth_datasource.dart';
import 'package:jaga_saku/features/security/data/datasources/pin_secure_datasource.dart';
import 'package:jaga_saku/features/security/domain/entities/auto_lock_duration.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:jaga_saku/features/security/domain/entities/pin_check.dart';
import 'package:jaga_saku/features/security/domain/repositories/security_repository.dart';

/// Folds every datasource call to `Either<Failure, T>` and never throws (Rule
/// 4): any error is logged and mapped to [CacheFailure]. A wrong PIN / cooldown
/// stay as `Right(PinCheck)`; enabling biometric is gated on a live
/// confirmation.
class SecurityRepositoryImpl implements SecurityRepository {
  SecurityRepositoryImpl(this._pin, this._biometric);

  final PinSecureDatasource _pin;
  final BiometricAuthDatasource _biometric;

  @override
  Future<Either<Failure, LockConfig>> loadConfig() => _guard(_pin.loadConfig);

  @override
  Future<Either<Failure, Unit>> setPin(String pin) => _guard(() async {
    await _pin.setPin(pin);
    return unit;
  });

  @override
  Future<Either<Failure, PinCheck>> verifyPin(String pin) =>
      _guard(() => _pin.verify(pin));

  @override
  Future<Either<Failure, Unit>> changePin(String pin) => _guard(() async {
    await _pin.changePin(pin);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> disablePin() => _guard(() async {
    await _pin.disable();
    return unit;
  });

  @override
  Future<Either<Failure, bool>> setBiometricEnabled({
    required bool enabled,
    required String reason,
  }) => _guard(() async {
    // Enabling requires a live biometric confirmation; a cancel leaves it off.
    if (enabled && !await _biometric.authenticate(reason)) return false;
    await _pin.setBiometricEnabled(enabled: enabled);
    return enabled;
  });

  @override
  Future<Either<Failure, bool>> isBiometricAvailable() =>
      _guard(_biometric.isAvailable);

  @override
  Future<Either<Failure, bool>> authenticateBiometric(String reason) =>
      _guard(() => _biometric.authenticate(reason));

  @override
  Future<Either<Failure, Unit>> setAutoLockDuration(
    AutoLockDuration duration,
  ) => _guard(() async {
    await _pin.setAutoLockDuration(duration);
    return unit;
  });

  /// Runs [action], mapping any thrown error to a logged [CacheFailure] so the
  /// UI only ever sees a localized [Failure] (Rule 4 / Rule 17).
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } catch (e, s) {
      log.e('Security failure', error: e, stackTrace: s);
      return const Left(CacheFailure());
    }
  }
}
