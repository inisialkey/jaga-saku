import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/security/domain/entities/auto_lock_duration.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:jaga_saku/features/security/domain/entities/pin_check.dart';

/// Contract for the app-lock secret + config (V3-M4). Implemented in the data
/// layer; every method returns `Either<Failure, T>` — the repository never
/// throws (Rule 4). A wrong PIN or an active cooldown are `Right(PinCheck.…)`
/// states, not failures; `Left(Failure)` is reserved for a real storage fault.
abstract class SecurityRepository {
  /// Loads persisted config (with the hash-presence fail-safe, plan §4-E).
  Future<Either<Failure, LockConfig>> loadConfig();

  /// Hashes + stores a new PIN and turns the lock on.
  Future<Either<Failure, Unit>> setPin(String pin);

  /// Verifies [pin], applying the persisted timed backoff.
  Future<Either<Failure, PinCheck>> verifyPin(String pin);

  /// Overwrites the stored PIN (caller has already verified the current one).
  Future<Either<Failure, Unit>> changePin(String pin);

  /// Clears the secret + all flags (turns the lock off).
  Future<Either<Failure, Unit>> disablePin();

  /// Enabling runs one biometric confirmation ([reason] localized) before
  /// persisting; disabling is free. Returns the resulting enabled state
  /// (`false` when the user cancelled the confirmation).
  Future<Either<Failure, bool>> setBiometricEnabled({
    required bool enabled,
    required String reason,
  });

  /// Whether the device supports + has enrolled biometrics.
  Future<Either<Failure, bool>> isBiometricAvailable();

  /// Runs a biometric prompt ([reason] localized) for the lock screen.
  Future<Either<Failure, bool>> authenticateBiometric(String reason);

  /// Persists the auto-lock threshold.
  Future<Either<Failure, Unit>> setAutoLockDuration(AutoLockDuration duration);
}
