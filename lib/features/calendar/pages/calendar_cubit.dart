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
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_day.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_month.dart';

part 'calendar_state.dart';
part 'calendar_cubit.freezed.dart';

/// Presentation over the transactions usecases (the first cross-feature usecase
/// dependency — the transactions feature owns the domain/data, calendar consumes
/// it through DI). Loads a month for the grid dots and the selected day for the
/// summary + list, resolves account / category names via lookups, and reloads
/// after an edit or delete. Every emit is guarded by [isClosed] (rule 5).
class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({
    required GetTransactionsByMonth getTransactionsByMonth,
    required GetTransactionsByDay getTransactionsByDay,
    required DeleteTransaction deleteTransaction,
    required GetAccounts getAccounts,
    required GetCategories getCategories,
    required TxChangeNotifier txChangeNotifier,
  }) : _getTransactionsByMonth = getTransactionsByMonth,
       _getTransactionsByDay = getTransactionsByDay,
       _deleteTransaction = deleteTransaction,
       _getAccounts = getAccounts,
       _getCategories = getCategories,
       _txChanges = txChangeNotifier,
       super(
         CalendarState(focusedMonth: _todayMonth(), selectedDay: _today()),
       ) {
    // Consumer side of the W2 fix: any add / edit / delete anywhere pings, and
    // this refreshes the current month + day. Cancelled in [close] (rule 7).
    _txSub = _txChanges.changes.listen((_) => refresh());
  }

  final GetTransactionsByMonth _getTransactionsByMonth;
  final GetTransactionsByDay _getTransactionsByDay;
  final DeleteTransaction _deleteTransaction;
  final GetAccounts _getAccounts;
  final GetCategories _getCategories;
  final TxChangeNotifier _txChanges;
  late final StreamSubscription<void> _txSub;

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime _todayMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  /// Initial load: fetch lookups once, then the current month + day.
  Future<void> load() async {
    emit(state.copyWith(status: CalendarStatus.loading));
    await _ensureLookups();
    if (isClosed) return;
    await _fetch();
  }

  /// User swiped to another month (table_calendar `onPageChanged`).
  Future<void> changeMonth(DateTime month) async {
    emit(state.copyWith(focusedMonth: DateTime(month.year, month.month)));
    await _fetch();
  }

  /// User tapped a day cell.
  Future<void> selectDay(DateTime day) async {
    emit(state.copyWith(selectedDay: DateTime(day.year, day.month, day.day)));
    await _fetch();
  }

  /// Reload after returning from the add/edit form so dots + summary + list all
  /// reflect the saved change.
  Future<void> refresh() => _fetch();

  Future<void> deleteTransaction(int id) async {
    final result = await _deleteTransaction(id);
    if (isClosed) return;
    final failure = result.getLeft().toNullable();
    if (failure != null) {
      emit(state.copyWith(status: CalendarStatus.error, failure: failure));
      return;
    }
    // W2 fix: pinging refreshes this calendar (via its own [changes]
    // subscription) AND Home, so a delete here updates both — no direct
    // `_fetch()` needed.
    _txChanges.ping();
  }

  /// Loads accounts + both category sets once and caches them as id lookups.
  Future<void> _ensureLookups() async {
    if (state.accountsById.isNotEmpty || state.categoriesById.isNotEmpty)
      return;
    final accountsResult = await _getAccounts(NoParams());
    final expenseResult = await _getCategories(CategoryType.expense);
    final incomeResult = await _getCategories(CategoryType.income);
    if (isClosed) return;
    final accounts =
        accountsResult.getRight().toNullable() ?? const <Account>[];
    final categories = [
      ...(expenseResult.getRight().toNullable() ?? const <Category>[]),
      ...(incomeResult.getRight().toNullable() ?? const <Category>[]),
    ];
    emit(
      state.copyWith(
        accountsById: {
          for (final a in accounts)
            if (a.id != null) a.id!: a,
        },
        categoriesById: {
          for (final c in categories)
            if (c.id != null) c.id!: c,
        },
      ),
    );
  }

  /// Fetches the focused month + selected day and folds both into ready/error.
  Future<void> _fetch() async {
    final monthResult = await _getTransactionsByMonth(state.focusedMonth);
    if (isClosed) return;
    final dayResult = await _getTransactionsByDay(state.selectedDay);
    if (isClosed) return;
    final failure =
        monthResult.getLeft().toNullable() ?? dayResult.getLeft().toNullable();
    if (failure != null) {
      emit(state.copyWith(status: CalendarStatus.error, failure: failure));
      return;
    }
    emit(
      state.copyWith(
        monthTransactions:
            monthResult.getRight().toNullable() ?? const <Transaction>[],
        selectedDayTransactions:
            dayResult.getRight().toNullable() ?? const <Transaction>[],
        status: CalendarStatus.ready,
      ),
    );
  }

  @override
  Future<void> close() {
    _txSub.cancel();
    return super.close();
  }
}
