import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/security/data/repositories/security_repository_impl.dart';
import 'package:jaga_saku/features/security/domain/entities/auto_lock_duration.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:jaga_saku/features/security/domain/entities/pin_check.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// Proves the repo never throws (Rule 4 → Left(CacheFailure)), passes a
/// [PinCheck] through untouched, and gates enabling biometric on a live
/// confirmation.
void main() {
  setUpAll(registerFallbackValues);

  late MockPinSecureDatasource pin;
  late MockBiometricAuthDatasource biometric;
  late SecurityRepositoryImpl repo;

  setUp(() {
    pin = MockPinSecureDatasource();
    biometric = MockBiometricAuthDatasource();
    repo = SecurityRepositoryImpl(pin, biometric);
  });

  test('loadConfig returns Right(config) on success', () async {
    when(
      () => pin.loadConfig(),
    ).thenAnswer((_) async => const LockConfig(isPinEnabled: true));

    final result = await repo.loadConfig();

    expect(
      result.getRight().toNullable(),
      const LockConfig(isPinEnabled: true),
    );
  });

  test(
    'a thrown datasource error maps to Left(CacheFailure) — never throws',
    () async {
      when(() => pin.loadConfig()).thenThrow(Exception('boom'));

      final result = await repo.loadConfig();

      expect(result.getLeft().toNullable(), const CacheFailure());
    },
  );

  test('verifyPin passes the PinCheck through as Right', () async {
    const check = PinCheck.wrong(failedAttempts: 3, cooldownUntilMs: 999);
    when(() => pin.verify(any())).thenAnswer((_) async => check);

    final result = await repo.verifyPin('000000');

    expect(result.getRight().toNullable(), check);
  });

  test('setPin delegates and returns Right(unit)', () async {
    when(() => pin.setPin(any())).thenAnswer((_) async {});

    final result = await repo.setPin('123456');

    expect(result.isRight(), isTrue);
    verify(() => pin.setPin('123456')).called(1);
  });

  test(
    'enabling biometric requires a live confirmation, then persists',
    () async {
      when(() => biometric.authenticate(any())).thenAnswer((_) async => true);
      when(
        () => pin.setBiometricEnabled(enabled: any(named: 'enabled')),
      ).thenAnswer((_) async {});

      final result = await repo.setBiometricEnabled(enabled: true, reason: 'x');

      expect(result.getRight().toNullable(), isTrue);
      verify(() => pin.setBiometricEnabled(enabled: true)).called(1);
    },
  );

  test(
    'a cancelled confirmation leaves biometric OFF and never persists',
    () async {
      when(() => biometric.authenticate(any())).thenAnswer((_) async => false);

      final result = await repo.setBiometricEnabled(enabled: true, reason: 'x');

      expect(result.getRight().toNullable(), isFalse);
      verifyNever(
        () => pin.setBiometricEnabled(enabled: any(named: 'enabled')),
      );
    },
  );

  test('disabling biometric does not prompt', () async {
    when(
      () => pin.setBiometricEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async {});

    final result = await repo.setBiometricEnabled(enabled: false, reason: 'x');

    expect(result.getRight().toNullable(), isFalse);
    verifyNever(() => biometric.authenticate(any()));
    verify(() => pin.setBiometricEnabled(enabled: false)).called(1);
  });

  test('setAutoLockDuration delegates and returns Right(unit)', () async {
    when(() => pin.setAutoLockDuration(any())).thenAnswer((_) async {});

    final result = await repo.setAutoLockDuration(AutoLockDuration.oneMinute);

    expect(result.isRight(), isTrue);
    verify(() => pin.setAutoLockDuration(AutoLockDuration.oneMinute)).called(1);
  });
}
