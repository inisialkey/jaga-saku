import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/app_status/app_status.dart';
import 'package:jaga_saku/features/auth/auth.dart';
import 'package:jaga_saku/features/home/home.dart';
import 'package:jaga_saku/features/onboarding/onboarding.dart';
import 'package:jaga_saku/features/settings/settings.dart';
import 'package:jaga_saku/features/splash/splash.dart';
import 'package:jaga_saku/features/users/users.dart';
import 'package:jaga_saku/core/utils/utils.dart';
import 'package:jaga_saku/core/widgets/widgets.dart';

enum Routes {
  root('/'),
  splashScreen('/splashscreen'),
  onboarding('/onboarding'),

  // App-status gates (full-screen, routed to by DioInterceptor)
  forceUpdate('/force-update'),
  maintenance('/maintenance'),

  /// Home Page
  dashboard('/dashboard'),
  settings('/settings'),

  // Users CRUD
  userDetail('/users/:id'),
  userEdit('/users/:id/edit'),

  // User Information
  userInformation('/user-information'),
  editName('/edit-name'),
  editEmail('/edit-email'),
  editLocation('/edit-location'),
  editPhone('/edit-phone'),
  editAge('/edit-age'),
  editGender('/edit-gender'),
  editHeight('/edit-height'),
  editWeight('/edit-weight'),

  // Account
  account('/account'),
  changePassword('/change-password'),

  // Auth Page
  login('/auth/login'),
  register('/auth/register'),
  termsOfService('/auth/terms-of-service'),
  privacyPolicy('/auth/privacy-policy');

  const Routes(this.path);

  final String path;
}

class AppRoute {
  AppRoute._();

  /// Global navigator key for showing dialogs from non-UI code (e.g., interceptors).
  /// Legit global — not mutable state, only mutates via Flutter framework.
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// Builds a [GoRouter] configuration. Pass [isUnitTest] true from tests to
  /// skip the auth/logout refresh listenable (which requires real cubits in
  /// the widget tree). Pass [context] in production so the router can subscribe
  /// to `AuthCubit` / `LogoutCubit` streams via the surrounding [BlocProvider]s.
  static GoRouter routerFor({BuildContext? context, bool isUnitTest = false}) {
    assert(
      isUnitTest || context != null,
      'AppRoute.routerFor requires a BuildContext when isUnitTest is false',
    );
    return GoRouter(
      navigatorKey: navigatorKey,
      // Auto-logs a screen_view on every route change (real app only).
      observers: [
        if (!isUnitTest && sl.isRegistered<AnalyticsService>())
          sl<AnalyticsService>().observer,
      ],
      routes: [
        GoRoute(
          path: Routes.splashScreen.path,
          name: Routes.splashScreen.name,
          builder: (_, _) => const SplashScreenPage(),
        ),
        GoRoute(
          path: Routes.onboarding.path,
          name: Routes.onboarding.name,
          builder: (_, _) => const OnboardingPage(),
        ),
        GoRoute(
          path: Routes.forceUpdate.path,
          name: Routes.forceUpdate.name,
          builder: (_, _) => const ForceUpdatePage(),
        ),
        GoRoute(
          path: Routes.maintenance.path,
          name: Routes.maintenance.name,
          builder: (_, _) => const MaintenancePage(),
        ),
        GoRoute(
          path: Routes.root.path,
          name: Routes.root.name,
          redirect: (_, _) => Routes.dashboard.path,
        ),
        GoRoute(
          path: Routes.login.path,
          name: Routes.login.name,
          builder: (_, _) => const LoginPage(),
        ),
        GoRoute(
          path: Routes.register.path,
          name: Routes.register.name,
          builder: (_, _) => const RegisterPage(),
        ),
        GoRoute(
          path: Routes.termsOfService.path,
          name: Routes.termsOfService.name,
          builder: (_, _) => const TermsOfServicePage(),
        ),
        GoRoute(
          path: Routes.privacyPolicy.path,
          name: Routes.privacyPolicy.name,
          builder: (_, _) => const PrivacyPolicyPage(),
        ),
        // user information
        GoRoute(
          path: Routes.userInformation.path,
          name: Routes.userInformation.name,
          builder: (_, _) => const UserInformationPage(),
        ),
        GoRoute(
          path: Routes.editName.path,
          name: Routes.editName.name,
          builder: (_, _) => BlocProvider(
            create: (_) => sl<EditNameCubit>()..load(),
            child: const EditNamePage(),
          ),
        ),
        GoRoute(
          path: Routes.editEmail.path,
          name: Routes.editEmail.name,
          builder: (_, _) =>
              EditTextFieldPage(config: EditTextFieldConfig.email()),
        ),
        GoRoute(
          path: Routes.editPhone.path,
          name: Routes.editPhone.name,
          builder: (_, _) =>
              EditTextFieldPage(config: EditTextFieldConfig.phone()),
        ),
        GoRoute(
          path: Routes.editLocation.path,
          name: Routes.editLocation.name,
          builder: (_, _) => const EditLocationPage(),
        ),
        GoRoute(
          path: Routes.editAge.path,
          name: Routes.editAge.name,
          builder: (_, _) =>
              EditTextFieldPage(config: EditTextFieldConfig.age()),
        ),
        GoRoute(
          path: Routes.editGender.path,
          name: Routes.editGender.name,
          builder: (_, _) => const EditGenderPage(),
        ),
        GoRoute(
          path: Routes.editHeight.path,
          name: Routes.editHeight.name,
          builder: (_, _) =>
              EditPickerFieldPage(config: EditPickerFieldConfig.height()),
        ),
        GoRoute(
          path: Routes.editWeight.path,
          name: Routes.editWeight.name,
          builder: (_, _) =>
              EditPickerFieldPage(config: EditPickerFieldConfig.weight()),
        ),

        GoRoute(
          path: Routes.account.path,
          name: Routes.account.name,
          builder: (_, _) => const AccountPage(),
        ),
        GoRoute(
          path: Routes.changePassword.path,
          name: Routes.changePassword.name,
          builder: (_, _) => const ChangePasswordPage(),
        ),

        // Users CRUD detail / edit (path param `id`).
        GoRoute(
          path: Routes.userDetail.path,
          name: Routes.userDetail.name,
          builder: (_, state) {
            final args = UserRouteArgs.fromState(state);
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => sl<UserDetailCubit>()),
                BlocProvider(create: (_) => sl<UserEditCubit>()),
              ],
              child: UserDetailPage(id: args.id),
            );
          },
        ),
        GoRoute(
          path: Routes.userEdit.path,
          name: Routes.userEdit.name,
          builder: (_, state) {
            final args = UserRouteArgs.fromState(state);
            return BlocProvider(
              create: (_) => sl<UserEditCubit>(),
              child: UserEditPage(id: args.id, user: args.user),
            );
          },
        ),

