import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';

part 'budget_model.freezed.dart';

/// Data-layer row model for the `budgets` table. Maps are hand-written (no
/// `json_serializable`) because the shape is a SQLite row, not JSON. The derived
/// `spent` column comes from the datasource's expense-sum join and is never
/// written back (it is not a table column).
@freezed
abstract class BudgetModel with _$BudgetModel {
  const factory BudgetModel({
    required int categoryId,
    required String period,
    required int limitAmount,
    int? id,
    @Default(0) int createdAt,

    /// The cycle window (local-midnight millis, half-open `[start, end)`). V2-M1.
    @Default(0) int periodStart,
    @Default(0) int periodEnd,
    @Default(0) int spent,
  }) = _BudgetModel;

  const BudgetModel._();

  /// Builds a model from a `SELECT b.*, ... AS spent` row. `spent` may be absent
  /// (plain reads) — it then defaults to 0. `period_start` / `period_end` fall
  /// back to the `period` label's calendar-month bounds — belt-and-suspenders,
  /// since `_v7` backfills every row so null never actually reaches here.
  factory BudgetModel.fromMap(Map<String, Object?> map) {
    final period = map['period']! as String;
    return BudgetModel(
      id: map['id'] as int?,
      categoryId: map['category_id']! as int,
      period: period,
      limitAmount: (map['limit_amount'] as int?) ?? 0,
      createdAt: (map['created_at'] as int?) ?? 0,
      periodStart: (map['period_start'] as int?) ?? _monthStart(period),
      periodEnd: (map['period_end'] as int?) ?? _monthEnd(period),
      spent: (map['spent'] as int?) ?? 0,
    );
  }

  factory BudgetModel.fromEntity(Budget budget) => BudgetModel(
    id: budget.id,
    categoryId: budget.categoryId,
    period: budget.period,
    limitAmount: budget.limitAmount,
    createdAt: budget.createdAt,
    periodStart: budget.periodStart,
    periodEnd: budget.periodEnd,
    spent: budget.spent,
  );

  /// Column map for insert/update. Omits `id` when null so AUTOINCREMENT fires,
  /// and omits the derived `spent` (not a column).
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'category_id': categoryId,
    'period': period,
    'limit_amount': limitAmount,
    'created_at': createdAt,
    'period_start': periodStart,
    'period_end': periodEnd,
  };

  Budget toEntity() => Budget(
    id: id,
    categoryId: categoryId,
    period: period,
    limitAmount: limitAmount,
    createdAt: createdAt,
    periodStart: periodStart,
    periodEnd: periodEnd,
    spent: spent,
  );

  /// Calendar-month start millis for a 'YYYY-MM' [period] (the backfill formula).
  static int _monthStart(String period) {
    final parts = period.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
    ).millisecondsSinceEpoch;
  }

  /// Calendar-month end millis (exclusive) for a 'YYYY-MM' [period].
  static int _monthEnd(String period) {
    final parts = period.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]) + 1,
    ).millisecondsSinceEpoch;
  }
}
