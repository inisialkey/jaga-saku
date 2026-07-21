import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
// SpendingSlice is defined in `insight_state.dart` (part of `insight_cubit.dart`)
// — reused verbatim so the story's need/want card shares the Insight view type.
import 'package:jaga_saku/features/insight/pages/insight_cubit.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/transaction_aggregator.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_asset_trend.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_month.dart';

part 'money_story_state.dart';
part 'money_story_cubit.freezed.dart';

/// Presentation-only orchestrator for the Money Story screen (V2-M7) — like
/// `insight/` it owns no domain / data layer. It composes the focused month's
/// transactions (+ the previous month for month-over-month), the categories, the
/// accounts and the reconstructed net-worth trend into a [MoneyStory] computed
/// in Dart. All narrative CARDS exclude system/adjustment categories (a
/// reconcile correction moves balance, not the story); the TREND does not (it
/// moves real assets). Subscribes to [TxChangeNotifier] so any transaction
/// change refreshes the recap live; the subscription is cancelled in [close]
/// (rule 7) and every emit is guarded by [isClosed] (rule 5).
class MoneyStoryCubit extends Cubit<MoneyStoryState> {
  MoneyStoryCubit({
    required GetTransactionsByMonth getTransactionsByMonth,
    required GetCategories getCategories,
    required GetAccounts getAccounts,
    required GetAssetTrend getAssetTrend,
    required TxChangeNotifier txChangeNotifier,
  }) : _getTransactionsByMonth = getTransactionsByMonth,
       _getCategories = getCategories,
       _getAccounts = getAccounts,
       _getAssetTrend = getAssetTrend,
       _txChanges = txChangeNotifier,
       super(const MoneyStoryState.initial()) {
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    // Any add / edit / delete pings — recompute the focused month. Cancelled in
    // [close] (rule 7). Never pings itself (no refresh loop).
    _txSub = _txChanges.changes.listen((_) => load(_focusedMonth));
  }

  final GetTransactionsByMonth _getTransactionsByMonth;
  final GetCategories _getCategories;
  final GetAccounts _getAccounts;
  final GetAssetTrend _getAssetTrend;
  final TxChangeNotifier _txChanges;
  late final StreamSubscription<void> _txSub;

  /// First-of-month for the currently-viewed period.
  late DateTime _focusedMonth;
  DateTime get focusedMonth => _focusedMonth;

  /// Loads the focused + previous month's transactions, the categories, the
  /// accounts and the net-worth trend, then folds them into a [MoneyStory].
  /// Emits [MoneyStoryLoading] only on the first load; a month change or notifier
  /// ping keeps the current recap on screen (no loading flash). Any usecase
  /// `Left` → [MoneyStoryError]; an empty month is a valid zero-story.
  Future<void> load(DateTime month) async {
    _focusedMonth = DateTime(month.year, month.month);
    if (state is! MoneyStoryLoaded) emit(const MoneyStoryState.loading());

    final prevMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    final now = DateTime.now();

    final currentResult = await _getTransactionsByMonth(_focusedMonth);
    final previousResult = await _getTransactionsByMonth(prevMonth);
    final expenseCatsResult = await _getCategories(CategoryType.expense);
    final incomeCatsResult = await _getCategories(CategoryType.income);
    final accountsResult = await _getAccounts(NoParams());
    if (isClosed) return;

    final failure =
        currentResult.getLeft().toNullable() ??
        previousResult.getLeft().toNullable() ??
        expenseCatsResult.getLeft().toNullable() ??
        incomeCatsResult.getLeft().toNullable() ??
        accountsResult.getLeft().toNullable();
    if (failure != null) {
      emit(MoneyStoryState.error(failure));
      return;
    }

    final currentTx =
        currentResult.getRight().toNullable() ?? const <Transaction>[];
    final previousTx =
        previousResult.getRight().toNullable() ?? const <Transaction>[];
    final categories = <Category>[
      ...expenseCatsResult.getRight().toNullable() ?? const <Category>[],
      ...incomeCatsResult.getRight().toNullable() ?? const <Category>[],
    ];
    final accounts =
        accountsResult.getRight().toNullable() ?? const <Account>[];

    // Baseline = Σ opening_balance over NON-ARCHIVED accounts (matches Home's
    // totalBalance account set). ponytail: accounts created/archived mid-window
    // shift the baseline slightly — acceptable for a trend.
    final baseline = accounts
        .where((a) => !a.archived)
        .fold<int>(0, (sum, a) => sum + a.openingBalance);

    final trendResult = await _getAssetTrend(
      AssetTrendParams(baseline: baseline, now: now),
    );
    if (isClosed) return;

    final trendFailure = trendResult.getLeft().toNullable();
    if (trendFailure != null) {
      emit(MoneyStoryState.error(trendFailure));
      return;
    }
    final trend = trendResult.getRight().toNullable() ?? const <TrendPoint>[];

    emit(
      MoneyStoryState.loaded(
        _buildStory(
          currentTx: currentTx,
          previousTx: previousTx,
          categories: categories,
          accounts: accounts,
          trend: trend,
          baseline: baseline,
        ),
      ),
    );
  }

