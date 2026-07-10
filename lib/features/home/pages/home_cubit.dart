import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/core/utils/services/settings/settings_service.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/get_budgets_for_period.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_recent_transactions.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_month.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

/// Presentation-only orchestrator for the Home dashboard (M3). Owns no domain /
/// data layer — it composes the accounts + this-month transactions + recent
/// list + category usecases (all through DI, like `calendar/`) into a
/// [HomeDashboard] computed in Dart. Subscribes to [TxChangeNotifier] so any
/// add / edit / delete anywhere refreshes Home live (the M2 W2 fix); the
/// subscription is cancelled in [close] (rule 7). Every emit is guarded by
/// [isClosed] (rule 5).
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetAccounts getAccounts,
    required GetTransactionsByMonth getTransactionsByMonth,
    required GetRecentTransactions getRecentTransactions,
    required GetCategories getCategories,
    required GetBudgetsForPeriod getBudgetsForPeriod,
    required SettingsService settingsService,
    required TxChangeNotifier txChangeNotifier,
  }) : _getAccounts = getAccounts,
       _getTransactionsByMonth = getTransactionsByMonth,
       _getRecentTransactions = getRecentTransactions,
       _getCategories = getCategories,
       _getBudgetsForPeriod = getBudgetsForPeriod,
       _settings = settingsService,
       _txChanges = txChangeNotifier,
       super(const HomeState.initial()) {
    _txSub = _txChanges.changes.listen((_) => load());
  }

  final GetAccounts _getAccounts;
  final GetTransactionsByMonth _getTransactionsByMonth;
  final GetRecentTransactions _getRecentTransactions;
  final GetCategories _getCategories;
  final GetBudgetsForPeriod _getBudgetsForPeriod;
  final SettingsService _settings;
  final TxChangeNotifier _txChanges;
  late final StreamSubscription<void> _txSub;

  static const int _recentLimit = 5;
  static const String _userNameKey = 'user_name';

  /// Loads the four usecases + the greeting name and folds them into a
  /// [HomeDashboard]. Emits [HomeLoading] only on the first load; a
  /// notifier-triggered reload keeps the current dashboard on screen (no loading
  /// flash). Any usecase `Left` → [HomeError]; empty data is a valid
  /// zero-dashboard (first run), never an error.
  Future<void> load() async {
    if (state is! HomeLoaded) emit(const HomeState.loading());

    final now = DateTime.now();
    final userName = await _readName();
    final accountsResult = await _getAccounts(NoParams());
    final monthResult = await _getTransactionsByMonth(
      DateTime(now.year, now.month),
    );
    final recentResult = await _getRecentTransactions(_recentLimit);
    final expenseCatsResult = await _getCategories(CategoryType.expense);
    final incomeCatsResult = await _getCategories(CategoryType.income);
    final budgetsResult = await _getBudgetsForPeriod(periodKey(now));
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

    emit(
      HomeState.loaded(
        _buildDashboard(
          now: now,
          accounts: accounts,
          monthTx: monthTx,
          recent: recent,
          categories: categories,
          budgets: budgets,
          userName: userName,
        ),
      ),
    );
  }

  /// The greeting name from settings, or null (guest) when unset. A settings
  /// read failure is cosmetic, so it falls back to the guest greeting rather
  /// than failing the dashboard.
  Future<String?> _readName() async {
    try {
      final name = (await _settings.getString(_userNameKey))?.trim();
      return (name == null || name.isEmpty) ? null : name;
    } catch (_) {
      // ponytail: name is decorative — never let it error the whole load.
      return null;
    }
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
    required String? userName,
  }) {
    final totalBalance = accounts
        .where((a) => !a.archived)
        .fold<int>(0, (sum, a) => sum + a.balance);

    var monthIncome = 0;
    var monthExpense = 0;
    for (final t in monthTx) {
      switch (t.type) {
        case TransactionType.income:
          monthIncome += t.amount;
        case TransactionType.expense:
          monthExpense += t.amount;
        case TransactionType.transfer:
          break; // internal move — excluded from both income and expense
      }
    }

    final today = DateTime(now.year, now.month, now.day);
    var todaySpent = 0;
    var todayUnplanned = 0;
    final expenseByCategory = <int, int>{};
    for (final t in monthTx) {
      if (t.type != TransactionType.expense) continue;
      final d = DateTime.fromMillisecondsSinceEpoch(t.date);
      if (d.year != today.year ||
          d.month != today.month ||
          d.day != today.day) {
        continue;
      }
      todaySpent += t.amount;
      if (t.plannedStatus == PlannedStatus.unplanned) {
        todayUnplanned += t.amount;
      }
      final categoryId = t.categoryId;
      if (categoryId != null) {
        expenseByCategory[categoryId] =
            (expenseByCategory[categoryId] ?? 0) + t.amount;
      }
    }

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
      topCategoryName: _topCategoryName(expenseByCategory, categoriesById),
      userName: userName,
      recent: recent,
      categoriesById: categoriesById,
      accountsById: accountsById,
      budgetGuard: _mostAtRiskGuard(budgets, categoriesById, now),
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
        period: budget.period,
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
    return super.close();
  }
}
