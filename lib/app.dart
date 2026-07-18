import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/features/security/app_lock_service.dart';
import 'package:oktoast/oktoast.dart';

/// Root widget: wires the theme, localization, responsive sizing and router.
/// Theme mode + locale are driven by the app-global [AppSettingsCubit] (loaded
/// before `runApp`, see `main.dart`) so both react to the Appearance / Settings
/// screens instantly and survive a restart. Default theme is light (style guide
/// §20); `locale == null` follows the device.
///
/// A [WidgetsBindingObserver] drives the app-lock auto-lock (V3-M4): on
/// background (paused / hidden) it stamps the time, on resume it re-locks if the
/// elapsed time passed the threshold. `inactive` is a no-op (transient — Control
/// Center / incoming call) so it never false-locks.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lock = sl<AppLockService>();
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        lock.markBackgrounded();
      case AppLifecycleState.resumed:
        lock.evaluateAutoLock();
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

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
