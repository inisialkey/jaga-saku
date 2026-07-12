part of 'money_story_cubit.dart';

/// View-model for the Money Story screen (V2-M7) — the focused month's narrative
/// recap plus the reconstructed 12-month net-worth [trend]. All card figures are
/// **system-category-excluded** (a reconcile adjustment moves balance, not the
/// story); the [trend] is NOT excluded (adjustments move real assets). Money
/// fields are rupiah ints; the sign is a display concern of `MoneyText`.
@freezed
abstract class MoneyStory with _$MoneyStory {
  const factory MoneyStory({
    /// The focused month (first-of-month), for the header selector.
    required DateTime month,

    /// Overview totals, transfers + system categories excluded.
    @Default(0) int income,
    @Default(0) int expense,

    /// income − expense (negative in a deficit month).
    @Default(0) int saved,

    /// `saved / income`, whole percent; 0 when income is 0 (÷0 guard). Negative
    /// in a deficit month.
    @Default(0) int savingsRatePct,

    /// `saved < 0` — flips the hero copy + `MoneyText` sign/color.
    @Default(false) bool isDeficit,

    /// Biggest expense category this month (system excluded), or null.
    int? topCategoryId,
    @Default(0) int topCategoryAmount,

    /// The single largest real expense row (system excluded), or null.
    Transaction? biggestExpense,

    /// Signed month-over-month deltas vs the previous month.
    @Default(0) int momIncome,
    @Default(0) int momExpense,

    /// Need/want/lifestyle/emergency shares of the typed expense subset.
    @Default(<SpendingType, SpendingSlice>{})
    Map<SpendingType, SpendingSlice> needVsWant,

    /// Reconstructed net-worth points (trailing 12 months), oldest→newest.
    @Default(<TrendPoint>[]) List<TrendPoint> trend,

    /// Current net worth = `trend.last.netWorth` (or the baseline if empty).
    @Default(0) int netWorth,

    /// id → Category / Account lookups to resolve names, icons, colors.
    @Default(<int, Category>{}) Map<int, Category> categoriesById,
    @Default(<int, Account>{}) Map<int, Account> accountsById,
  }) = _MoneyStory;

  const MoneyStory._();

  /// A month with any real activity worth narrating (income, expense or a
  /// biggest expense). Empty → the screen shows its empty state and no cards.
  bool get hasData => income != 0 || expense != 0 || biggestExpense != null;

  /// The top spending category resolved from the lookup, or null.
  Category? get topCategory =>
      topCategoryId == null ? null : categoriesById[topCategoryId];
}

/// Money Story state machine: `loaded` carries the computed [MoneyStory]. An
/// empty month is a zero-filled `loaded` (the page shows its empty state), never
/// an `error`.
@freezed
sealed class MoneyStoryState with _$MoneyStoryState {
  const factory MoneyStoryState.initial() = MoneyStoryInitial;

  const factory MoneyStoryState.loading() = MoneyStoryLoading;

  const factory MoneyStoryState.loaded(MoneyStory story) = MoneyStoryLoaded;

  const factory MoneyStoryState.error(Failure failure) = MoneyStoryError;
}
