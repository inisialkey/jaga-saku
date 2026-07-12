import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

part 'tx_template_model.freezed.dart';

/// Data-layer row model for the `tx_templates` table. Maps are hand-written (no
/// `json_serializable`) because the shape is a SQLite row, not JSON: the three
/// enums map to their string [value]s, nullable enums come from nullable TEXT
/// columns, `amount` is a nullable rupiah `INTEGER`, and `is_favorite` maps
/// int-1/0 ↔ bool (like `AccountModel.archived`).
@freezed
abstract class TxTemplateModel with _$TxTemplateModel {
  const factory TxTemplateModel({
    required String label,
    required TransactionType type,
    required int accountId,
    int? id,
    int? amount,
    int? toAccountId,
    int? categoryId,
    PlannedStatus? plannedStatus,
    SpendingType? spendingType,
    String? note,
    @Default(true) bool isFavorite,
    @Default(0) int sortOrder,
    @Default(0) int createdAt,
  }) = _TxTemplateModel;

  const TxTemplateModel._();

  factory TxTemplateModel.fromMap(Map<String, Object?> map) => TxTemplateModel(
    id: map['id'] as int?,
    label: (map['label'] as String?) ?? '',
    type: TransactionType.fromValue(map['type'] as String?),
    amount: map['amount'] as int?,
    accountId: (map['account_id'] as int?) ?? 0,
    toAccountId: map['to_account_id'] as int?,
    categoryId: map['category_id'] as int?,
    plannedStatus: PlannedStatus.fromValue(map['planned_status'] as String?),
    spendingType: SpendingType.fromValue(map['spending_type'] as String?),
    note: map['note'] as String?,
    isFavorite: ((map['is_favorite'] as int?) ?? 1) == 1,
    sortOrder: (map['sort_order'] as int?) ?? 0,
    createdAt: (map['created_at'] as int?) ?? 0,
  );

  factory TxTemplateModel.fromEntity(TxTemplate template) => TxTemplateModel(
    id: template.id,
    label: template.label,
    type: template.type,
    amount: template.amount,
    accountId: template.accountId,
    toAccountId: template.toAccountId,
    categoryId: template.categoryId,
    plannedStatus: template.plannedStatus,
    spendingType: template.spendingType,
    note: template.note,
    isFavorite: template.isFavorite,
    sortOrder: template.sortOrder,
    createdAt: template.createdAt,
  );

  /// Column map for insert/update. Omits `id` when null so AUTOINCREMENT fires;
  /// nullable enums / amount write `null` (not empty) so `fromMap` round-trips;
  /// `is_favorite` writes 1/0.
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'label': label,
    'type': type.value,
    'amount': amount,
    'account_id': accountId,
    'to_account_id': toAccountId,
    'category_id': categoryId,
    'planned_status': plannedStatus?.value,
    'spending_type': spendingType?.value,
    'note': note,
    'is_favorite': isFavorite ? 1 : 0,
    'sort_order': sortOrder,
    'created_at': createdAt,
  };

  TxTemplate toEntity() => TxTemplate(
    id: id,
    label: label,
    type: type,
    amount: amount,
    accountId: accountId,
    toAccountId: toAccountId,
    categoryId: categoryId,
    plannedStatus: plannedStatus,
    spendingType: spendingType,
    note: note,
    isFavorite: isFavorite,
    sortOrder: sortOrder,
    createdAt: createdAt,
  );
}