  /// Reloads the current month — the error-retry action.
  Future<void> reload() => load(_focusedMonth);

  void previousMonth() =>
      load(DateTime(_focusedMonth.year, _focusedMonth.month - 1));

  void nextMonth() =>
      load(DateTime(_focusedMonth.year, _focusedMonth.month + 1));

  /// Folds the loaded data into the story VM. Every narrative card excludes
  /// system/adjustment categories via the bound aggregator; the [trend] passes
  /// through untouched (it already counts adjustments — computed in the SQL).
  MoneyStory _buildStory({
    required List<Transaction> currentTx,
    required List<Transaction> previousTx,
    required List<Category> categories,
    required List<Account> accounts,
    required List<TrendPoint> trend,
    required int baseline,
  }) {
    final categoriesById = <int, Category>{
      for (final c in categories)
        if (c.id != null) c.id!: c,
    };
    final accountsById = <int, Account>{
      for (final a in accounts)
        if (a.id != null) a.id!: a,
    };
    // Every card fold skips reserved/adjustment rows; binding it to `agg` once
    // means none of them can forget (the trend, computed in SQL, keeps them —
    // it moves real assets).
    final agg = TransactionAggregator.excluding(categories);

    final (:income, :expense) = agg.incomeExpense(currentTx);
    final saved = income - expense;
    // ÷0 guard — a zero-income month has a 0% savings rate, never a throw.
    final savingsRatePct = income > 0 ? (saved / income * 100).round() : 0;

    final byCategory = agg.expenseByCategory(currentTx);
    int? topCategoryId;
    var topCategoryAmount = 0;
    for (final entry in byCategory.entries) {
      if (entry.value > topCategoryAmount) {
        topCategoryAmount = entry.value;
        topCategoryId = entry.key;
      }
    }

    // Biggest single real expense — the fold that replaces the dropped
    // `GetBiggestExpense` SQL (C-B): `currentTx` is already loaded, and it must
    // exclude system categories (a plain `ORDER BY amount DESC` can't).
    final biggestExpense = agg.biggestExpense(currentTx);

    final (income: prevIncome, expense: prevExpense) = agg.incomeExpense(
      previousTx,
    );

    final needVsWant = spendingSlicesFrom(agg.needVsWant(currentTx));
    final netWorth = trend.isNotEmpty ? trend.last.netWorth : baseline;

    return MoneyStory(
      month: _focusedMonth,
      income: income,
      expense: expense,
      saved: saved,
      savingsRatePct: savingsRatePct,
      isDeficit: saved < 0,
      topCategoryId: topCategoryId,
      topCategoryAmount: topCategoryAmount,
      biggestExpense: biggestExpense,
      momIncome: income - prevIncome,
      momExpense: expense - prevExpense,
      needVsWant: needVsWant,
      trend: trend,
      netWorth: netWorth,
      categoriesById: categoriesById,
      accountsById: accountsById,
    );
  }

  @override
  Future<void> close() {
    _txSub.cancel();
    return super.close();
  }
}
