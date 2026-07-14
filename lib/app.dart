import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:oktoast/oktoast.dart';

/// Root widget: wires the theme, localization, responsive sizing and router.
/// Theme mode + locale are driven by the app-global [AppSettingsCubit] (loaded
/// before `runApp`, see `main.dart`) so both react to the Appearance / Settings
/// screens instantly and survive a restart. Default theme is light (style guide
/// §20); `locale == null` follows the device.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => OKToast(
    child: ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => BlocProvider.value(
        value: sl<AppSettingsCubit>(),
        child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
          // Only theme/locale drive MaterialApp; a userName emit (e.g. the
          // Settings name field) must not rebuild the whole app shell.
          buildWhen: (prev, curr) =>
              prev.themeMode != curr.themeMode || prev.locale != curr.locale,
          builder: (context, settings) => MaterialApp.router(
            title: Constants.get.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            locale: settings.locale,
            routerConfig: appRouter,
            localizationsDelegates: const [
              Strings.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
            builder: (context, child) => MediaQuery(
              // Dynamic Type up to 130%: clamp system font scaling to 1.0–1.3×
              // so the money hierarchy stays predictable while still honouring
              // the user's accessibility text-size setting.
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.textScalerOf(
                  context,
                ).clamp(minScaleFactor: 1.0, maxScaleFactor: 1.3),
              ),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    ),
  );
}
