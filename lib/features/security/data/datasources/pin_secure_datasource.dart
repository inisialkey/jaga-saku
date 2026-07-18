import 'package:jaga_saku/core/utils/services/secure_storage/secure_storage_service.dart';
import 'package:jaga_saku/core/utils/services/settings/settings_service.dart';
import 'package:jaga_saku/features/security/data/models/pin_hasher.dart';
import 'package:jaga_saku/features/security/data/security_backoff.dart';
import 'package:jaga_saku/features/security/domain/entities/auto_lock_duration.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:jaga_saku/features/security/domain/entities/pin_check.dart';

/// Owns the PIN secret + the persisted backoff state (V3-M4).
///
/// The salted hash lives in [SecureStorageService] (`pin_hash` / `pin_salt`);
/// the non-secret config + attempt counter + `locked-until` timestamp live in
/// the `settings` kv via [SettingsService]. Persisting `locked-until` there is
/// what makes a force-kill unable to reset an active cooldown. The [now] clock
/// is an injectable seam so cooldown logic is unit-tested without a real clock.
class PinSecureDatasource {
  PinSecureDatasource({
    required SecureStorageService secure,
    required SettingsService settings,
    PinHasher hasher = const PinHasher(),
    DateTime Function()? now,
  }) : _secure = secure,
       _settings = settings,
       _hasher = hasher,
       _now = now ?? DateTime.now;

  final SecureStorageService _secure;
  final SettingsService _settings;
  final PinHasher _hasher;
  final DateTime Function() _now;

  // Secret (secure storage).
  static const String _kPinHash = 'pin_hash';
  static const String _kPinSalt = 'pin_salt';
  // Non-secret config + backoff state (settings kv).
  static const String _kPinEnabled = 'lock_pin_enabled';
  static const String _kBiometricEnabled = 'lock_biometric_enabled';
  static const String _kAutoDuration = 'lock_auto_duration';
  static const String _kFailedAttempts = 'lock_failed_attempts';
  static const String _kLockedUntil = 'lock_locked_until';

  /// Hashes + stores a new PIN and flips the master switch on. Clears any
  /// attempt counter / cooldown from a prior enrollment.
  Future<void> setPin(String pin) async {
    await _writeHash(pin);
    await _settings.setString(_kPinEnabled, '1');
    await _resetAttempts();
  }

  /// Overwrites the stored hash with a new PIN (the switch is already on).
  Future<void> changePin(String pin) async {
    await _writeHash(pin);
    await _resetAttempts();
  }

  /// Verifies [pin] against the stored hash, applying the persisted timed
  /// backoff (plan §3):
  /// 1. still in cooldown → [PinCheck.lockedOut] with NO hash compare;
  /// 2. match → clear attempts/cooldown → [PinCheck.ok];
  /// 3. mismatch → bump the counter, arm the escalating cooldown if due →
  ///    [PinCheck.wrong].
  Future<PinCheck> verify(String pin) async {
    var attempts =
        int.tryParse(await _settings.getString(_kFailedAttempts) ?? '') ?? 0;
    final until = int.tryParse(await _settings.getString(_kLockedUntil) ?? '');

    if (until != null && isInCooldown(_now(), until)) {
      return PinCheck.lockedOut(cooldownUntilMs: until);
    }

    final salt = await _secure.read(_kPinSalt);
    final hash = await _secure.read(_kPinHash);
    final matches =
        salt != null &&
        hash != null &&
        _hasher.verify(pin, salt: salt, hash: hash);

    if (matches) {
      await _resetAttempts();
      return const PinCheck.ok();
    }

    attempts += 1;
    await _settings.setString(_kFailedAttempts, '$attempts');
    final delay = backoffFor(attempts);
    if (delay > Duration.zero) {
      final newUntil = _now().millisecondsSinceEpoch + delay.inMilliseconds;
      await _settings.setString(_kLockedUntil, '$newUntil');
      return PinCheck.wrong(
        failedAttempts: attempts,
        cooldownUntilMs: newUntil,
      );
    }
    return PinCheck.wrong(failedAttempts: attempts);
  }

  /// Whether a PIN hash is present. Also the fail-safe used by [loadConfig].
  Future<bool> hasPin() => _secure.containsKey(_kPinHash);

  /// Clears the secret + all lock flags (disable / turn the lock off). Biometric
  /// is turned off with the PIN — it can never outlive its base unlock.
  Future<void> disable() async {
    await _secure.delete(_kPinHash);
    await _secure.delete(_kPinSalt);
    await _settings.setString(_kPinEnabled, '0');
    await _settings.setString(_kBiometricEnabled, '0');
    await _resetAttempts();
  }

  Future<void> setBiometricEnabled({required bool enabled}) =>
      _settings.setString(_kBiometricEnabled, enabled ? '1' : '0');

  Future<void> setAutoLockDuration(AutoLockDuration duration) =>
      _settings.setString(_kAutoDuration, duration.name);

  /// Reads the persisted config. Fail-safe (plan §4-E): the master switch is
  /// only honoured when a hash is actually present, so a keystore reset that
  /// loses `pin_hash` leaves the app usable (`isPinEnabled == false`).
  Future<LockConfig> loadConfig() async {
    final pinFlag = await _settings.getString(_kPinEnabled);
    final isPinEnabled = pinFlag == '1' && await hasPin();
    final bioFlag = await _settings.getString(_kBiometricEnabled);
    final duration = AutoLockDuration.fromName(
      await _settings.getString(_kAutoDuration),
    );
    return LockConfig(
      isPinEnabled: isPinEnabled,
      isBiometricEnabled: isPinEnabled && bioFlag == '1',
      autoLockDuration: duration,
    );
  }

  Future<void> _writeHash(String pin) async {
    final salt = _hasher.newSalt();
    await _secure.write(_kPinSalt, salt);
    await _secure.write(_kPinHash, _hasher.hash(pin, salt));
  }

  Future<void> _resetAttempts() async {
    await _settings.setString(_kFailedAttempts, '0');
    await _settings.remove(_kLockedUntil);
  }
}
