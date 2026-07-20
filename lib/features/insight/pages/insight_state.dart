part of 'insight_cubit.dart';

/// One expense-category wedge of the donut + its legend row (plan §2). [pct] is
/// a 0..1 fraction of the month's total expense, so it feeds both `PieChart`
/// section values and `ProgressBarX` directly; the widget renders the whole
/// percent as `(pct * 100).round()`.
@freezed
abstract class CategorySlice with _$CategorySlice {
  const factory CategorySlice({
    required int categoryId,
    required String name,
    required int amount,
    required double pct,

    /// ARGB color of the category (drives the donut wedge + legend avatar).
    int? color,
  }) = _CategorySlice;
}

/// Planned vs. unplanned split over the expenses that carry a `plannedStatus`
/// (null-status expenses are excluded — the pcts are of this typed subset, not
/// of all expense). Both pcts are 0..1 fractions.
@freezed
abstract class PlannedSplit with _$PlannedSplit {
  const factory PlannedSplit({
    @Default(0) int planned,
    @Default(0) int unplanned,
    @Default(0) double plannedPct,
    @Default(0) double unplannedPct,
  }) = _PlannedSplit;

  const PlannedSplit._();

  /// Total of the typed subset; 0 → the section shows its empty state.
  int get total => planned + unplanned;
}

/// One need/want/lifestyle/emergency row: the summed amount + its 0..1 share of
/// the typed spending subset.
@freezed
abstract class SpendingSlice with _$SpendingSlice {
  const factory SpendingSlice({required int amount, required double pct}) =
      _SpendingSlice;
}

/// Shapes a [TransactionAggregator.needVsWant] fold into the view type — the
/// fold is delegated; only the 0..1 pcts (÷0-guarded) are computed here.
/// Shared by Insight and Money Story, which rendered the same slices from two
/// byte-identical private copies.
Map<SpendingType, SpendingSlice> spendingSlicesFrom(
  Map<SpendingType, int> byType,
) {
  final total = byType.values.fold(0, (sum, v) => sum + v);
  return {
    for (final e in byType.entries)
      e.key: SpendingSlice(
        amount: e.value,
        pct: total > 0 ? e.value / total : 0,
      ),
  };
}

/// View-model for the whole Insight tab — everything the page renders, computed
/// in [InsightCubit.load] from the focused month's transactions (+ the previous
/// month for month-over-month), categories and budgets. All money fields are
/// positive rupiah ints; the sign is a display concern of `MoneyText`.
@freezed
abstract class InsightReport with _$InsightReport {
  const factory InsightReport({
    /// The month this report covers (first-of-month), for the header selector.
    required DateTime month,

    /// Monthly overview totals (transfers excluded from both).
    @Default(0) int income,
    @Default(0) int expense,

    /// income − expense (can be negative — a display concern of `MoneyText`).
    @Default(0) int saved,

    /// Expense-by-category wedges, sorted by amount desc. Empty → donut empty
    /// state.
    @Default(<CategorySlice>[]) List<CategorySlice> expenseByCategory,

    /// Planned vs. unplanned split of the typed expense subset.
    @Default(PlannedSplit()) PlannedSplit plannedVsUnplanned,

    /// Need/want/lifestyle/emergency shares of the typed expense subset (only
    /// the types that occur are present).
    @Default(<SpendingType, SpendingSlice>{})
    Map<SpendingType, SpendingSlice> needVsWant,

    /// Fired spending-insight cards (only rules that fired — may be empty).
    @Default(<InsightItem>[]) List<InsightItem> insights,

    /// id → Category lookup used to resolve names/colors on the legend.
    @Default(<int, Category>{}) Map<int, Category> categoriesById,
  }) = _InsightReport;

  const InsightReport._();

  bool get hasExpense => expenseByCategory.isNotEmpty;
  bool get hasPlannedData => plannedVsUnplanned.total > 0;
  bool get hasSpendingTypeData => needVsWant.isNotEmpty;
  bool get hasInsights => insights.isNotEmpty;
}

/// Insight state machine: `loaded` carries the computed [InsightReport]. An
/// empty month is a zero-filled `loaded` (each section renders its own empty
/// state), never an `error`.
@freezed
sealed class InsightState with _$InsightState {
  const factory InsightState.initial() = InsightInitial;

  const factory InsightState.loading() = InsightLoading;

  const factory InsightState.loaded(InsightReport report) = InsightLoaded;

  const factory InsightState.error(Failure failure) = InsightError;
}
