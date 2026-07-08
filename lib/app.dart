import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/auth/auth.dart';
import 'package:jaga_saku/features/home/home.dart';
import 'package:jaga_saku/features/settings/settings.dart';
import 'package:oktoast/oktoast.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    log.d(const String.fromEnvironment('ENV'));
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SettingsCubit>()..loadSettings()),
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<LogoutCubit>()),
        BlocProvider(create: (_) => sl<ConnectivityCubit>()),
      ],
      child: const _AppShell(),
    );
  }
}

/// Holds the [GoRouter] in [State] so it is built exactly once after the
/// surrounding [BlocProvider]s are in the tree. Prevents
/// `ScreenUtilInit.builder` / `BlocBuilder` rebuilds (orientation, locale,
/// textScale, settings changes) from reconstructing the router and
/// re-subscribing [GoRouterRefreshStream] on every frame.
class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  late final GoRouter _routerConfig;

  @override
  void initState() {
    super.initState();
    // One-time UI chrome setup; not in build() to avoid re-running on rebuild.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    _routerConfig = AppRoute.routerFor(context: context);
  }

  @override
  Widget build(BuildContext context) => OKToast(
    child: ScreenUtilInit(
      /// Set screen size to make responsive
      /// Almost all device
      designSize: const Size(375, 667),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => BlocBuilder<SettingsCubit, SettingsState>(
        builder: (_, settingsState) {
          final activeTheme = switch (settingsState) {
            SettingsStateLoaded(:final activeTheme) => activeTheme,
            _ => ActiveTheme.system,
          };
          final locale = switch (settingsState) {
            SettingsStateLoaded(:final locale) => locale,
            _ => 'en',
          };

          return MaterialApp.router(
            routerConfig: _routerConfig,
            localizationsDelegates: const [
              Strings.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context);

              return MediaQuery(
                data: data.copyWith(
                  textScaler: TextScaler.noScaling,
                  alwaysUse24HourFormat: true,
                ),
                child: BlocListener<ConnectivityCubit, ConnectivityState>(
                  listener: (context, state) {
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.hideCurrentMaterialBanner();

                    switch (state) {
                      case ConnectivityStateDisconnected():
                        messenger.showMaterialBanner(
                          MaterialBanner(
                            backgroundColor: context.colors.red,
                            content: Text(
                              Strings.of(context)?.noInternetConnection ??
                                  'No internet connection',
                              style: const TextStyle(color: Colors.white),
                            ),
                            leading: const Icon(
                              Icons.wifi_off,
                              color: Colors.white,
                            ),
                            actions: const [SizedBox.shrink()],
                          ),
                        );
                      case ConnectivityStateConnected():
                        messenger.showMaterialBanner(
                          MaterialBanner(
                            backgroundColor: context.colors.green,
                            content: Text(
                              Strings.of(context)?.connectionRestored ??
                                  'Connection restored',
                              style: const TextStyle(color: Colors.white),
                            ),
                            leading: const Icon(
                              Icons.wifi,
                              color: Colors.white,
                            ),
                            actions: const [SizedBox.shrink()],
                          ),
                        );
                        Future.delayed(
                          const Duration(seconds: 2),
                          () => messenger.hideCurrentMaterialBanner(),
                        );
                    }
                  },
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
            title: Constants.get.appName,
            theme: themeLight(context),
            darkTheme: themeDark(context),
            locale: Locale(locale),
            supportedLocales: L10n.all,
            themeMode: activeTheme.mode,
          );
        },
      ),
    ),
  );
}
