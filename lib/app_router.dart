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
import 'package:jaga_saku/features/budgets/pages/form/budget_form_cubit.dart';
import 'package:jaga_saku/features/budgets/pages/form/budget_form_page.dart';
import 'package:jaga_saku/features/budgets/pages/list/budget_list_cubit.dart';
import 'package:jaga_saku/features/budgets/pages/list/budget_list_page.dart';
import 'package:jaga_saku/features/calendar/pages/calendar_cubit.dart';
import 'package:jaga_saku/features/calendar/pages/calendar_page.dart';
import 'package:jaga_saku/features/categories/pages/form/category_form_cubit.dart';
import 'package:jaga_saku/features/categories/pages/form/category_form_page.dart';
import 'package:jaga_saku/features/categories/pages/list/category_list_cubit.dart';
import 'package:jaga_saku/features/categories/pages/list/category_list_page.dart';
import 'package:jaga_saku/features/home/pages/home_cubit.dart';
import 'package:jaga_saku/features/home/pages/home_page.dart';
import 'package:jaga_saku/features/insight/pages/insight_cubit.dart';
import 'package:jaga_saku/features/insight/pages/insight_page.dart';
import 'package:jaga_saku/features/insight/pages/money_story_cubit.dart';
import 'package:jaga_saku/features/insight/pages/money_story_page.dart';
import 'package:jaga_saku/features/more/more_page.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/pages/form/recurring_form_cubit.dart';
import 'package:jaga_saku/features/recurring/pages/form/recurring_form_page.dart';
import 'package:jaga_saku/features/recurring/pages/list/recurring_list_cubit.dart';
import 'package:jaga_saku/features/recurring/pages/list/recurring_list_page.dart';
import 'package:jaga_saku/features/recurring/pages/review/recurring_review_cubit.dart';
import 'package:jaga_saku/features/recurring/pages/review/recurring_review_page.dart';
import 'package:jaga_saku/features/settings/pages/about_page.dart';
import 'package:jaga_saku/features/settings/pages/appearance_page.dart';
import 'package:jaga_saku/features/settings/pages/settings_page.dart';
import 'package:jaga_saku/features/shell/app_shell.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/templates/pages/form/favorite_form_cubit.dart';
import 'package:jaga_saku/features/templates/pages/form/favorite_form_page.dart';
import 'package:jaga_saku/features/templates/pages/list/favorites_list_cubit.dart';
import 'package:jaga_saku/features/templates/pages/list/favorites_list_page.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_cubit.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_page.dart';
import 'package:jaga_saku/features/backup/pages/backup/backup_page.dart';
import 'package:jaga_saku/features/backup/pages/backup/cubit/backup_cubit.dart';
import 'package:jaga_saku/features/export/pages/export/cubit/export_cubit.dart';
import 'package:jaga_saku/features/export/pages/export/export_page.dart';

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
  static const String budget = '/budget';
  static const String budgetForm = '/budget/form';
  static const String favorites = '/favorites';
  static const String favoriteForm = '/favorites/form';
  static const String recurring = '/recurring';
  static const String recurringForm = '/recurring/form';
  static const String recurringReview = '/recurring/review';

  // Settings screens (M6) — full-screen, pushed on the root navigator. They read
  // the app-global AppSettingsCubit provided in `app.dart` (no per-route cubit).
  static const String appearance = '/appearance';
  static const String settings = '/settings';
  static const String about = '/about';

  // Money Story (V2-M7) — full-screen recap pushed from the Insight tab.
  static const String moneyStory = '/money-story';

  // Data / tools (V3-M1) — full-screen, pushed on the root navigator.
  static const String backupRestore = '/backup-restore';

  // Export Data (V3-M2) — full-screen, pushed on the root navigator.
  static const String exportData = '/export';
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
            GoRoute(
              path: AppRoute.home,
              builder: (_, _) => BlocProvider(
                create: (_) => HomeCubit(
                  getAccounts: sl(),
                  getTransactionsByMonth: sl(),
                  getRecentTransactions: sl(),
                  getCategories: sl(),
                  getBudgetsForPeriod: sl(),
                  getFavorites: sl(),
                  getDueOccurrences: sl(),
                  saveTransaction: sl(),
                  deleteTransaction: sl(),
                  txChangeNotifier: sl(),
                  appSettings: sl(),
                )..load(),
                child: const HomePage(),
              ),
            ),
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
                  txChangeNotifier: sl(),
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
              builder: (_, _) => BlocProvider(
                create: (_) => InsightCubit(
                  getTransactionsByMonth: sl(),
                  getCategories: sl(),
                  getBudgetsForPeriod: sl(),
                  txChangeNotifier: sl(),
                )..load(DateTime.now()),
                child: const InsightPage(),
              ),
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
      builder: (_, state) {
        final args = state.extra as AddTransactionArgs?;
        return BlocProvider(
          create: (_) => AddTransactionCubit(
            saveTransaction: sl(),
            getAccounts: sl(),
            getCategories: sl(),
            getBudgetsForPeriod: sl(),
            txChangeNotifier: sl(),
            receiptStorage: sl(),
            appSettings: sl(),
            initial: args?.edit,
            prefill: args?.prefill,
          )..load(),
          child: const AddTransactionPage(),
        );
      },
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
          txChangeNotifier: sl(),
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
          txChangeNotifier: sl(),
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
    // ── Budgets (M4) ─────────────────────────────────────────────────────
    GoRoute(
      path: AppRoute.budget,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => BlocProvider(
        create: (_) => BudgetListCubit(
          getBudgetsForPeriod: sl(),
          deleteBudget: sl(),
          getCategories: sl(),
          txChangeNotifier: sl(),
          appSettings: sl(),
        )..load(),
        child: const BudgetListPage(),
      ),
    ),
    GoRoute(
      path: AppRoute.budgetForm,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) {
        final args = state.extra as BudgetFormArgs?;
        return BlocProvider(
          create: (_) => BudgetFormCubit(
            saveBudget: sl(),
            getCategories: sl(),
            getBudgetsForPeriod: sl(),
            txChangeNotifier: sl(),
            appSettings: sl(),
            initial: args?.initial,
            month: args?.month,
          )..load(),
          child: const BudgetFormPage(),
        );
      },
    ),
    // ── Favorites (V2-M2) ────────────────────────────────────────────────
    GoRoute(
      path: AppRoute.favorites,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => BlocProvider(
        create: (_) => FavoritesListCubit(
          getFavorites: sl(),
          deleteTemplate: sl(),
          reorderTemplates: sl(),
        )..load(),
        child: const FavoritesListPage(),
      ),
    ),
    GoRoute(
      path: AppRoute.favoriteForm,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => BlocProvider(
        create: (_) => FavoriteFormCubit(
          saveTemplate: sl(),
          getAccounts: sl(),
          getCategories: sl(),
          initial: state.extra as TxTemplate?,
        )..load(),
        child: const FavoriteFormPage(),
      ),
    ),
    // ── Recurring (V2-M5) ────────────────────────────────────────────────
    GoRoute(
      path: AppRoute.recurring,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => BlocProvider(
        create: (_) =>
            RecurringListCubit(getRules: sl(), deleteRule: sl())..load(),
        child: const RecurringListPage(),
      ),
    ),
    GoRoute(
      path: AppRoute.recurringForm,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => BlocProvider(
        create: (_) => RecurringFormCubit(
          saveRule: sl(),
          getAccounts: sl(),
          getCategories: sl(),
          initial: state.extra as RecurringRule?,
        )..load(),
        child: const RecurringFormPage(),
      ),
    ),
    GoRoute(
      path: AppRoute.recurringReview,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => BlocProvider(
        create: (_) => RecurringReviewCubit(
          getDueOccurrences: sl(),
          confirmOccurrence: sl(),
          skipOccurrence: sl(),
          txChangeNotifier: sl(),
        )..load(),
        child: const RecurringReviewPage(),
      ),
    ),
    // ── Settings (M6) ────────────────────────────────────────────────────
    // No per-route BlocProvider: these read the app-global AppSettingsCubit
    // provided above MaterialApp.router in `app.dart`.
    GoRoute(
      path: AppRoute.appearance,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => const AppearancePage(),
    ),
    GoRoute(
      path: AppRoute.settings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoute.about,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => const AboutPage(),
    ),
    // ── Money Story (V2-M7) ──────────────────────────────────────────────
    GoRoute(
      path: AppRoute.moneyStory,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => BlocProvider(
        create: (_) => MoneyStoryCubit(
          getTransactionsByMonth: sl(),
          getCategories: sl(),
          getAccounts: sl(),
          getAssetTrend: sl(),
          txChangeNotifier: sl(),
        )..load(DateTime.now()),
        child: const MoneyStoryPage(),
      ),
    ),
    // ── Backup & Restore (V3-M1) ─────────────────────────────────────────
    GoRoute(
      path: AppRoute.backupRestore,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => BlocProvider(
        create: (_) => BackupCubit(
          exportBackup: sl(),
          validateBackup: sl(),
          previewBackup: sl(),
          restoreBackup: sl(),
          backupFileService: sl(),
          settingsService: sl(),
          txChangeNotifier: sl(),
        )..loadMeta(),
        child: const BackupPage(),
      ),
    ),
    // ── Export Data (V3-M2) ──────────────────────────────────────────────
    GoRoute(
      path: AppRoute.exportData,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => BlocProvider(
        create: (_) => ExportCubit(
          exportCsv: sl(),
          getAccounts: sl(),
          getCategories: sl(),
          fileService: sl(),
        )..load(),
        child: const ExportPage(),
      ),
    ),
  ],
);
