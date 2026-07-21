import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_cycle.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/get_budgets_for_period.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/get_due_occurrences.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/templates/domain/usecases/get_favorites.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/transaction_aggregator.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_recent_transactions.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_month.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

/// Presentation-only orchestrator for the Home dashboard (M3). Owns no domain /
/// data layer — it composes the accounts + this-month transactions + recent
/// list + category usecases (all through DI, like `calendar/`) into a
/// [HomeDashboard] computed in Dart. Subscribes to [TxChangeNotifier] so any
/// add / edit / delete anywhere refreshes Home live (the M2 W2 fix), and to
/// [AppSettingsCubit]'s own stream so a budget cycle start-day change re-windows
/// the guard (V4-M2); both subscriptions are cancelled in [close] (rule 7).
/// Every emit is guarded by [isClosed] (rule 5).
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetAccounts getAccounts,
    required GetTransactionsByMonth getTransactionsByMonth,
    required GetRecentTransactions getRecentTransactions,
    required GetCategories getCategories,
    required GetBudgetsForPeriod getBudgetsForPeriod,
    required GetFavorites getFavorites,
    required GetDueOccurrences getDueOccurrences,
    required TxChangeNotifier txChangeNotifier,
    required AppSettingsCubit appSettings,
  }) : _getAccounts = getAccounts,
       _getTransactionsByMonth = getTransactionsByMonth,
       _getRecentTransactions = getRecentTransactions,
       _getCategories = getCategories,
       _getBudgetsForPeriod = getBudgetsForPeriod,
       _getFavorites = getFavorites,
       _getDueOccurrences = getDueOccurrences,
       _txChanges = txChangeNotifier,
       _appSettings = appSettings,
       super(const HomeState.initial()) {
    _txSub = _txChanges.changes.listen((_) => load());
    // V4-M2: the budget guard's cycle window comes from the global start-day, so
    // reload when THAT changes — off the cubit's own stream, not the tx bus.
    _cycleSub = _appSettings.onCycleStartDayChanged(load);
  }

  final GetAccounts _getAccounts;
  final GetTransactionsByMonth _getTransactionsByMonth;
  final GetRecentTransactions _getRecentTransactions;
  final GetCategories _getCategories;
  final GetBudgetsForPeriod _getBudgetsForPeriod;
  final GetFavorites _getFavorites;
  final GetDueOccurrences _getDueOccurrences;
  final TxChangeNotifier _txChanges;
  final AppSettingsCubit _appSettings;
  late final StreamSubscription<void> _txSub;
  late final StreamSubscription<AppSettingsState> _cycleSub;

  static const int _recentLimit = 5;

  /// Loads the usecases and folds them into a [HomeDashboard]. Emits
  /// [HomeLoading] only on the first load; a notifier-triggered reload keeps the
  /// current dashboard on screen (no loading flash). Any usecase `Left` →
  /// [HomeError]; empty data is a valid zero-dashboard (first run), never an
  /// error. The greeting name is no longer loaded here — it lives in the
  /// app-global `AppSettingsCubit` (M6), read directly by the Home header.
  Future<void> load() async {
    if (state is! HomeLoaded) emit(const HomeState.loading());

    final now = DateTime.now();
    final accountsResult = await _getAccounts(NoParams());
    final monthResult = await _getTransactionsByMonth(
      DateTime(now.year, now.month),
    );
    final recentResult = await _getRecentTransactions(_recentLimit);
    final expenseCatsResult = await _getCategories(CategoryType.expense);
    final incomeCatsResult = await _getCategories(CategoryType.income);
    // The Home guard is for the budget cycle CONTAINING now — its label is the
    // cycle-start month (== the calendar month at start-day 1).
    final cycle = BudgetCycle.range(
      startDay: _appSettings.state.budgetCycleStartDay,
      reference: now,
    );
    final budgetsResult = await _getBudgetsForPeriod(
      periodKey(DateTime.fromMillisecondsSinceEpoch(cycle.start)),
    );
    final favoritesResult = await _getFavorites(NoParams());
    final dueResult = await _getDueOccurrences(NoParams());
    if (isClosed) return;

    final failure =
        accountsResult.getLeft().toNullable() ??
        monthResult.getLeft().toNullable() ??
        recentResult.getLeft().toNullable() ??
        expenseCatsResult.getLeft().toNullable() ??
        incomeCatsResult.getLeft().toNullable() ??
        budgetsResult.getLeft().toNullable();
    if (failure != null) {
      emit(HomeState.error(failure));
      return;
    }

    final accounts =
        accountsResult.getRight().toNullable() ?? const <Account>[];
    final monthTx =
        monthResult.getRight().toNullable() ?? const <Transaction>[];
    final recent =
        recentResult.getRight().toNullable() ?? const <Transaction>[];
    final categories = <Category>[
      ...expenseCatsResult.getRight().toNullable() ?? const <Category>[],
      ...incomeCatsResult.getRight().toNullable() ?? const <Category>[],
    ];
    final budgets = budgetsResult.getRight().toNullable() ?? const <Budget>[];
    // Favorites are non-blocking: a read failure hides the strip (like the
    // category lists) rather than erroring the whole dashboard.
    final favorites =
        favoritesResult.getRight().toNullable() ?? const <TxTemplate>[];
    // Recurring catch-up is non-blocking too: a read failure hides the badge.
    final pending =
        dueResult.getRight().toNullable() ?? const <PendingOccurrence>[];

    emit(
      HomeState.loaded(
        _buildDashboard(
          now: now,
          accounts: accounts,
          monthTx: monthTx,
          recent: recent,
          categories: categories,
          budgets: budgets,
          favorites: favorites,
          pendingRecurring: pending.length,
        ),
      ),
    );
  }

  /// Folds the month's rows into the dashboard totals + today's review. Balances
  /// are already tx-derived (M1/M2), so the total is a plain sum of non-archived
  /// account balances — no re-summing of transactions.
  HomeDashboard _buildDashboard({
    required DateTime now,
    required List<Account> accounts,
    required List<Transaction> monthTx,
    required List<Transaction> recent,
    required List<Category> categories,
    required List<Budget> budgets,
    required List<TxTemplate> favorites,
    required int pendingRecurring,
  }) {
    final totalBalance = accounts
        .where((a) => !a.archived)
        .fold<int>(0, (sum, a) => sum + a.balance);

    // V2-M6: reports skip reserved/adjustment rows (a reconcile correction moves
    // balance, not income/expense). Balance already includes them via the
    // unchanged SQL. Binding the rule to the aggregator once means no fold below
    // can forget it.
    final agg = TransactionAggregator.excluding(categories);

    final (income: monthIncome, expense: monthExpense) = agg.incomeExpense(
      monthTx,
    );

    final today = DateTime(now.year, now.month, now.day);
    final todayTx = monthTx.where((t) {
      final d = DateTime.fromMillisecondsSinceEpoch(t.date);
      return d.year == today.year &&
          d.month == today.month &&
          d.day == today.day;
    }).toList();

    // A reconcile adjustment dated today is not "spent today"; `agg` already
    // carries that exclusion, so these folds get it for free.
    final (spent: todaySpent, unplanned: todayUnplanned) = agg
        .spentAndUnplanned(todayTx);
    final expenseByCategory = agg.expenseByCategory(todayTx);

    final categoriesById = <int, Category>{
      for (final c in categories)
        if (c.id != null) c.id!: c,
    };
    final accountsById = <int, Account>{
      for (final a in accounts)
        if (a.id != null) a.id!: a,
    };

    return HomeDashboard(
      totalBalance: totalBalance,
      monthIncome: monthIncome,
      monthExpense: monthExpense,
      todaySpent: todaySpent,
      todayUnplanned: todayUnplanned,
      pendingRecurring: pendingRecurring,
      topCategoryName: _topCategoryName(expenseByCategory, categoriesById),
      recent: recent,
      categoriesById: categoriesById,
      accountsById: accountsById,
      budgetGuard: _mostAtRiskGuard(budgets, categoriesById, now),
      favorites: favorites,
    );
  }

  /// The single budget the guard card surfaces: the **most at-risk** one — the
  /// highest spent/limit ratio, breaking a tie toward the higher spent. Null when
  /// there are no budgets (Home keeps its empty state). [budgets] are already for
  /// the current period, so each [BudgetStatus] uses the current-month clock.
  BudgetGuardView? _mostAtRiskGuard(
    List<Budget> budgets,
    Map<int, Category> categoriesById,
    DateTime now,
  ) {
    Budget? top;
    BudgetStatus? topStatus;
    for (final budget in budgets) {
      final status = BudgetStatus.compute(
        limitAmount: budget.limitAmount,
        spent: budget.spent,
        now: now,
        periodStart: budget.periodStart,
        periodEnd: budget.periodEnd,
      );
      final wins =
          topStatus == null ||
          status.ratio > topStatus.ratio ||
          (status.ratio == topStatus.ratio && budget.spent > top!.spent);
      if (wins) {
        top = budget;
        topStatus = status;
      }
    }
    if (top == null || topStatus == null) return null;

    final category = categoriesById[top.categoryId];
    return BudgetGuardView(
      categoryName: category?.name ?? '',
      categoryIcon: category?.icon,
      categoryColor: category?.color,
      remaining: topStatus.remaining,
      safeDaily: topStatus.safeDaily,
      ratio: topStatus.ratio,
      level: topStatus.level,
    );
  }

  /// Name of the category with the largest expense today, or null if nothing
  /// was spent (or the category is unknown).
  String? _topCategoryName(
    Map<int, int> expenseByCategory,
    Map<int, Category> categoriesById,
  ) {
    if (expenseByCategory.isEmpty) return null;
    var topId = -1;
    var topAmount = -1;
    expenseByCategory.forEach((id, amount) {
      if (amount > topAmount) {
        topAmount = amount;
        topId = id;
      }
    });
    return categoriesById[topId]?.name;
  }

  @override
  Future<void> close() {
    _txSub.cancel();
    _cycleSub.cancel();
    return super.close();
  }
}
