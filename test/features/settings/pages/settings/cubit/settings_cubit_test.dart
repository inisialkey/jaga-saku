import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/settings/settings.dart';
import 'package:jaga_saku/core/utils/utils.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../../helpers/fake_path_provider_platform.dart';

void main() {
  late SettingsCubit settingsCubit;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(isUnitTest: true, prefixBox: 'settings_cubit_test_');
    settingsCubit = sl<SettingsCubit>();
  });

  blocTest<SettingsCubit, SettingsState>(
    'The theme should be system',
    build: () => settingsCubit,
    act: (cubit) => cubit.updateTheme(ActiveTheme.system),
    expect: () => [isA<SettingsStateLoaded>()],
  );

  blocTest<SettingsCubit, SettingsState>(
    'The language should be updated',
    build: () => settingsCubit,
    act: (cubit) => cubit.updateLanguage('en'),
    expect: () => [isA<SettingsStateLoaded>()],
  );

  blocTest<SettingsCubit, SettingsState>(
    'loadSettings emits loaded state with defaults',
    build: () => settingsCubit,
    act: (cubit) => cubit.loadSettings(),
    expect: () => [
      isA<SettingsStateLoaded>()
          .having((s) => s.locale, 'locale', 'en')
          .having((s) => s.activeTheme, 'activeTheme', ActiveTheme.system),
    ],
  );
}
