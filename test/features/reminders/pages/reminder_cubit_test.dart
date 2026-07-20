import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_config.dart';
import 'package:jaga_saku/features/reminders/pages/reminder_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

/// [ReminderCubit]: load seeds from the config; a toggle-on requests permission
/// (granted → persist + reschedule + emit; denied → permissionDenied, no
/// persist); toggle-off skips the prompt; setDailyTime persists + emits.
void main() {
  late MockReminderLocalDatasource datasource;
  late MockReminderService service;

  setUpAll(registerFallbackValues);

  setUp(() {
    datasource = MockReminderLocalDatasource();
    service = MockReminderService();
    when(
      () => datasource.readConfig(),
    ).thenAnswer((_) async => const ReminderConfig());
    when(
      () => datasource.writeDaily(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async {});
    when(
      () => datasource.writeRecurring(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async {});
    when(
      () => datasource.writeBudget(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async {});
    when(
      () => datasource.writeDailyTime(any(), any()),
    ).thenAnswer((_) async {});
    when(() => service.reconcile()).thenAnswer((_) async {});
    when(() => service.recomputeBudgetWarnings()).thenAnswer((_) async {});
    when(() => service.requestPermission()).thenAnswer((_) async => true);
  });

  ReminderCubit build() =>
      ReminderCubit(reminderDatasource: datasource, reminderService: service);

  blocTest<ReminderCubit, ReminderState>(
    'load seeds the switches + daily time from the persisted config',
    setUp: () => when(() => datasource.readConfig()).thenAnswer(
      (_) async => const ReminderConfig(
        dailyEnabled: true,
        dailyHour: 7,
        dailyMinute: 30,
        recurringDueEnabled: true,
      ),
    ),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      ReminderState(
        dailyEnabled: true,
        dailyHour: 7,
        dailyMinute: 30,
        recurringDueEnabled: true,
      ),
    ],
  );

  blocTest<ReminderCubit, ReminderState>(
    'toggleDaily on + granted → persists, reschedules, emits enabled',
    build: build,
    act: (cubit) => cubit.toggleDaily(enabled: true),
    expect: () => const [ReminderState(dailyEnabled: true)],
    verify: (_) {
      verify(() => service.requestPermission()).called(1);
      verify(() => datasource.writeDaily(enabled: true)).called(1);
      verify(() => service.reconcile()).called(1);
    },
  );

  blocTest<ReminderCubit, ReminderState>(
    'toggleDaily on + denied → permissionDenied, stays off, no persist',
    setUp: () =>
        when(() => service.requestPermission()).thenAnswer((_) async => false),
    build: build,
    act: (cubit) => cubit.toggleDaily(enabled: true),
    expect: () => const [ReminderState(permissionDenied: true)],
    verify: (_) {
      verifyNever(() => datasource.writeDaily(enabled: any(named: 'enabled')));
      verifyNever(() => service.reconcile());
    },
  );

  blocTest<ReminderCubit, ReminderState>(
    'toggleDaily off → cancels without requesting permission',
    build: build,
    seed: () => const ReminderState(dailyEnabled: true),
    act: (cubit) => cubit.toggleDaily(enabled: false),
    expect: () => const [ReminderState()],
    verify: (_) {
      verifyNever(() => service.requestPermission());
      verify(() => datasource.writeDaily(enabled: false)).called(1);
      verify(() => service.reconcile()).called(1);
    },
  );

  blocTest<ReminderCubit, ReminderState>(
    'setDailyTime persists "HH:mm" + emits the new time',
    build: build,
    act: (cubit) => cubit.setDailyTime(7, 30),
    expect: () => const [ReminderState(dailyHour: 7, dailyMinute: 30)],
    verify: (_) {
      verify(() => datasource.writeDailyTime(7, 30)).called(1);
      verify(() => service.reconcile()).called(1);
    },
  );
}
