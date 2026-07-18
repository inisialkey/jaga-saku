import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/reminders/data/reminder_local_datasource.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_config.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

/// [ReminderLocalDatasource]: settings-kv round-trip for the config, the daily
/// time "HH:mm" encoding, the budget-warning markers and the read-only
/// cycle-start / locale probes. Backed by a mocked [MockSettingsService].
void main() {
  late MockSettingsService settings;
  late ReminderLocalDatasource datasource;

  setUp(() {
    settings = MockSettingsService();
    datasource = ReminderLocalDatasource(settings);
    when(() => settings.setString(any(), any())).thenAnswer((_) async {});
  });

  void seed(Map<String, String?> values) {
    when(() => settings.getString(any())).thenAnswer(
      (invocation) async => values[invocation.positionalArguments[0]],
    );
  }

  group('readConfig', () {
    test('unset keys → all-off defaults at 20:00', () async {
      seed(const {});
      final config = await datasource.readConfig();
      expect(config, const ReminderConfig());
    });

    test('seeded keys → parsed config incl. HH:mm time', () async {
      seed({
        ReminderConfig.dailyEnabledKey: '1',
        ReminderConfig.dailyTimeKey: '07:05',
        ReminderConfig.recurringEnabledKey: '1',
        ReminderConfig.budgetEnabledKey: '0',
      });
      final config = await datasource.readConfig();
      expect(config.dailyEnabled, isTrue);
      expect(config.dailyHour, 7);
      expect(config.dailyMinute, 5);
      expect(config.recurringDueEnabled, isTrue);
      expect(config.budgetWarningEnabled, isFalse);
    });

    test('malformed time → falls back to the 20:00 default', () async {
      seed({ReminderConfig.dailyTimeKey: 'not-a-time'});
      final config = await datasource.readConfig();
      expect(config.dailyHour, 20);
      expect(config.dailyMinute, 0);
    });
  });

  group('writes', () {
    test('writeDaily(false) persists "0"', () async {
      await datasource.writeDaily(enabled: false);
      verify(
        () => settings.setString(ReminderConfig.dailyEnabledKey, '0'),
      ).called(1);
    });

    test('writeDailyTime zero-pads to "HH:mm"', () async {
      await datasource.writeDailyTime(7, 5);
      verify(
        () => settings.setString(ReminderConfig.dailyTimeKey, '07:05'),
      ).called(1);
    });

    test('writeRecurring(true) persists "1"', () async {
      await datasource.writeRecurring(enabled: true);
      verify(
        () => settings.setString(ReminderConfig.recurringEnabledKey, '1'),
      ).called(1);
    });

    test('writeBudget(true) persists "1"', () async {
      await datasource.writeBudget(enabled: true);
      verify(
        () => settings.setString(ReminderConfig.budgetEnabledKey, '1'),
      ).called(1);
    });
  });

  group('markers', () {
    test('isWarned reflects the stored flag', () async {
      seed({'reminder_budget_warned_1_2026-07_critical': '1'});
      expect(
        await datasource.isWarned('reminder_budget_warned_1_2026-07_critical'),
        isTrue,
      );
      expect(
        await datasource.isWarned('reminder_budget_warned_9_x_safe'),
        isFalse,
      );
    });

    test('markWarned writes "1"', () async {
      await datasource.markWarned('reminder_budget_warned_1_2026-07_warning');
      verify(
        () =>
            settings.setString('reminder_budget_warned_1_2026-07_warning', '1'),
      ).called(1);
    });
  });

  group('read-only cross-feature probes', () {
    test('readBudgetCycleStartDay defaults to 1 when unset', () async {
      seed(const {});
      expect(await datasource.readBudgetCycleStartDay(), 1);
    });

    test('readBudgetCycleStartDay parses the stored day', () async {
      seed({'budget_cycle_start_day': '15'});
      expect(await datasource.readBudgetCycleStartDay(), 15);
    });

    test('readLocaleCode returns the stored locale', () async {
      seed({'locale': 'en'});
      expect(await datasource.readLocaleCode(), 'en');
    });
  });
}
