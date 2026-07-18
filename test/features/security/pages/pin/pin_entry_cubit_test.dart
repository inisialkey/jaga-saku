import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/features/security/domain/entities/pin_check.dart';
import 'package:jaga_saku/features/security/pages/pin/pin_entry_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// The create / change / disable machine: a matching confirm persists, a
/// mismatch restarts WITHOUT persisting, and verify-current gates change /
/// disable.
void main() {
  setUpAll(registerFallbackValues);

  late MockSetPin setPin;
  late MockChangePin changePin;
  late MockDisablePin disablePin;
  late MockVerifyPin verifyPin;
  late MockAppLockService appLock;

  PinEntryCubit build(PinEntryPurpose purpose) => PinEntryCubit(
    purpose: purpose,
    setPin: setPin,
    changePin: changePin,
    disablePin: disablePin,
    verifyPin: verifyPin,
    appLock: appLock,
  );

  setUp(() {
    setPin = MockSetPin();
    changePin = MockChangePin();
    disablePin = MockDisablePin();
    verifyPin = MockVerifyPin();
    appLock = MockAppLockService();
    when(() => appLock.refreshConfig()).thenAnswer((_) async {});
  });

  Future<void> enter(PinEntryCubit cubit, String pin) async {
    for (final digit in pin.split('')) {
      cubit.addDigit(digit);
    }
    await pumpEventQueue();
  }

  test(
    'create: entering then matching the confirm sets the PIN and finishes',
    () async {
      when(() => setPin(any())).thenAnswer((_) async => const Right(unit));
      final cubit = build(PinEntryPurpose.create);
      addTearDown(cubit.close);

      await enter(cubit, '123456');
      expect(cubit.state, isA<PinEntryConfirm>());

      await enter(cubit, '123456');

      expect(cubit.state, const PinEntryState.done());
      verify(() => setPin('123456')).called(1);
    },
  );

  test('create: a mismatch restarts at enterNew and NEVER persists', () async {
    final cubit = build(PinEntryPurpose.create);
    addTearDown(cubit.close);
    final states = <PinEntryState>[];
    final sub = cubit.stream.listen(states.add);

    await enter(cubit, '123456'); // → confirm
    await enter(cubit, '999999'); // mismatch
    await sub.cancel();

    expect(states.whereType<PinEntryMismatch>(), isNotEmpty);
    expect(cubit.state, isA<PinEntryEnterNew>());
    verifyNever(() => setPin(any()));
  });

  test('change: verify current, then set the new PIN, finishes done', () async {
    when(
      () => verifyPin(any()),
    ).thenAnswer((_) async => const Right(PinCheck.ok()));
    when(() => changePin(any())).thenAnswer((_) async => const Right(unit));
    final cubit = build(PinEntryPurpose.change);
    addTearDown(cubit.close);

    await enter(cubit, '111111'); // verify current → enterNew
    expect(cubit.state, isA<PinEntryEnterNew>());
    await enter(cubit, '123456'); // → confirm
    await enter(cubit, '123456'); // confirm → ChangePin → done

    expect(cubit.state, const PinEntryState.done());
    verify(() => changePin('123456')).called(1);
  });

  test('disable: a verified current PIN disables the lock', () async {
    when(
      () => verifyPin(any()),
    ).thenAnswer((_) async => const Right(PinCheck.ok()));
    when(() => disablePin(any())).thenAnswer((_) async => const Right(unit));
    final cubit = build(PinEntryPurpose.disable);
    addTearDown(cubit.close);

    await enter(cubit, '111111');

    expect(cubit.state, const PinEntryState.done());
    verify(() => disablePin(any())).called(1);
  });

  test('a wrong current PIN surfaces wrong and does not proceed', () async {
    when(
      () => verifyPin(any()),
    ).thenAnswer((_) async => const Right(PinCheck.wrong(failedAttempts: 1)));
    final cubit = build(PinEntryPurpose.disable);
    addTearDown(cubit.close);
    final states = <PinEntryState>[];
    final sub = cubit.stream.listen(states.add);

    await enter(cubit, '000000');
    await sub.cancel();

    expect(states.whereType<PinEntryWrong>(), isNotEmpty);
    expect(cubit.state, isA<PinEntryVerifyCurrent>());
    verifyNever(() => disablePin(any()));
  });
}
