import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

/// Wraps [child] the way `lib/app.dart` does so that the pieces the core
/// widgets depend on all resolve inside a widget test:
///
/// - `ScreenUtilInit` (designSize `375x812`, matching `app.dart`) for the
///   `flutter_screenutil` `.sp/.w` extensions,
/// - `MaterialApp` carrying `AppTheme.light` — which registers the [AppPalette]
///   `ThemeExtension`, so `context.colors` is non-null,
/// - the generated `Strings` localization delegates + supported locales, so
///   `Strings.of(context)` returns a value instead of null.
///
/// By default the widget is pumped under a [Scaffold] (a `Material` ancestor is
/// required by buttons, `InkWell`, `TextField`, …). Pass `scaffold: false` for
/// widgets that provide their own [Scaffold] (e.g. `AppScaffold`).
///
/// Defaults to [AppTheme.light]; pass `theme: AppTheme.dark` to render under the
/// dark [AppPalette] (used by `dark_mode_smoke_test.dart`).
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  bool scaffold = true,
  Locale locale = const Locale('en'),
  ThemeData? theme,
}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp(
        locale: locale,
        localizationsDelegates: Strings.localizationsDelegates,
        supportedLocales: Strings.supportedLocales,
        theme: theme ?? AppTheme.light,
        home: scaffold ? Scaffold(body: child) : child,
      ),
    ),
  );
  // Settle the ScreenUtilInit post-frame init + the first localized build.
  await tester.pump();
}

/// Pumps [formChild] pushed onto a go_router stack over a trivial home route,
/// so a form page behaves exactly like production: `context.pop(true)` on a save
/// is an imperative pop (bypasses [PopScope]), while a `CloseButton` /
/// `Navigator.maybePop` back is gated by the unsaved-changes guard. Leaves the
/// tester positioned on the pushed form.
///
/// [formChild] should be the page wrapped in its `BlocProvider` (as the router
/// does in `app_router.dart`). Assert a clean leave with
/// `find.byKey(pumpFormHomeKey)` (the home marker) becoming visible again.
Future<void> pumpFormRouter(
  WidgetTester tester, {
  required Widget formChild,
  Locale locale = const Locale('en'),
}) async {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => Scaffold(
          body: Center(
            child: ElevatedButton(
              key: pumpFormPushKey,
              onPressed: () => context.push('/form'),
              child: const Text('open', key: pumpFormHomeKey),
            ),
          ),
        ),
      ),
      GoRoute(path: '/form', builder: (_, _) => formChild),
    ],
  );
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp.router(
        routerConfig: router,
        locale: locale,
        localizationsDelegates: Strings.localizationsDelegates,
        supportedLocales: Strings.supportedLocales,
        theme: AppTheme.light,
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(pumpFormPushKey));
  await tester.pumpAndSettle();
}

/// The home route's push button (tap to navigate to `/form`).
const Key pumpFormPushKey = Key('pumpFormPush');

/// Marker on the home route — visible only when the form has been popped away.
const Key pumpFormHomeKey = Key('pumpFormHome');
