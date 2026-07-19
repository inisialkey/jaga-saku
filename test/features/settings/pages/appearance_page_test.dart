import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/features/settings/pages/appearance_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/pump_app.dart';

/// [AppearancePage] over a real [AppSettingsCubit] (mocked store). Strings
/// resolve in EN (pumpApp default), so the option labels are "Theme Light/Dark/
/// System".
void main() {
  late MockSettingsService settings;
  late AppSettingsCubit cubit;

  setUp(() {
    settings = MockSettingsService();
    when(() => settings.getString(any())).thenAnswer((_) async => null);
    when(() => settings.setString(any(), any())).thenAnswer((_) async {});
    // Default (unloaded) state → light.
    cubit = AppSettingsCubit(settings);
  });

  tearDown(() => cubit.close());

  Future<void> pump(WidgetTester tester) => pumpApp(
    tester,
    BlocProvider.value(value: cubit, child: const AppearancePage()),
    scaffold: false,
  );

  testWidgets('shows the three theme options with Light ticked by default', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('Theme Light'), findsOneWidget);
    expect(find.text('Theme Dark'), findsOneWidget);
    expect(find.text('Theme System'), findsOneWidget);
    // Light is the default → exactly one option is ticked.
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('tapping Dark selects and persists dark mode', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Theme Dark'));
    await tester.pumpAndSettle();

    expect(cubit.state.themeMode, ThemeMode.dark);
    verify(() => settings.setString('theme_mode', 'dark')).called(1);
  });
}
