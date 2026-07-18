import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/security/app_lock_service.dart';
import 'package:jaga_saku/features/security/domain/entities/auto_lock_duration.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

/// Cold-start lock decision, the Left→usable fail-safe, and the auto-lock
/// elapsed-time rule under a fake clock (no MethodChannel, no real time).
void main() {
  setUpAll(registerFallbackValues);

  late MockGetLockConfig getLockConfig;
  late DateTime clockNow;

  AppLockService build() =>
      AppLockService(getLockConfig: getLockConfig, now: () => clockNow);

  void stubConfig(LockConfig config) =>
      when(() => getLockConfig(any())).thenAnswer((_) async => Right(config));

  setUp(() {
    getLockConfig = MockGetLockConfig();
    clockNow = DateTime.fromMillisecondsSinceEpoch(1000000);
  });

  test('load with a PIN starts locked and notifies', () async {
    stubConfig(const LockConfig(isPinEnabled: true));
    final service = build();
    var notified = 0;
    service.addListener(() => notified++);

    await service.load();

    expect(service.isPinEnabled, isTrue);
    expect(service.isLocked, isTrue);
    expect(notified, 1);
  });

  test('load with no PIN stays unlocked', () async {
    stubConfig(const LockConfig());
    final service = build();

    await service.load();

    expect(service.isLocked, isFalse);
  });

  test('load on a Left keeps the app usable (unlocked)', () async {
    when(
      () => getLockConfig(any()),
    ).thenAnswer((_) async => const Left(CacheFailure()));
    final service = build();

    await service.load();

    expect(service.isPinEnabled, isFalse);
    expect(service.isLocked, isFalse);
  });

  test('auto-lock immediately: any background locks on resume', () async {
    stubConfig(const LockConfig(isPinEnabled: true));
    final service = build();
    await service.load();
    service.unlock();
    expect(service.isLocked, isFalse);

    service.markBackgrounded();
    service.evaluateAutoLock();

    expect(service.isLocked, isTrue);
  });

  test(
    'auto-lock 1m: locks only once the elapsed background time passes',
    () async {
      stubConfig(
        const LockConfig(
          isPinEnabled: true,
          autoLockDuration: AutoLockDuration.oneMinute,
        ),
      );
      final service = build();
      await service.load();
      service.unlock();
      service.markBackgrounded();

      clockNow = clockNow.add(const Duration(seconds: 30));
      service.evaluateAutoLock();
      expect(service.isLocked, isFalse); // still under a minute

      clockNow = clockNow.add(const Duration(seconds: 31));
      service.evaluateAutoLock();
      expect(service.isLocked, isTrue); // past a minute
    },
  );

  test('no auto-lock when no PIN, however long the background', () async {
    stubConfig(const LockConfig());
    final service = build();
    await service.load();
    service.markBackgrounded();

    clockNow = clockNow.add(const Duration(hours: 1));
    service.evaluateAutoLock();

    expect(service.isLocked, isFalse);
  });

  test('unlock clears locked and notifies', () async {
    stubConfig(const LockConfig(isPinEnabled: true));
    final service = build();
    await service.load();
    expect(service.isLocked, isTrue);
    var notified = 0;
    service.addListener(() => notified++);

    service.unlock();

    expect(service.isLocked, isFalse);
    expect(notified, 1);
  });
}
