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
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/search_transactions.dart';

part 'search_transaction_state.dart';
part 'search_transaction_cubit.freezed.dart';

/// Drives the Advanced Search screen (V3-M3). The live filter set is carried in
/// every [SearchTransactionState] (so the chip bar + sheet read it uniformly),
/// while the account / category reference data — loaded once for the pickers and
/// row-name resolution — lives in cubit fields (not state).
///
/// Debounces keyword input (~300 ms) so a burst of keystrokes runs one query,
/// and subscribes to [TxChangeNotifier] so an edit/delete from a result row
/// re-runs the current search live. Every post-`await`/post-debounce emit is
/// guarded by [isClosed]; [close] cancels the debounce timer + the subscription
/// (rule 7).
class SearchTransactionCubit extends Cubit<SearchTransactionState> {
  SearchTransactionCubit({
    required SearchTransactions searchTransactions,
    required GetAccounts getAccounts,
    required GetCategories getCategories,
    required TxChangeNotifier txChangeNotifier,
  }) : _searchTransactions = searchTransactions,
       _getAccounts = getAccounts,
       _getCategories = getCategories,
       _txChanges = txChangeNotifier,
       super(const SearchTransactionState.initial(SearchTransactionParams())) {
    // An add / edit / delete from a result row pings; re-run the current search
    // so results stay fresh (mirrors AccountListCubit). Cancelled in [close].
    _txSub = _txChanges.changes.listen((_) {
      if (state.params.hasQuery) _run(state.params);
    });
  }

  final SearchTransactions _searchTransactions;
  final GetAccounts _getAccounts;
  final GetCategories _getCategories;
  final TxChangeNotifier _txChanges;
  late final StreamSubscription<void> _txSub;
  Timer? _debounce;

  List<Account> _accounts = const [];
  List<Category> _categories = const [];
  Map<int, Account> _accountsById = const {};
  Map<int, Category> _categoriesById = const {};

  /// Accounts offered in the filter picker — **all** accounts including archived
  /// ones, so a historical search can still target a retired wallet.
  List<Account> get accountOptions => _accounts;

  /// Categories offered in the filter picker — excludes archived + reserved
  /// system categories (matching every other picker in the app).
  List<Category> get categoryOptions =>
      _categories.where((c) => !c.archived && !c.isSystem).toList();

  /// Resolves a result row's source account (incl. archived) for the tile name.
  Account? accountOf(Transaction t) => _accountsById[t.accountId];

  /// Resolves a result row's category (incl. archived/system) for the tile name.
  Category? categoryOf(Transaction t) =>
      t.categoryId == null ? null : _categoriesById[t.categoryId];

  /// Resolves a transfer row's destination account for the tile subtitle.
  Account? toAccountOf(Transaction t) =>
      t.toAccountId == null ? null : _accountsById[t.toAccountId];

  /// The display name of an account by id (incl. archived) — for the
  /// active-filter chip label. Falls back to null when unknown.
  String? accountName(int? id) => id == null ? null : _accountsById[id]?.name;

  /// The display name of a category by id (incl. archived/system) — for the
  /// active-filter chip label. Falls back to null when unknown.
  String? categoryName(int? id) =>
      id == null ? null : _categoriesById[id]?.name;

  /// Loads the account + (expense & income) category reference data once, for
  /// the filter pickers and row-name resolution. A `Left` folds to an empty set
  /// (search still works keyword-only; the pickers are just empty) rather than
  /// failing the whole screen. Stored in fields — no emit (rule: ancillary data
  /// off the state machine).
  Future<void> loadOptions() async {
    final accountsResult = await _getAccounts(NoParams());
    final expenseResult = await _getCategories(CategoryType.expense);
    final incomeResult = await _getCategories(CategoryType.income);
    if (isClosed) return;
    _accounts = accountsResult.getRight().toNullable() ?? const <Account>[];
    _categories = [
      ...(expenseResult.getRight().toNullable() ?? const <Category>[]),
      ...(incomeResult.getRight().toNullable() ?? const <Category>[]),
    ];
    _accountsById = {
      for (final a in _accounts)
        if (a.id != null) a.id!: a,
    };
    _categoriesById = {
      for (final c in _categories)
        if (c.id != null) c.id!: c,
    };
  }

  /// Debounced keyword change. Reads the **current** `state.params` when the
  /// timer fires so a filter applied mid-debounce is preserved; a blank keyword
  /// clears the facet (null).
  void setKeyword(String raw) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (isClosed) return;
      final trimmed = raw.trim();
      _run(state.params.copyWith(keyword: trimmed.isEmpty ? null : trimmed));
    });
  }

  /// Applies a new filter set — the sheet's Apply and each chip's ✕ both route
  /// here (chip removal passes `state.params.copyWith(facet: null)`).
  Future<void> updateFilters(SearchTransactionParams next) => _run(next);

  /// Drops every filter + resets sort but **keeps the keyword**.
  Future<void> clearFilters() =>
      _run(SearchTransactionParams(keyword: state.params.keyword));

  /// Full clear (keyword + filters) → back to the prompt.
  void reset() {
    _debounce?.cancel();
    emit(const SearchTransactionState.initial(SearchTransactionParams()));
  }

  Future<void> _run(SearchTransactionParams params) async {
    if (!params.hasQuery) {
      emit(SearchTransactionState.initial(params));
      return;
    }
    emit(SearchTransactionState.loading(params));
    final result = await _searchTransactions(params);
    if (isClosed) return;
    emit(
      result.fold(
        (f) => SearchTransactionState.failure(params, f),
        (items) => items.isEmpty
            ? SearchTransactionState.empty(params)
            : SearchTransactionState.results(params, items),
      ),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _txSub.cancel();
    return super.close();
  }
}
