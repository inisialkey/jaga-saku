part of 'calendar_cubit.dart';

enum CalendarStatus { initial, loading, ready, error }

/// State for the calendar ledger. Holds the focused month + selected day, the
/// month's transactions (for grid dots), the selected day's transactions (for
/// the summary + list), and the account / category lookups used to resolve ids
/// into display names on each tile.
@freezed
abstract class CalendarState with _$CalendarState {
  const factory CalendarState({
    required DateTime focusedMonth,
    required DateTime selectedDay,
    @Default(<Transaction>[]) List<Transaction> monthTransactions,
    @Default(<Transaction>[]) List<Transaction> selectedDayTransactions,
    @Default(<int, Account>{}) Map<int, Account> accountsById,
    @Default(<int, Category>{}) Map<int, Category> categoriesById,
    @Default(CalendarStatus.initial) CalendarStatus status,
    Failure? failure,
  }) = _CalendarState;

  const CalendarState._();

  bool get isLoading => status == CalendarStatus.loading;

  /// Reserved/adjustment category ids the day summary must skip — resolved from
  /// the state's own [categoriesById] so the day totals align with every other
  /// report surface (a reconcile correction moves balance, not the day summary).
  Set<int> get _systemCategoryIds =>
      TransactionAggregator.systemCategoryIds(categoriesById.values);

  ({int income, int expense}) get _dayTotals =>
      TransactionAggregator.incomeExpense(
        selectedDayTransactions,
        excludeCategoryIds: _systemCategoryIds,
      );

  /// Total income on the selected day (positive rupiah), adjustments excluded.
  int get dayIncome => _dayTotals.income;

  /// Total expense on the selected day (positive rupiah), adjustments excluded.
  int get dayExpense => _dayTotals.expense;

  /// Net for the day (income − expense). Transfers and reconcile adjustments are
  /// excluded (transfers net to zero for a single-account view).
  int get dayBalance => _dayTotals.income - _dayTotals.expense;

  /// The focused month's transactions that fall on [day], adjustments excluded
  /// — this feeds the grid's event dots, so it must apply the same rule as
  /// [dayIncome] / [dayExpense]. Without the exclusion a day whose only row was
  /// a reconcile adjustment drew a dot while its summary read 0 / 0 / 0.
  List<Transaction> transactionsOn(DateTime day) {
    final systemIds = _systemCategoryIds;
    return monthTransactions.where((t) {
      if (t.categoryId != null && systemIds.contains(t.categoryId))
        return false;
      final d = DateTime.fromMillisecondsSinceEpoch(t.date);
      return d.year == day.year && d.month == day.month && d.day == day.day;
    }).toList();
  }

  /// A [DateTime] inside the focused month that table_calendar can focus on —
  /// the selected day when it belongs to the focused month, else the 1st.
  DateTime get calendarFocusedDay =>
      (selectedDay.year == focusedMonth.year &&
          selectedDay.month == focusedMonth.month)
      ? selectedDay
      : focusedMonth;

  Category? categoryOf(Transaction t) =>
      t.categoryId == null ? null : categoriesById[t.categoryId];

  Account? accountOf(Transaction t) => accountsById[t.accountId];

  Account? toAccountOf(Transaction t) =>
      t.toAccountId == null ? null : accountsById[t.toAccountId];
}
