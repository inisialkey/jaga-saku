import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction_source.dart';

part 'search_transaction_params.freezed.dart';

/// Result ordering for a transaction search (V3-M3). Maps to a SQL `ORDER BY`
/// in `TransactionQuery.orderBy` (data layer) — pure domain, no SQL here.
enum SortOption { newest, oldest, highest, lowest }

/// The canonical filtered-transaction query contract, shared by Export (V3-M2)
/// and Search (V3-M3). Every facet is nullable — `null` means "no constraint /
/// all"; combined with **AND** semantics. The date window is a half-open
/// `[startDate, endDate)` in epoch millis (mirrors the datasource's existing
/// range reads); the enums reuse the ledger types from [Transaction] and the
/// derived [TransactionSource] rather than re-declaring them.
///
/// Pure domain value object — the `WHERE` / `ORDER BY` translation lives in
/// `TransactionQuery` (data layer), so this stays free of any SQL / Flutter /
/// data dependency (rule 19).
@freezed
abstract class SearchTransactionParams with _$SearchTransactionParams {
  const factory SearchTransactionParams({
    /// Trimmed free-text query; `null`/empty = no keyword. Matched
    /// case-insensitively against `note` + the joined account / target-account /
    /// category names (V3-M3 only — Export never sets it).
    String? keyword,

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

    /// Derived provenance filter (via the category `system_key` join); `null` =
    /// both manual + reconciliation. V3-M3 only — Export never sets it.
    TransactionSource? source,

    /// Inclusive lower amount bound (rupiah); `null` = no minimum.
    int? minAmount,

    /// Inclusive upper amount bound (rupiah); `null` = no maximum.
    int? maxAmount,

    /// Planned/unplanned filter (expense-only column); `null` = all.
    PlannedStatus? plannedStatus,

    /// Spending-bucket filter (expense-only column); `null` = all.
    SpendingType? spendingType,

    /// Receipt filter: `true` = `receipt_path IS NOT NULL`, `false` = `IS NULL`,
    /// `null` = ignore. V3-M3 only — Export never sets it.
    bool? hasReceipt,

    /// Result ordering. Not a facet — it never widens/narrows the row set, so it
    /// is excluded from [hasQuery] and [activeFilterCount].
    @Default(SortOption.newest) SortOption sort,
  }) = _SearchTransactionParams;

  const SearchTransactionParams._();

  /// True when at least one facet constrains the result set — a non-empty
  /// keyword or any active filter (ignoring [sort]). Drives the search screen's
  /// "run the query vs. stay on the prompt" gate.
  bool get hasQuery => _hasKeyword || activeFilterCount > 0;

  /// The amount range is well-formed: either bound may be open, but a set pair
  /// must be `min <= max`. Gated on by the filter sheet's Apply button, so the
  /// query never sees an inverted range.
  bool get isAmountRangeValid =>
      minAmount == null || maxAmount == null || minAmount! <= maxAmount!;

  /// Count of active filter facets (excludes the keyword and [sort]) — feeds the
  /// filter-button badge and the active-filter chip bar. The date range counts
  /// once (either bound set); every other facet counts individually.
  int get activeFilterCount {
    var count = 0;
    if (startDate != null || endDate != null) count++;
    if (accountId != null) count++;
    if (categoryId != null) count++;
    if (type != null) count++;
    if (source != null) count++;
    if (minAmount != null) count++;
    if (maxAmount != null) count++;
    if (plannedStatus != null) count++;
    if (spendingType != null) count++;
    if (hasReceipt != null) count++;
    return count;
  }

  bool get _hasKeyword => keyword != null && keyword!.trim().isNotEmpty;
}
