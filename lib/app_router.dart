import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/features/add_transaction/add_transaction_page.dart';
import 'package:jaga_saku/features/calendar/calendar_page.dart';
import 'package:jaga_saku/features/home/home_page.dart';
import 'package:jaga_saku/features/insight/insight_page.dart';
import 'package:jaga_saku/features/more/more_page.dart';
import 'package:jaga_saku/features/shell/app_shell.dart';

/// App route locations. Add is not a tab — it is a full-screen route pushed on
/// the root navigator by the shell FAB.
class AppRoute {
  AppRoute._();

  static const String home = '/home';
  static const String calendar = '/calendar';
  static const String insight = '/insight';
  static const String more = '/more';
  static const String add = '/add';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// The single [GoRouter] for the app: a 4-branch bottom-nav shell plus the
/// full-screen `/add` route.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoute.home,
  debugLogDiagnostics: kDebugMode,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: AppRoute.home, builder: (_, _) => const HomePage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.calendar,
              builder: (_, _) => const CalendarPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.insight,
              builder: (_, _) => const InsightPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: AppRoute.more, builder: (_, _) => const MorePage()),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoute.add,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => const AddTransactionPage(),
    ),
  ],
);
