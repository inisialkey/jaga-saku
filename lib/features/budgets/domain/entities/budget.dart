import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';

/// A per-category monthly spending budget. Pure domain entity — ids/ints only,
/// no Flutter / data types cross this boundary (rule 19). Mirrors the `budgets`
/// table (M0), plus a non-persisted [spent] view field filled by the join query.
///
/// `UNIQUE(category_id, period)` at the DB level means at most one budget per
/// category per month.
@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    /// The category this budget caps. One budget per category per [period].
    required int categoryId,

    /// The month this budget applies to, as 'YYYY-MM' (see `periodKey`).
    required String period,

    /// The monthly cap in positive rupiah (the form enforces `> 0`).
    required int limitAmount,

    /// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
    int? id,
    @Default(0) int createdAt,

    /// Derived, non-persisted expense total for this category+period, populated
    /// by the datasource's join query; 0 on a plain (non-joined) read.
    @Default(0) int spent,
  }) = _Budget;
}
