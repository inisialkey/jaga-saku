import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/pages/form/account_form_cubit.dart';
import 'package:jaga_saku/features/accounts/pages/form/account_form_page.dart';
import 'package:jaga_saku/features/accounts/pages/list/account_list_cubit.dart';
import 'package:jaga_saku/features/accounts/pages/list/account_list_page.dart';
import 'package:jaga_saku/features/calendar/pages/calendar_cubit.dart';
import 'package:jaga_saku/features/calendar/pages/calendar_page.dart';
import 'package:jaga_saku/features/categories/pages/form/category_form_cubit.dart';
import 'package:jaga_saku/features/categories/pages/form/category_form_page.dart';
import 'package:jaga_saku/features/categories/pages/list/category_list_cubit.dart';
import 'package:jaga_saku/features/categories/pages/list/category_list_page.dart';
import 'package:jaga_saku/features/home/home_page.dart';
import 'package:jaga_saku/features/insight/insight_page.dart';
import 'package:jaga_saku/features/more/more_page.dart';
import 'package:jaga_saku/features/shell/app_shell.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_cubit.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_page.dart';

/// App route locations. Add is not a tab — it is a full-screen route pushed on
/// the root navigator by the shell FAB.
class AppRoute {
  AppRoute._();

  static const String home = '/home';
  static const String calendar = '/calendar';
  static const String insight = '/insight';
  static const String more = '/more';
  static const String add = '/add';

  // Master-data detail screens (M1) — full-screen, pushed on the root navigator.
  static const String accounts = '/accounts';
  static const String accountForm = '/accounts/form';
  static const String categories = '/categories';
  static const String categoryForm = '/categories/form';
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
              builder: (_, _) => BlocProvider(
                create: (_) => CalendarCubit(
                  getTransactionsByMonth: sl(),
                  getTransactionsByDay: sl(),
                  deleteTransaction: sl(),
                  getAccounts: sl(),
                  getCategories: sl(),
                )..load(),
                child: const CalendarPage(),
              ),
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
      builder: (_, state) => BlocProvider(
        create: (_) => AddTransactionCubit(
          saveTransaction: sl(),
          getAccounts: sl(),
          getCategories: sl(),
          initial: state.extra as Transaction?,
        )..load(),
        child: const AddTransactionPage(),
      ),
    ),
    // ── Accounts (M1) ────────────────────────────────────────────────────
    GoRoute(
      path: AppRoute.accounts,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => BlocProvider(
        create: (_) => AccountListCubit(
          getAccounts: sl(),
          deleteAccount: sl(),
          archiveAccount: sl(),
          reorderAccounts: sl(),
        )..load(),
        child: const AccountListPage(),
      ),
    ),
    GoRoute(
      path: AppRoute.accountForm,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => BlocProvider(
        create: (_) => AccountFormCubit(
          saveAccount: sl(),
          initial: state.extra as Account?,
        ),
        child: const AccountFormPage(),
      ),
    ),
    // ── Categories (M1) ──────────────────────────────────────────────────
    GoRoute(
      path: AppRoute.categories,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => BlocProvider(
        create: (_) => CategoryListCubit(
          getCategories: sl(),
          deleteCategory: sl(),
          archiveCategory: sl(),
          reorderCategories: sl(),
        )..load(),
        child: const CategoryListPage(),
      ),
    ),
    GoRoute(
      path: AppRoute.categoryForm,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) {
        final args = state.extra as CategoryFormArgs?;
        return BlocProvider(
          create: (_) => CategoryFormCubit(
            saveCategory: sl(),
            getCategories: sl(),
            initial: args?.category,
            presetType: args?.presetType,
            presetParentId: args?.presetParentId,
          )..loadParents(),
          child: const CategoryFormPage(),
        );
      },
    ),
  ],
);
