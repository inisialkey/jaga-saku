import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';

/// A per-category spending budget for one cycle. Pure domain entity — ids/ints
/// only, no Flutter / data types cross this boundary (rule 19). Mirrors the
/// `budgets` table (M0 + V2-M1), plus a non-persisted [spent] view field filled
/// by the join query.
///
/// V2-M1: the cycle is stored explicitly as the half-open millis range
/// `[periodStart, periodEnd)`; [period] is KEPT as the display + lookup label
/// (`periodKey(periodStart)` — the calendar month of the cycle's start). At the
/// default start-day 1, cycle == calendar month, so every pre-M1 budget is
/// byte-identical. `UNIQUE(category_id, period)` + a unique index on
/// `(category_id, period_start)` keep at most one budget per category per cycle.
@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    /// The category this budget caps. One budget per category per [period].
    required int categoryId,

    /// The cycle's display + lookup label, as 'YYYY-MM' (the calendar month of
    /// [periodStart]; see `periodKey`).
    required String period,

    /// The monthly cap in positive rupiah (the form enforces `> 0`).
    required int limitAmount,

    /// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
    int? id,
    @Default(0) int createdAt,

    /// Local-midnight epoch millis of the cycle's start (inclusive). `0` only on
    /// a legacy/unmapped row — post-`_v7` every persisted row is backfilled.
    @Default(0) int periodStart,

    /// Local-midnight epoch millis of the cycle's end (exclusive — the next
    /// cycle's start). Spend/remaining are computed off `[periodStart, periodEnd)`.
    @Default(0) int periodEnd,

    /// Derived, non-persisted expense total for this category+cycle, populated
    /// by the datasource's join query; 0 on a plain (non-joined) read.
    @Default(0) int spent,
  }) = _Budget;
}
