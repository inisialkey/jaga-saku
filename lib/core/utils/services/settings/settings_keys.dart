/// Canonical `settings` kv key names shared by MORE THAN ONE writer.
///
/// Only cross-file keys live here — today the two `AppSettingsCubit` owns that
/// `ReminderLocalDatasource` also reads (locale for notification copy, cycle
/// start-day for the warning period). Feature-private keys stay with their
/// owner:
///   • reminder flags/time + budget-warning markers → `ReminderConfig` (public
///     API used by datasource + service + tests; the marker key is a method).
///   • lock flags + backoff state → `PinSecureDatasource` (private, cohesive).
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
}
