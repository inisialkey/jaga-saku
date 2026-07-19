import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/security/data/datasources/pin_secure_datasource.dart';
import 'package:jaga_saku/features/security/domain/entities/pin_check.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// [PinSecureDatasource] over mocked secure storage + settings, each backed by a
/// real in-memory Map so persistence is genuine — the force-kill test relaunches
/// a brand-new datasource over the SAME stores and must still see the cooldown.
/// A fake clock drives all backoff timing (no MethodChannel, no real time).
void main() {
  late MockSecureStorageService secure;
  late MockSettingsService settings;
  late Map<String, String> secureStore;
  late Map<String, String> settingsStore;
  late DateTime clockNow;

  PinSecureDatasource build() => PinSecureDatasource(
    secure: secure,
    settings: settings,
    now: () => clockNow,
  );

  setUp(() {
    secure = MockSecureStorageService();
    settings = MockSettingsService();
    secureStore = {};
    settingsStore = {};
    clockNow = DateTime.fromMillisecondsSinceEpoch(1000000);

    when(
      () => secure.read(any()),
    ).thenAnswer((i) async => secureStore[i.positionalArguments[0] as String]);
    when(() => secure.write(any(), any())).thenAnswer((i) async {
      secureStore[i.positionalArguments[0] as String] =
          i.positionalArguments[1] as String;
    });
    when(() => secure.delete(any())).thenAnswer((i) async {
      secureStore.remove(i.positionalArguments[0] as String);
    });
    when(() => secure.containsKey(any())).thenAnswer(
      (i) async => secureStore.containsKey(i.positionalArguments[0] as String),
    );

    when(() => settings.getString(any())).thenAnswer(
      (i) async => settingsStore[i.positionalArguments[0] as String],
    );
    when(() => settings.setString(any(), any())).thenAnswer((i) async {
      settingsStore[i.positionalArguments[0] as String] =
          i.positionalArguments[1] as String;
    });
    when(() => settings.remove(any())).thenAnswer((i) async {
      settingsStore.remove(i.positionalArguments[0] as String);
    });
  });

  test(
    'setPin stores salt+hash (never plaintext) and enables the lock',
    () async {
      await build().setPin('123456');

      expect(secureStore.containsKey('pin_hash'), isTrue);
      expect(secureStore.containsKey('pin_salt'), isTrue);
      expect(secureStore['pin_hash'], isNot('123456'));
      expect(settingsStore['lock_pin_enabled'], '1');
      expect(settingsStore['lock_failed_attempts'], '0');
    },
  );

  test('verify returns ok for the correct PIN and clears attempts', () async {
    final ds = build();
    await ds.setPin('123456');
    settingsStore['lock_failed_attempts'] = '2';

    expect(await ds.verify('123456'), const PinCheck.ok());
    expect(settingsStore['lock_failed_attempts'], '0');
  });

  test('the first two wrong PINs bump attempts but arm no cooldown', () async {
    final ds = build();
    await ds.setPin('123456');

    expect(await ds.verify('000000'), const PinCheck.wrong(failedAttempts: 1));
    expect(settingsStore.containsKey('lock_locked_until'), isFalse);
    expect(await ds.verify('000000'), const PinCheck.wrong(failedAttempts: 2));
    expect(settingsStore.containsKey('lock_locked_until'), isFalse);
  });

  test('the third wrong PIN arms a 30s cooldown', () async {
    final ds = build();
    await ds.setPin('123456');
    settingsStore['lock_failed_attempts'] = '2';

    final result = await ds.verify('000000');

    expect(
      result,
      isA<PinCheckWrong>().having((w) => w.failedAttempts, 'attempts', 3),
    );
    expect(
      int.parse(settingsStore['lock_locked_until']!),
      clockNow.millisecondsSinceEpoch + 30000,
    );
  });

  test(
    'verify during cooldown returns lockedOut WITHOUT a hash compare',
    () async {
      final ds = build();
      await ds.setPin('123456');
      settingsStore['lock_locked_until'] =
          '${clockNow.millisecondsSinceEpoch + 30000}';
      clearInteractions(secure);

      // Even the CORRECT PIN is refused while cooling down.
      expect(await ds.verify('123456'), isA<PinCheckLockedOut>());
      verifyNever(() => secure.read(any()));
    },
  );

  test(
    'a persisted cooldown survives a fresh datasource (force-kill)',
    () async {
      await build().setPin('123456');
      settingsStore['lock_locked_until'] =
          '${clockNow.millisecondsSinceEpoch + 60000}';

      // Relaunch: a brand-new datasource over the same persisted stores.
      expect(await build().verify('123456'), isA<PinCheckLockedOut>());
    },
  );

  test('cooldown lifts once the clock passes locked-until', () async {
    final ds = build();
    await ds.setPin('123456');
    settingsStore['lock_failed_attempts'] = '3';
    settingsStore['lock_locked_until'] =
        '${clockNow.millisecondsSinceEpoch + 30000}';

    clockNow = clockNow.add(const Duration(seconds: 31));

    expect(await ds.verify('123456'), const PinCheck.ok());
  });

  test(
    'loadConfig fail-safe: enabled flag with no stored hash → disabled',
    () async {
      settingsStore['lock_pin_enabled'] = '1'; // flag says on...
      // ...but secureStore has NO pin_hash (keystore reset / restore).

      final config = await build().loadConfig();

      expect(config.isPinEnabled, isFalse);
      expect(config.isBiometricEnabled, isFalse);
    },
  );

  // V4-M2: the restored backup is the source of truth for the lock flag. These
  // pin the direction the fail-safe test above does NOT cover — a restore that
  // turns the PIN OFF while the device keystore still holds a live hash.
  test('loadConfig flag-wins: disabled flag + a live stored hash → disabled '
      '(restore is source of truth)', () async {
    settingsStore['lock_pin_enabled'] = '0'; // restored backup says OFF...
    secureStore['pin_hash'] = 'live-hash'; // ...keystore hash survived restore
    secureStore['pin_salt'] = 'live-salt';

    final config = await build().loadConfig();

    expect(config.isPinEnabled, isFalse);
    expect(config.isBiometricEnabled, isFalse);
  });

  test(
    'a later setPin overwrites the orphaned hash (no stale secret survives)',
    () async {
      secureStore['pin_hash'] = 'orphan-hash';
      secureStore['pin_salt'] = 'orphan-salt';
      settingsStore['lock_pin_enabled'] = '0';

      final ds = build();
      await ds.setPin('654321');

      expect(secureStore['pin_hash'], isNot('orphan-hash'));
      expect(settingsStore['lock_pin_enabled'], '1');
      expect(await ds.verify('654321'), const PinCheck.ok());
    },
  );

  test('disable clears the secret and all flags', () async {
    final ds = build();
    await ds.setPin('123456');
    await ds.setBiometricEnabled(enabled: true);

    await ds.disable();

    expect(secureStore.containsKey('pin_hash'), isFalse);
    expect(secureStore.containsKey('pin_salt'), isFalse);
    expect(settingsStore['lock_pin_enabled'], '0');
    expect(settingsStore['lock_biometric_enabled'], '0');
  });
}
