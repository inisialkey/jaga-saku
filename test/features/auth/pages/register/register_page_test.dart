import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/auth/auth.dart';
import '../../../../helpers/fake_path_provider_platform.dart';
import '../../../../helpers/mocks.dart';

// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class FakeAuthCubit extends Fake implements AuthCubit {}

void main() {
  late AuthCubit authCubit;

  setUpAll(() {
    HttpOverrides.global = null;
    registerFallbackValue(FakeAuthCubit());
    registerFallbackValue(const RegisterParams());
  });

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(isUnitTest: true, prefixBox: 'register_page_test_');
    authCubit = MockAuthCubit();
  });

  Widget rootWidget(Widget body, {bool isDarkTheme = false}) =>
      BlocProvider<AuthCubit>.value(
        value: authCubit,
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
            supportedLocales: L10n.all,
            theme: isDarkTheme
                ? themeDark(MockBuildContext())
                : themeLight(MockBuildContext()),
            home: body,
          ),
        ),
      );

  group('RegisterPage', () {
    testWidgets('renders RegisterPage in Light Theme with logo and button', (
      tester,
    ) async {
      when(() => authCubit.state).thenReturn(const AuthState.success(null));
      await tester.pumpWidget(rootWidget(const RegisterPage()));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Image) {
            return widget.image == AssetImage(Images.icLogo);
          }
          return false;
        }),
        findsOneWidget,
      );
      expect(find.byType(Button), findsOneWidget);
    });

    testWidgets('renders RegisterPage in Dark Theme with logo', (tester) async {
      when(() => authCubit.state).thenReturn(const AuthState.success(null));
      await tester.pumpWidget(
        rootWidget(const RegisterPage(), isDarkTheme: true),
      );
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Image) {
            return widget.image == AssetImage(Images.icLogo);
          }
          return false;
        }),
        findsOneWidget,
      );
    });

    testWidgets('form validation — blank fields show no errors initially', (
      tester,
    ) async {
      when(() => authCubit.state).thenReturn(const AuthState.success(null));
      await tester.pumpWidget(rootWidget(const RegisterPage()));
      await tester.pumpAndSettle();

      expect(find.text('Email is not valid'), findsNothing);
      expect(find.text('Password must be at least 6 characters'), findsNothing);
    });

    testWidgets('Next button is present but disabled on a blank form', (
      tester,
    ) async {
      when(() => authCubit.state).thenReturn(const AuthState.success(null));
      await tester.pumpWidget(rootWidget(const RegisterPage()));
      await tester.pumpAndSettle();

      expect(find.byType(Button), findsOneWidget);
      final button = tester.widget<Button>(find.byType(Button));
      expect(button.title, 'Next');
      expect(button.onPressed, isNull);
    });

    testWidgets(
      'filling valid fields + agreeing enables Next and calls register',
      (tester) async {
        when(() => authCubit.state).thenReturn(const AuthState.success(null));
        when(() => authCubit.register(any())).thenAnswer((_) async {});

        await tester.pumpWidget(rootWidget(const RegisterPage()));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('name')), 'Test User');
        await tester.enterText(find.byKey(const Key('email')), 'user@mock.com');
        await tester.enterText(
          find.byKey(const Key('password')),
          'password123',
        );
        await tester.enterText(
          find.byKey(const Key('repeat_password')),
          'password123',
        );
        await tester.pump(const Duration(milliseconds: 450));

        // Accept terms.
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -400),
        );
        await tester.pumpAndSettle();

        final button = tester.widget<Button>(find.byType(Button));
        expect(button.onPressed, isA<VoidCallback>());

        await tester.tap(find.byType(Button));
        verify(() => authCubit.register(any())).called(1);
      },
    );
  });
}