        ShellRoute(
          builder: (_, _, child) => BlocProvider(
            create: (context) => sl<MainCubit>(),
            child: MainPage(child: child),
          ),
          routes: [
            GoRoute(
              path: Routes.dashboard.path,
              name: Routes.dashboard.name,
              builder: (_, _) => BlocProvider(
                create: (_) => sl<UsersCubit>()..fetchFirstPage(),
                child: const DashboardPage(),
              ),
            ),
            GoRoute(
              path: Routes.settings.path,
              name: Routes.settings.name,
              builder: (_, _) => const SettingsPage(),
            ),
          ],
        ),
      ],
      initialLocation: Routes.splashScreen.path,
      routerNeglect: true,
      debugLogDiagnostics: kDebugMode,
      errorBuilder: (_, _) => const Scaffold(
        body: SafeArea(child: Center(child: Empty())),
      ),
      refreshListenable: isUnitTest
          ? null
          //coverage:ignore-start
          : GoRouterRefreshStream([
              context!.read<AuthCubit>().stream,
              context.read<LogoutCubit>().stream,
            ]),
      //coverage:ignore-end
      redirect: (_, GoRouterState state) {
        // App-status gates are terminal: once the interceptor routes here,
        // never redirect away (regardless of auth state) until the user
        // updates / maintenance ends.
        if (state.matchedLocation == Routes.forceUpdate.path ||
            state.matchedLocation == Routes.maintenance.path) {
          return null;
        }

        final bool isAllowedPages =
            state.matchedLocation == Routes.login.path ||
            state.matchedLocation == Routes.register.path ||
            state.matchedLocation == Routes.splashScreen.path ||
            state.matchedLocation == Routes.onboarding.path ||
            state.matchedLocation == Routes.termsOfService.path ||
            state.matchedLocation == Routes.privacyPolicy.path;

        final isLoggedIn = sl<AuthStatusRepository>().isLoggedIn;

        if (!isLoggedIn) {
          return isAllowedPages
              ? null
              : Routes.login.path; //coverage:ignore-line
        }

        if (isAllowedPages && isLoggedIn) {
          return Routes.root.path;
        }

        /// No direct
        return null;
      },
    );
  }
}
