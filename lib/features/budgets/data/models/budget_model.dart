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
    @Default(0) int spent,
  }) = _BudgetModel;

  const BudgetModel._();

  /// Builds a model from a `SELECT b.*, ... AS spent` row. `spent` may be absent
  /// (plain reads) — it then defaults to 0.
  factory BudgetModel.fromMap(Map<String, Object?> map) => BudgetModel(
    id: map['id'] as int?,
    categoryId: map['category_id']! as int,
    period: map['period']! as String,
    limitAmount: (map['limit_amount'] as int?) ?? 0,
    createdAt: (map['created_at'] as int?) ?? 0,
    spent: (map['spent'] as int?) ?? 0,
  );

  factory BudgetModel.fromEntity(Budget budget) => BudgetModel(
    id: budget.id,
    categoryId: budget.categoryId,
    period: budget.period,
    limitAmount: budget.limitAmount,
    createdAt: budget.createdAt,
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
  };

  Budget toEntity() => Budget(
    id: id,
    categoryId: categoryId,
    period: period,
    limitAmount: limitAmount,
    createdAt: createdAt,
    spent: spent,
  );
}
