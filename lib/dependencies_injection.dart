import 'package:get_it/get_it.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:jaga_saku/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:jaga_saku/features/accounts/domain/repositories/account_repository.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/archive_account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/delete_account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/reorder_accounts.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/save_account.dart';
import 'package:jaga_saku/features/budgets/data/datasources/budget_local_datasource.dart';
import 'package:jaga_saku/features/budgets/data/repositories/budget_repository_impl.dart';
import 'package:jaga_saku/features/budgets/domain/repositories/budget_repository.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/delete_budget.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/get_budgets_for_period.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/save_budget.dart';
import 'package:jaga_saku/features/categories/data/datasources/category_local_datasource.dart';
import 'package:jaga_saku/features/categories/data/repositories/category_repository_impl.dart';
import 'package:jaga_saku/features/categories/domain/repositories/category_repository.dart';
import 'package:jaga_saku/features/categories/domain/usecases/archive_category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/delete_category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/categories/domain/usecases/reorder_categories.dart';
import 'package:jaga_saku/features/categories/domain/usecases/save_category.dart';
import 'package:jaga_saku/features/settings/pages/app_settings_cubit.dart';
import 'package:jaga_saku/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:jaga_saku/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:jaga_saku/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_recent_transactions.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_day.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_month.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/save_transaction.dart';

GetIt sl = GetIt.instance;

/// Registers app-wide singletons + per-feature datasources / repositories /
/// usecases. Cubits are NOT registered here — each route builds its own via
/// `BlocProvider(create:)` pulling usecases from [sl] (avoids stale state).
///
/// Order per feature: datasource -> repository -> usecases. [AppDatabase] must
/// already be opened (see `main()`).
Future<void> serviceLocator({bool isUnitTest = false}) async {
  if (isUnitTest) {
    await sl.reset();
  }

  sl.registerSingleton<AppDatabase>(AppDatabase.instance);
  sl.registerLazySingleton<SettingsService>(() => SettingsService(sl()));
  // App-global preferences (theme / locale / greeting name). Singleton so
  // `app.dart` + the Home greeting + the Settings screens all share one
  // reactive instance; `main()` `load()`s it before `runApp` (no flash).
  sl.registerLazySingleton<AppSettingsCubit>(() => AppSettingsCubit(sl()));
  // Cross-feature "transactions changed" signal (M3 / W2 fix). App-lifetime
  // singleton — producers ping it, Home + Calendar cubits subscribe.
  sl.registerLazySingleton<TxChangeNotifier>(() => TxChangeNotifier());

  _registerAccounts();
  _registerCategories();
  _registerBudgets();
  _registerTransactions();
}

void _registerAccounts() {
  sl
    ..registerLazySingleton(() => AccountLocalDatasource(sl<AppDatabase>()))
    ..registerLazySingleton<AccountRepository>(
      () => AccountRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetAccounts(sl()))
    ..registerLazySingleton(() => SaveAccount(sl()))
    ..registerLazySingleton(() => DeleteAccount(sl()))
    ..registerLazySingleton(() => ArchiveAccount(sl()))
    ..registerLazySingleton(() => ReorderAccounts(sl()));
}

void _registerCategories() {
  sl
    ..registerLazySingleton(() => CategoryLocalDatasource(sl<AppDatabase>()))
    ..registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetCategories(sl()))
    ..registerLazySingleton(() => SaveCategory(sl()))
    ..registerLazySingleton(() => DeleteCategory(sl()))
    ..registerLazySingleton(() => ArchiveCategory(sl()))
    ..registerLazySingleton(() => ReorderCategories(sl()));
}

void _registerBudgets() {
  sl
    ..registerLazySingleton(() => BudgetLocalDatasource(sl<AppDatabase>()))
    ..registerLazySingleton<BudgetRepository>(() => BudgetRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetBudgetsForPeriod(sl()))
    ..registerLazySingleton(() => SaveBudget(sl()))
    ..registerLazySingleton(() => DeleteBudget(sl()));
}

void _registerTransactions() {
  sl
    ..registerLazySingleton(() => TransactionLocalDatasource(sl<AppDatabase>()))
    ..registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetTransactionsByMonth(sl()))
    ..registerLazySingleton(() => GetTransactionsByDay(sl()))
    ..registerLazySingleton(() => GetRecentTransactions(sl()))
    ..registerLazySingleton(() => SaveTransaction(sl()))
    ..registerLazySingleton(() => DeleteTransaction(sl()));
}
