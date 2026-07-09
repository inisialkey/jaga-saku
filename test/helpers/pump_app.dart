import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
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
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  bool scaffold = true,
  Locale locale = const Locale('en'),
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
        theme: AppTheme.light,
        home: scaffold ? Scaffold(body: child) : child,
      ),
    ),
  );
  // Settle the ScreenUtilInit post-frame init + the first localized build.
  await tester.pump();
}
