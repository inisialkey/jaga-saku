import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/settings/settings.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../helpers/fake_path_provider_platform.dart';
import '../../../../helpers/mocks.dart';

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

void main() {
  late SettingsCubit settingsCubit;

  setUpAll(() {
    HttpOverrides.global = null;
    registerFallbackValue(ActiveTheme.light);
  });

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(isUnitTest: true, prefixBox: 'settings_page_test_');
    settingsCubit = MockSettingsCubit();
  });

  Widget rootWidget(Widget body) => BlocProvider<SettingsCubit>.value(
    value: settingsCubit,
    child: ScreenUtilInit(
      designSize: const Size(375, 667),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp(
        localizationsDelegates: const [
          Strings.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('en'),
        theme: themeLight(MockBuildContext()),
        home: body,
      ),
    ),
  );

  testWidgets('trigger update theme when switch toggled', (tester) async {
    when(() => settingsCubit.state).thenReturn(
      const SettingsState.loaded(activeTheme: ActiveTheme.light, locale: 'en'),
    );
    when(() => settingsCubit.updateTheme(any())).thenAnswer((_) async {});

    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(rootWidget(const SettingsPage()));
    await tester.pumpAndSettle();

    final switchWidget = find.byType(Switch);
    expect(switchWidget, findsWidgets);
    await tester.ensureVisible(switchWidget.first);
    await tester.pumpAndSettle();
    await tester.tap(switchWidget.first);
    await tester.pumpAndSettle();
    verify(() => settingsCubit.updateTheme(ActiveTheme.dark)).called(1);
  });

  testWidgets('trigger update language when language tapped in English', (
    tester,
  ) async {
    when(() => settingsCubit.state).thenReturn(
      const SettingsState.loaded(activeTheme: ActiveTheme.light, locale: 'en'),
    );

    await tester.pumpWidget(rootWidget(const SettingsPage()));
    await tester.pumpAndSettle();
  });

  testWidgets('trigger update language when language tapped in Bahasa', (
    tester,
  ) async {
    when(() => settingsCubit.state).thenReturn(
      const SettingsState.loaded(activeTheme: ActiveTheme.light, locale: 'id'),
    );

    await tester.pumpWidget(rootWidget(const SettingsPage()));
    await tester.pumpAndSettle();
  });
}
