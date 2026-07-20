/// Canonical `settings` kv key names shared by MORE THAN ONE writer.
///
/// Only cross-file keys live here — today the two `AppSettingsCubit` owns that
/// `ReminderLocalDatasource` also reads (locale for notification copy, cycle
/// start-day for the warning period). Feature-private keys stay with their
/// owner:
///   • reminder flags/time + budget-warning markers → `ReminderConfig` (public
///     API used by datasource + service + tests; the marker key is a method).
///   • lock flags + backoff state → owned by `PinSecureDatasource`, but listed
///     here as [deviceLockKeys] because `BackupLocalDatasource.restore` must
///     also name them to carry them across a restore.
///   • last-export metadata → `BackupCubit` (private; renaming would orphan the
///     persisted `backup.*` rows on existing installs — left as-is on purpose).
///   • onboarding step + quick-start flag → `OnboardingLocalDatasource`
///     (private consts; only that one datasource reads or writes them). Its
///     third key, the completion marker, IS shared — see [onboardingCompleted].
///
/// These strings are PRIMARY KEYS in the `settings` table: renaming one orphans
/// every existing install's row. Add keys here, never rename them.
class SettingsKeys {
  SettingsKeys._();

  /// Locale code (`'en'`/`'id'`/`'system'`). Owner: `AppSettingsCubit`.
  static const String locale = 'locale';

  /// Budget cycle start-day, string-encoded 1..31. Owner: `AppSettingsCubit`.
  static const String budgetCycleStartDay = 'budget_cycle_start_day';

  /// Onboarding completion marker (`'1'` = done). TWO writers, hence here:
  /// `OnboardingLocalDatasource` (the user finishing the flow) and
  /// `Migrations.grandfatherOnboarding`, which grandfathers every pre-V5
  /// install past onboarding from `onUpgrade` AND is re-applied by
  /// `BackupLocalDatasource.restore` (a restore wipes `settings`, and no
  /// pre-V5 backup carries this row). V5-M1.
  static const String onboardingCompleted = 'onboarding_completed';

  /// App-lock master switch (`'1'` = on). Owner: `PinSecureDatasource`.
  static const String lockPinEnabled = 'lock_pin_enabled';

  /// Biometric-unlock switch (`'1'` = on). Owner: `PinSecureDatasource`.
  static const String lockBiometricEnabled = 'lock_biometric_enabled';

  /// Auto-lock delay, an `AutoLockDuration.name`. Owner: `PinSecureDatasource`.
  static const String lockAutoDuration = 'lock_auto_duration';

  /// Consecutive failed PIN attempts. Owner: `PinSecureDatasource`.
  static const String lockFailedAttempts = 'lock_failed_attempts';

  /// Epoch millis until which unlocking is refused. Owner:
  /// `PinSecureDatasource`.
  static const String lockLockedUntil = 'lock_locked_until';

  /// The lock rows that describe THIS DEVICE rather than the ledger, and so
  /// must survive a restore. A restore replaces `settings` wholesale from the
  /// envelope, which would let a backup taken on a PIN-less device silently
  /// switch the lock OFF — `loadConfig`'s fail-safe (`pinFlag == '1' && hasPin`)
  /// then reads `isPinEnabled == false` while `pin_hash` is still sitting in
  /// secure storage, which a restore never touches. The same wipe cleared an
  /// armed lockout cooldown. Consumed by `BackupLocalDatasource.restore`.
  static const List<String> deviceLockKeys = [
    lockPinEnabled,
    lockBiometricEnabled,
    lockAutoDuration,
    lockFailedAttempts,
    lockLockedUntil,
  ];
}
