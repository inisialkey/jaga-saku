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

  // Regression: refreshConfig notifying made go_router re-parse the stack from
  // the encoded route state, dropping the non-JSON `extra` — enabling a PIN
  // nulled out /pin-entry's own PinEntryArgs and crashed on `state.extra!`.
  test('refreshConfig updates config without notifying the router', () async {
    stubConfig(const LockConfig());
    final service = build();
    await service.load();
    var notified = 0;
    service.addListener(() => notified++);

    stubConfig(const LockConfig(isPinEnabled: true));
    await service.refreshConfig();

    expect(service.isPinEnabled, isTrue);
    expect(service.isLocked, isFalse);
    expect(notified, 0);
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

      // One background cycle under the threshold.
      service.markBackgrounded();
      clockNow = clockNow.add(const Duration(seconds: 30));
      service.evaluateAutoLock();
      expect(service.isLocked, isFalse); // still under a minute

      // A second, longer one.
      service.markBackgrounded();
      clockNow = clockNow.add(const Duration(seconds: 61));
      service.evaluateAutoLock();
      expect(service.isLocked, isTrue); // past a minute
    },
  );

  // Regression: `elapsed` fell back to 0 when nothing had stamped a background,
  // and 0 >= Duration.zero (`immediately`) re-locked on any stray resume — the
  // biometric prompt dismissing re-locked the app it had just unlocked.
  test('a resume with no matching background never locks', () async {
    stubConfig(const LockConfig(isPinEnabled: true));
    final service = build();
    await service.load();
    service.unlock();

    service.evaluateAutoLock();

    expect(service.isLocked, isFalse);
  });

  test(
    'a resume consumes its stamp — the next stray resume is inert',
    () async {
      stubConfig(
        const LockConfig(
          isPinEnabled: true,
          autoLockDuration: AutoLockDuration.fiveMinutes,
        ),
      );
      final service = build();
      await service.load();
      service.unlock();
      service.markBackgrounded();

      clockNow = clockNow.add(const Duration(seconds: 10));
      service.evaluateAutoLock();
      expect(service.isLocked, isFalse); // under five minutes

      clockNow = clockNow.add(const Duration(minutes: 10));
      service.evaluateAutoLock(); // stray resume, no background in between
      expect(service.isLocked, isFalse);
    },
  );

  test('duringAuthPrompt suppresses the background the sheet causes', () async {
    stubConfig(const LockConfig(isPinEnabled: true));
    final service = build();
    await service.load();
    service.unlock();

    // Android backgrounds the app to show the biometric sheet, then resumes.
    await service.duringAuthPrompt(() async {
      service.markBackgrounded();
      clockNow = clockNow.add(const Duration(seconds: 3));
    });
    service.evaluateAutoLock();

    expect(service.isLocked, isFalse);
  });

  test(
    'duringAuthPrompt still clears the stamp when the action throws',
    () async {
      stubConfig(const LockConfig(isPinEnabled: true));
      final service = build();
      await service.load();
      service.unlock();

      await expectLater(
        service.duringAuthPrompt(() async => throw const CacheFailure()),
        throwsA(isA<CacheFailure>()),
      );
      service.markBackgrounded();
      service.evaluateAutoLock();

      expect(
        service.isLocked,
        isTrue,
      ); // suppression lifted, auto-lock works again
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
