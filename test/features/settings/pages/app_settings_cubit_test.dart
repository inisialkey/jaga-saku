import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/settings/pages/app_settings_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

/// [AppSettingsCubit] over a mocked [SettingsService]: `load` reads (and
/// defaults) the three persisted keys; each setter emits the new state AND
/// persists it under the right key/value.
void main() {
  late MockSettingsService settings;

  setUp(() {
    settings = MockSettingsService();
    when(() => settings.getString(any())).thenAnswer((_) async => null);
    when(() => settings.setString(any(), any())).thenAnswer((_) async {});
  });

  AppSettingsCubit build() => AppSettingsCubit(settings);

  group('load', () {
    test(
      'defaults to light theme, system locale and no name when unset',
      () async {
        final cubit = build();
        await cubit.load();

        expect(cubit.state.themeMode, ThemeMode.light);
        expect(cubit.state.locale, isNull);
        expect(cubit.state.userName, isNull);
        await cubit.close();
      },
    );

    test('reads the persisted theme, locale and name', () async {
      when(
        () => settings.getString('theme_mode'),
      ).thenAnswer((_) async => 'dark');
      when(() => settings.getString('locale')).thenAnswer((_) async => 'id');
      when(
        () => settings.getString('user_name'),
      ).thenAnswer((_) async => 'Oki');

      final cubit = build();
      await cubit.load();

      expect(cubit.state.themeMode, ThemeMode.dark);
      expect(cubit.state.locale, const Locale('id'));
      expect(cubit.state.userName, 'Oki');
      await cubit.close();
    });

    test('a stored "system" locale resolves to null (follow device)', () async {
      when(
        () => settings.getString('locale'),
      ).thenAnswer((_) async => 'system');

      final cubit = build();
      await cubit.load();

      expect(cubit.state.locale, isNull);
      await cubit.close();
    });

    test('treats a blank stored name as null (guest)', () async {
      when(
        () => settings.getString('user_name'),
      ).thenAnswer((_) async => '   ');

      final cubit = build();
      await cubit.load();

      expect(cubit.state.userName, isNull);
      await cubit.close();
    });
  });

  group('setThemeMode', () {
    blocTest<AppSettingsCubit, AppSettingsState>(
      'emits the new mode and persists it under theme_mode',
      build: build,
      act: (c) => c.setThemeMode(ThemeMode.dark),
      expect: () => [const AppSettingsState(themeMode: ThemeMode.dark)],
      verify: (_) =>
          verify(() => settings.setString('theme_mode', 'dark')).called(1),
    );
  });

  group('setLocale', () {
    blocTest<AppSettingsCubit, AppSettingsState>(
      'emits the locale and persists its language code',
      build: build,
      act: (c) => c.setLocale(const Locale('en')),
      expect: () => [const AppSettingsState(locale: Locale('en'))],
      verify: (_) => verify(() => settings.setString('locale', 'en')).called(1),
    );

    blocTest<AppSettingsCubit, AppSettingsState>(
      'a null locale (System) clears to null and persists "system"',
      build: build,
      seed: () => const AppSettingsState(locale: Locale('id')),
      act: (c) => c.setLocale(null),
      expect: () => [const AppSettingsState()],
      verify: (_) =>
          verify(() => settings.setString('locale', 'system')).called(1),
    );
  });

  group('setUserName', () {
    blocTest<AppSettingsCubit, AppSettingsState>(
      'emits the trimmed name and persists it under user_name',
      build: build,
      act: (c) => c.setUserName('  Budi  '),
      expect: () => [const AppSettingsState(userName: 'Budi')],
      verify: (_) =>
          verify(() => settings.setString('user_name', 'Budi')).called(1),
    );

    blocTest<AppSettingsCubit, AppSettingsState>(
      'a blank name clears to null (guest) and persists empty',
      build: build,
      seed: () => const AppSettingsState(userName: 'Budi'),
      act: (c) => c.setUserName('   '),
      expect: () => [const AppSettingsState()],
      verify: (_) =>
          verify(() => settings.setString('user_name', '')).called(1),
    );
  });
}
