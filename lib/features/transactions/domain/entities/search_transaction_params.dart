import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

part 'search_transaction_params.freezed.dart';

/// The canonical filtered-transaction query contract, shared by Export (V3-M2)
/// and Search (V3-M3). Every field is nullable — `null` means "no constraint /
/// all". The date window is a half-open `[startDate, endDate)` in epoch millis
/// (mirrors the datasource's existing range reads); the three enums reuse the
/// ledger types from [Transaction] rather than re-declaring them.
///
/// Pure domain value object — the `WHERE` translation lives in
/// `TransactionQuery.buildWhere` (data layer), so this stays free of any SQL /
/// Flutter / data dependency (rule 19).
@freezed
abstract class SearchTransactionParams with _$SearchTransactionParams {
  const factory SearchTransactionParams({
    /// Inclusive lower bound (epoch millis); `null` = unbounded start.
    int? startDate,

    /// Exclusive upper bound (epoch millis); `null` = unbounded end.
    int? endDate,

    /// Matches a transaction touching this wallet on either side (source or
    /// transfer target); `null` = every account.
    int? accountId,

    /// Category filter; `null` = every category.
    int? categoryId,

    /// Ledger-type filter; `null` = expense + income + transfer.
    TransactionType? type,

    /// Planned/unplanned filter (expense-only column); `null` = all.
    PlannedStatus? plannedStatus,

    /// Spending-bucket filter (expense-only column); `null` = all.
    SpendingType? spendingType,
  }) = _SearchTransactionParams;
}
