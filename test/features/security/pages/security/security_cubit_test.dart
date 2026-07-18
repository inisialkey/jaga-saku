import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/features/security/domain/entities/auto_lock_duration.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:jaga_saku/features/security/pages/security/security_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// Config load, the biometric enable / cancel / disable outcomes, and auto-lock
/// duration reflected from the AppLockService (the source of truth).
void main() {
  setUpAll(registerFallbackValues);

  late MockGetLockConfig getLockConfig;
  late MockIsBiometricAvailable isBiometricAvailable;
  late MockSetBiometricEnabled setBiometricEnabled;
  late MockSetAutoLockDuration setAutoLockDuration;
  late MockAppLockService appLock;

  SecurityCubit build() => SecurityCubit(
    getLockConfig: getLockConfig,
    isBiometricAvailable: isBiometricAvailable,
    setBiometricEnabled: setBiometricEnabled,
    setAutoLockDuration: setAutoLockDuration,
    appLock: appLock,
  );

  setUp(() {
    getLockConfig = MockGetLockConfig();
    isBiometricAvailable = MockIsBiometricAvailable();
    setBiometricEnabled = MockSetBiometricEnabled();
    setAutoLockDuration = MockSetAutoLockDuration();
    appLock = MockAppLockService();
    when(() => appLock.refreshConfig()).thenAnswer((_) async {});
  });

  test('load reads config + biometric availability', () async {
    when(
      () => getLockConfig(any()),
    ).thenAnswer((_) async => const Right(LockConfig(isPinEnabled: true)));
    when(
      () => isBiometricAvailable(any()),
    ).thenAnswer((_) async => const Right(true));
    final cubit = build();
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state.config, const LockConfig(isPinEnabled: true));
    expect(cubit.state.biometricAvailable, isTrue);
  });

  test('enabling biometric returns enabled and reflects the config', () async {
    when(
      () => setBiometricEnabled(any()),
    ).thenAnswer((_) async => const Right(true));
    when(() => appLock.config).thenReturn(
      const LockConfig(isPinEnabled: true, isBiometricEnabled: true),
    );
    final cubit = build();
    addTearDown(cubit.close);

    final result = await cubit.toggleBiometric(enabled: true, reason: 'r');

    expect(result, BiometricToggleResult.enabled);
    expect(cubit.state.config.isBiometricEnabled, isTrue);
  });

  test('a cancelled biometric enable returns cancelled', () async {
    when(
      () => setBiometricEnabled(any()),
    ).thenAnswer((_) async => const Right(false));
    when(() => appLock.config).thenReturn(const LockConfig(isPinEnabled: true));
    final cubit = build();
    addTearDown(cubit.close);

    final result = await cubit.toggleBiometric(enabled: true, reason: 'r');

    expect(result, BiometricToggleResult.cancelled);
  });

  test('disabling biometric returns disabled', () async {
    when(
      () => setBiometricEnabled(any()),
    ).thenAnswer((_) async => const Right(false));
    when(() => appLock.config).thenReturn(const LockConfig(isPinEnabled: true));
    final cubit = build();
    addTearDown(cubit.close);

    final result = await cubit.toggleBiometric(enabled: false, reason: 'r');

    expect(result, BiometricToggleResult.disabled);
  });

  test('setAutoLockDuration reflects the persisted config', () async {
    when(
      () => setAutoLockDuration(any()),
    ).thenAnswer((_) async => const Right(unit));
    when(() => appLock.config).thenReturn(
      const LockConfig(
        isPinEnabled: true,
        autoLockDuration: AutoLockDuration.fiveMinutes,
      ),
    );
    final cubit = build();
    addTearDown(cubit.close);

    await cubit.setAutoLockDuration(AutoLockDuration.fiveMinutes);

    expect(cubit.state.config.autoLockDuration, AutoLockDuration.fiveMinutes);
  });
}
