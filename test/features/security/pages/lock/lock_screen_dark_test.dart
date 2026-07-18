import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:jaga_saku/features/security/pages/lock/lock_cubit.dart';
import 'package:jaga_saku/features/security/pages/lock/lock_screen.dart';
import 'package:jaga_saku/features/security/pages/widgets/pin_pad.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

/// Dark render evidence for the V3-M4 lock gate — the one full-bleed new screen
/// (not a card on a normal scaffold), so a dark background/text bug is most
/// visible here. Pumps the real [LockScreen] over a real [LockCubit] (mocked
/// deps, default off config → resting `LockState.input`, no biometric
/// auto-prompt) under [AppTheme.dark] and asserts it builds — the shield header,
/// prompt text and PIN pad render on the dark full-bleed surface with no
/// exception. The PIN pad itself is also covered as a leaf in
/// `dark_mode_smoke_test.dart`.
void main() {
  late MockVerifyPin verifyPin;
  late MockAuthenticateBiometric authBiometric;
  late MockAppLockService appLock;

  LockCubit build() => LockCubit(
    verifyPin: verifyPin,
    authenticateBiometric: authBiometric,
    appLock: appLock,
    config: const LockConfig(),
    biometricReason: 'reason',
  );

  setUp(() {
    verifyPin = MockVerifyPin();
    authBiometric = MockAuthenticateBiometric();
    appLock = MockAppLockService();
  });

  testWidgets('LockScreen renders under AppTheme.dark', (tester) async {
    final cubit = build();
    addTearDown(cubit.close);

    await pumpApp(
      tester,
      BlocProvider<LockCubit>.value(value: cubit, child: const LockScreen()),
      theme: AppTheme.dark,
      scaffold: false,
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(PinPad), findsOneWidget);
  });
}
