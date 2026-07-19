import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:jaga_saku/features/security/domain/entities/pin_check.dart';
import 'package:jaga_saku/features/security/pages/lock/lock_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// The unlock state machine: ok → unlocked (+ AppLockService.unlock), wrong →
/// error (pad cleared), lockedOut → cooldown, biometric-unavailable → PIN
/// fallback, and the verifying concurrency guard.
void main() {
  setUpAll(registerFallbackValues);

  late MockVerifyPin verifyPin;
  late MockAuthenticateBiometric authBiometric;
  late MockAppLockService appLock;
  late DateTime clockNow;

  LockCubit build({LockConfig config = const LockConfig()}) => LockCubit(
    verifyPin: verifyPin,
    authenticateBiometric: authBiometric,
    appLock: appLock,
    config: config,
    biometricReason: 'reason',
    now: () => clockNow,
  );

  setUp(() {
    verifyPin = MockVerifyPin();
    authBiometric = MockAuthenticateBiometric();
    appLock = MockAppLockService();
    clockNow = DateTime.fromMillisecondsSinceEpoch(1000000);
    when(() => appLock.unlock()).thenReturn(null);
    stubDuringAuthPrompt(appLock);
  });

  Future<void> enter(LockCubit cubit, String pin) async {
    for (final digit in pin.split('')) {
      cubit.addDigit(digit);
    }
    await pumpEventQueue();
  }

  test('correct PIN unlocks and flips AppLockService.unlock', () async {
    when(
      () => verifyPin(any()),
    ).thenAnswer((_) async => const Right(PinCheck.ok()));
    final cubit = build();
    addTearDown(cubit.close);

    await enter(cubit, '123456');

    expect(cubit.state, const LockState.unlocked());
    verify(() => appLock.unlock()).called(1);
  });

  test('a wrong PIN rests in error with the pad cleared', () async {
    when(
      () => verifyPin(any()),
    ).thenAnswer((_) async => const Right(PinCheck.wrong(failedAttempts: 1)));
    final cubit = build();
    addTearDown(cubit.close);

    await enter(cubit, '000000');

    expect(cubit.state, const LockState.error(failedAttempts: 1));
    verifyNever(() => appLock.unlock());
  });

  test('lockedOut moves to a cooldown countdown and blocks entry', () async {
    final until = clockNow.millisecondsSinceEpoch + 30000;
    when(() => verifyPin(any())).thenAnswer(
      (_) async => Right(PinCheck.lockedOut(cooldownUntilMs: until)),
    );
    final cubit = build();
    addTearDown(cubit.close);

    await enter(cubit, '123456');

    expect(
      cubit.state,
      isA<LockCooldown>().having((c) => c.remainingSeconds, 'remaining', 30),
    );
    // Digits are ignored while cooling down.
    cubit.addDigit('9');
    expect(cubit.state, isA<LockCooldown>());
  });

  test('biometric unavailable → stays on PIN (no unlock)', () async {
    when(
      () => authBiometric(any()),
    ).thenAnswer((_) async => const Right(false));
    final cubit = build(
      config: const LockConfig(isPinEnabled: true, isBiometricEnabled: true),
    );
    addTearDown(cubit.close);
    await pumpEventQueue(); // let the auto-prompt resolve

    expect(cubit.state, isA<LockInput>());
    verifyNever(() => appLock.unlock());
  });

  test('biometric success auto-unlocks on open', () async {
    when(() => authBiometric(any())).thenAnswer((_) async => const Right(true));
    final cubit = build(
      config: const LockConfig(isPinEnabled: true, isBiometricEnabled: true),
    );
    addTearDown(cubit.close);
    await pumpEventQueue();

    expect(cubit.state, const LockState.unlocked());
    verify(() => appLock.unlock()).called(1);
  });

  test('entry is ignored while verifying (concurrency guard)', () async {
    final completer = Completer<Either<Failure, PinCheck>>();
    when(() => verifyPin(any())).thenAnswer((_) => completer.future);
    final cubit = build();
    addTearDown(cubit.close);

    await enter(cubit, '123456');
    expect(cubit.state, const LockState.verifying());
    cubit.addDigit('9'); // ignored while verifying
    expect(cubit.state, const LockState.verifying());

    completer.complete(const Right(PinCheck.ok()));
    await pumpEventQueue();
    expect(cubit.state, const LockState.unlocked());
  });
}
