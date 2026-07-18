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
import 'package:jaga_saku/features/templates/domain/template_to_transaction.dart';
import 'package:jaga_saku/features/templates/domain/usecases/get_favorites.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/transaction_aggregator.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_recent_transactions.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_month.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/save_transaction.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

/// The outcome of [HomeCubit.applyFavorite] the strip acts on — a plain sealed
/// class (no codegen) mirroring `AccountListCubit.delete`'s `DeleteOutcome`. The
/// widget switches on it: SnackBar-with-undo / navigate-to-prefill / error toast.
sealed class ApplyFavoriteResult {}

/// A fixed-amount favorite committed a transaction with id [txId] (undoable).
class FavoriteCommitted extends ApplyFavoriteResult {
  FavoriteCommitted(this.txId);

  final int txId;
}

/// An amount-less favorite: open the add-form pre-filled from [template]
/// (a **new** tx, never an edit).
class FavoriteNeedsPrefill extends ApplyFavoriteResult {
  FavoriteNeedsPrefill(this.template);

  final TxTemplate template;
}

/// The instant commit failed; [failure] is localized by the widget (rule 17).
class FavoriteApplyFailed extends ApplyFavoriteResult {
  FavoriteApplyFailed(this.failure);

  final Failure failure;
}

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
    required GetFavorites getFavorites,
    required GetDueOccurrences getDueOccurrences,
    required SaveTransaction saveTransaction,
    required DeleteTransaction deleteTransaction,
    required TxChangeNotifier txChangeNotifier,
    required AppSettingsCubit appSettings,
  }) : _getAccounts = getAccounts,
       _getTransactionsByMonth = getTransactionsByMonth,
       _getRecentTransactions = getRecentTransactions,
       _getCategories = getCategories,
       _getBudgetsForPeriod = getBudgetsForPeriod,
       _getFavorites = getFavorites,
       _getDueOccurrences = getDueOccurrences,
       _saveTransaction = saveTransaction,
       _deleteTransaction = deleteTransaction,
       _txChanges = txChangeNotifier,
       _appSettings = appSettings,
       super(const HomeState.initial()) {
    _txSub = _txChanges.changes.listen((_) => load());
  }

  final GetAccounts _getAccounts;
  final GetTransactionsByMonth _getTransactionsByMonth;
  final GetRecentTransactions _getRecentTransactions;
  final GetCategories _getCategories;
  final GetBudgetsForPeriod _getBudgetsForPeriod;
  final GetFavorites _getFavorites;
  final GetDueOccurrences _getDueOccurrences;
  final SaveTransaction _saveTransaction;
  final DeleteTransaction _deleteTransaction;
  final TxChangeNotifier _txChanges;
  final AppSettingsCubit _appSettings;
  late final StreamSubscription<void> _txSub;

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

    // V2-M6: reserved/adjustment category ids the reports must skip (a reconcile
    // correction moves balance, not income/expense). Balance already includes it
    // via the unchanged SQL; the resolver is the single home of the rule.
    final excludeCategoryIds = TransactionAggregator.systemCategoryIds(
      categories,
    );

    final (
      income: monthIncome,
      expense: monthExpense,
    ) = TransactionAggregator.incomeExpense(
      monthTx,
      excludeCategoryIds: excludeCategoryIds,
    );

    final today = DateTime(now.year, now.month, now.day);
    final todayTx = monthTx.where((t) {
      final d = DateTime.fromMillisecondsSinceEpoch(t.date);
      return d.year == today.year &&
          d.month == today.month &&
          d.day == today.day;
    }).toList();

    // C2: a reconcile adjustment dated today is not "spent today" — the fold
    // applies the same exclusion as the month totals.
    final (
      spent: todaySpent,
      unplanned: todayUnplanned,
    ) = TransactionAggregator.spentAndUnplanned(
      todayTx,
      excludeCategoryIds: excludeCategoryIds,
    );
    final expenseByCategory = TransactionAggregator.expenseByCategory(
      todayTx,
      excludeCategoryIds: excludeCategoryIds,
    );

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

  /// Applies a favorite. A fixed-amount favorite instant-commits a transaction
  /// dated today (stamping `createdAt` at persist time — the pure helper is
  /// clock-free); the transaction repo pings [TxChangeNotifier] on the save, so
  /// the strip + cards + balances refresh via the [_txSub] subscription. An
  /// amount-less favorite returns a prefill signal instead (no save). The strip
  /// acts on the returned result.
  Future<ApplyFavoriteResult> applyFavorite(TxTemplate t) async {
    if (t.amount == null) return FavoriteNeedsPrefill(t);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final tx = templateToTransaction(
      t,
      date: today,
    ).copyWith(createdAt: now.millisecondsSinceEpoch);
    final result = await _saveTransaction(tx);
    if (isClosed) return FavoriteApplyFailed(const CacheFailure());
    return result.fold(FavoriteApplyFailed.new, FavoriteCommitted.new);
  }

  /// Undoes a just-applied favorite by deleting its transaction; the repo pings
  /// on the successful delete so Home refreshes via [_txSub]. Best-effort — a
  /// failed delete leaves the tx in place.
  Future<void> undoApply(int txId) async {
    await _deleteTransaction(txId);
  }

  @override
  Future<void> close() {
    _txSub.cancel();
    return super.close();
  }
}
