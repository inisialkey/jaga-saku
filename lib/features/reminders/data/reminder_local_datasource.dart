import 'package:jaga_saku/core/utils/services/settings/settings_service.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_config.dart';

/// Settings-kv wrapper for reminder preferences + budget-warning dedupe markers
/// (V3-M5). Every value lives in the `settings` table via [SettingsService]
/// (string-encoded, exactly like `AppSettingsCubit`) — no new sqflite table, no
/// schema migration. The only persistence the reminder feature owns; the pure
/// usecases stay off it, so all decision logic unit-tests without this seam.
class ReminderLocalDatasource {
  ReminderLocalDatasource(this._settings);

  final SettingsService _settings;

  /// `locale` + `budget_cycle_start_day` are OWNED by `AppSettingsCubit` (their
  /// key consts are private there). Read-only here — to localize notification
  /// copy and to compute the current budget period the warning check runs
  /// against — so the key names are mirrored, not shared.
  static const String _localeKey = 'locale';
  static const String _cycleStartDayKey = 'budget_cycle_start_day';

  /// Reads every reminder flag + the daily time into a [ReminderConfig]. Unset
  /// keys fall back to the [ReminderConfig] defaults (all off, 20:00).
  Future<ReminderConfig> readConfig() async {
    final daily = await _settings.getString(ReminderConfig.dailyEnabledKey);
    final time = await _settings.getString(ReminderConfig.dailyTimeKey);
    final recurring = await _settings.getString(
      ReminderConfig.recurringEnabledKey,
    );
    final budget = await _settings.getString(ReminderConfig.budgetEnabledKey);
    final (hour, minute) = _parseTime(time);
    return ReminderConfig(
      dailyEnabled: daily == '1',
      dailyHour: hour,
      dailyMinute: minute,
      recurringDueEnabled: recurring == '1',
      budgetWarningEnabled: budget == '1',
    );
  }

  /// Persists the daily check-in flag (`"1"`/`"0"`).
  Future<void> writeDaily({required bool enabled}) =>
      _settings.setString(ReminderConfig.dailyEnabledKey, enabled ? '1' : '0');

  /// Persists the daily time as zero-padded `"HH:mm"` (SettingsService is
  /// TEXT-only, mirroring `budget_cycle_start_day`'s string-encoding).
  Future<void> writeDailyTime(int hour, int minute) => _settings.setString(
    ReminderConfig.dailyTimeKey,
    '${_twoDigits(hour)}:${_twoDigits(minute)}',
  );

  /// Persists the recurring-due flag (`"1"`/`"0"`).
  Future<void> writeRecurring({required bool enabled}) => _settings.setString(
    ReminderConfig.recurringEnabledKey,
    enabled ? '1' : '0',
  );

  /// Persists the budget-warning flag (`"1"`/`"0"`).
  Future<void> writeBudget({required bool enabled}) =>
      _settings.setString(ReminderConfig.budgetEnabledKey, enabled ? '1' : '0');

  /// Whether the `{budgetId, period, level}` crossing behind [markerKey] has
  /// already fired this period (the dedupe probe for `CheckBudgetWarnings`).
  Future<bool> isWarned(String markerKey) async =>
      (await _settings.getString(markerKey)) == '1';

  /// Marks [markerKey] warned so the same crossing never re-fires this period.
  /// The marker self-scopes to the period key, so it resets when the cycle rolls.
  Future<void> markWarned(String markerKey) =>
      _settings.setString(markerKey, '1');

  /// The budget cycle start-day (`AppSettingsCubit`'s key) — feeds
  /// `BudgetCycle.range` so the warning check reads the same current period the
  /// app does. Unset / unparseable → 1 (the calendar-month default).
  Future<int> readBudgetCycleStartDay() async =>
      int.tryParse(await _settings.getString(_cycleStartDayKey) ?? '') ?? 1;

  /// The persisted locale code (`AppSettingsCubit`'s key) for notification copy;
  /// `null` / `'system'` → the service falls back to Indonesian.
  Future<String?> readLocaleCode() => _settings.getString(_localeKey);

  /// `"HH:mm"` → `(hour, minute)`; unset / malformed → the [ReminderConfig]
  /// default (20:00), keeping that default in exactly one place.
  (int, int) _parseTime(String? raw) {
    const fallback = ReminderConfig();
    final parts = raw?.split(':');
    if (parts == null || parts.length != 2) {
      return (fallback.dailyHour, fallback.dailyMinute);
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return (fallback.dailyHour, fallback.dailyMinute);
    }
    return (hour, minute);
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
