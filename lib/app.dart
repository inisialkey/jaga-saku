import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:oktoast/oktoast.dart';

/// Root widget: wires the theme, localization, responsive sizing and router.
/// Default theme is light (style guide §20); dark is available and follows the
/// system setting once a settings toggle lands (M6).
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => OKToast(
    child: ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp.router(
        title: Constants.get.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        routerConfig: appRouter,
        localizationsDelegates: const [
          Strings.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.all,
        builder: (context, child) => MediaQuery(
          // Lock text scaling so money hierarchy stays predictable.
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    ),
  );
}
