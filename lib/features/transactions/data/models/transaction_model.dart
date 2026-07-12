import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

part 'transaction_model.freezed.dart';

/// Data-layer row model for the `transactions` table. Maps are hand-written (no
/// `json_serializable`) because the shape is a SQLite row, not JSON: the three
/// enums map to their string [value]s, nullable enums come from nullable TEXT
/// columns, and money is a plain `INTEGER` of rupiah.
@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required TransactionType type,
    required int amount,
    required int accountId,
    int? id,
    int? toAccountId,
    int? categoryId,
    PlannedStatus? plannedStatus,
    SpendingType? spendingType,
    @Default(0) int date,
    String? note,
    @Default(0) int createdAt,
    String? receiptPath,
  }) = _TransactionModel;

  const TransactionModel._();

  factory TransactionModel.fromMap(Map<String, Object?> map) =>
      TransactionModel(
        id: map['id'] as int?,
        type: TransactionType.fromValue(map['type'] as String?),
        amount: (map['amount'] as int?) ?? 0,
        accountId: (map['account_id'] as int?) ?? 0,
        toAccountId: map['to_account_id'] as int?,
        categoryId: map['category_id'] as int?,
        plannedStatus: PlannedStatus.fromValue(
          map['planned_status'] as String?,
        ),
        spendingType: SpendingType.fromValue(map['spending_type'] as String?),
        date: (map['date'] as int?) ?? 0,
        note: map['note'] as String?,
        createdAt: (map['created_at'] as int?) ?? 0,
        receiptPath: map['receipt_path'] as String?,
      );

  factory TransactionModel.fromEntity(Transaction transaction) =>
      TransactionModel(
        id: transaction.id,
        type: transaction.type,
        amount: transaction.amount,
        accountId: transaction.accountId,
        toAccountId: transaction.toAccountId,
        categoryId: transaction.categoryId,
        plannedStatus: transaction.plannedStatus,
        spendingType: transaction.spendingType,
        date: transaction.date,
        note: transaction.note,
        createdAt: transaction.createdAt,
        receiptPath: transaction.receiptPath,
      );

  /// Column map for insert/update. Omits `id` when null so AUTOINCREMENT fires;
  /// nullable enums write `null` (not an empty string) so `fromMap` round-trips.
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'type': type.value,
    'amount': amount,
    'account_id': accountId,
    'to_account_id': toAccountId,
    'category_id': categoryId,
    'planned_status': plannedStatus?.value,
    'spending_type': spendingType?.value,
    'date': date,
    'note': note,
    'created_at': createdAt,
    'receipt_path': receiptPath,
  };

  Transaction toEntity() => Transaction(
    id: id,
    type: type,
    amount: amount,
    accountId: accountId,
    toAccountId: toAccountId,
    categoryId: categoryId,
    plannedStatus: plannedStatus,
    spendingType: spendingType,
    date: date,
    note: note,
    createdAt: createdAt,
    receiptPath: receiptPath,
  );
}
