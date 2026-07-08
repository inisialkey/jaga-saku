import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/home/home.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../helpers/fake_path_provider_platform.dart';
import '../../../../helpers/mocks.dart';

class MockMainCubit extends MockCubit<MainState> implements MainCubit {}

class MockUserCubit extends MockCubit<UserState> implements UserCubit {}

class MockLogoutCubit extends MockCubit<LogoutState> implements LogoutCubit {}

void main() {
  late MainCubit mainCubit;
  late UserCubit userCubit;
  late LogoutCubit logoutCubit;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(isUnitTest: true, prefixBox: 'main_page_test_');
    mainCubit = MockMainCubit();
    userCubit = MockUserCubit();
    logoutCubit = MockLogoutCubit();
    when(() => mainCubit.currentIndex).thenReturn(0);
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: Routes.dashboard.path,
      routes: [
        ShellRoute(
          builder: (context, state, child) => MainPage(child: child),
          routes: [
            GoRoute(
              path: Routes.dashboard.path,
              name: Routes.dashboard.name,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Dashboard'))),
            ),
            GoRoute(
              path: Routes.settings.path,
              name: Routes.settings.name,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Settings'))),
            ),
          ],
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: mainCubit),
        BlocProvider.value(value: userCubit),
        BlocProvider.value(value: logoutCubit),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 667),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, _) => MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            Strings.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('en'),
          supportedLocales: L10n.all,
          theme: themeLight(MockBuildContext()),
        ),
      ),
    );
  }

  testWidgets('MainPage renders child and bottom nav bar', (tester) async {
    when(() => mainCubit.state).thenReturn(const MainState.tab(0));
    when(() => userCubit.state).thenReturn(const UserState.success(null));
    when(() => logoutCubit.state).thenReturn(const LogoutState.loading());

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.byType(FloatingBottomNavBar), findsOneWidget);
  });
}
