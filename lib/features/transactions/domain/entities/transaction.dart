import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

/// The kind of ledger entry. Persisted as its [value] string in
/// `transactions.type`; the sign of the amount is implied by the type (schema
/// stores a positive INTEGER — rule 19, no raw strings in the entity).
enum TransactionType {
  expense('expense'),
  income('income'),
  transfer('transfer');

  const TransactionType(this.value);

  /// Stored representation (the `type` column value).
  final String value;

  /// Maps a stored string back to the enum, defaulting to [expense] for an
  /// unknown / legacy value (never throws).
  static TransactionType fromValue(String? value) =>
      TransactionType.values.firstWhere(
        (t) => t.value == value,
        orElse: () => TransactionType.expense,
      );
}

/// Whether an expense was planned ahead of time. Expense-only; persisted as
/// [value] in the nullable `planned_status` column (null for income/transfer).
enum PlannedStatus {
  planned('planned'),
  unplanned('unplanned');

  const PlannedStatus(this.value);

  final String value;

  /// Maps a stored string to the enum; `null` for a null / unknown value (the
  /// column is nullable — income & transfer rows leave it empty).
  static PlannedStatus? fromValue(String? value) {
    if (value == null) return null;
    for (final s in PlannedStatus.values) {
      if (s.value == value) return s;
    }
    return null;
  }
}

/// The spending bucket for an expense (need vs. discretionary). Expense-only;
/// persisted as [value] in the nullable `spending_type` column.
enum SpendingType {
  need('need'),
  want('want'),
  lifestyle('lifestyle'),
  emergency('emergency');

  const SpendingType(this.value);

  final String value;

  /// Maps a stored string to the enum; `null` for a null / unknown value.
  static SpendingType? fromValue(String? value) {
    if (value == null) return null;
    for (final s in SpendingType.values) {
      if (s.value == value) return s;
    }
    return null;
  }
}

/// A ledger entry (expense / income / transfer). Pure domain entity — ids are
/// plain `int`s, [date] / [createdAt] are epoch millis, and the amount is a
/// positive rupiah `int` whose sign is implied by [type]. No Flutter / data
/// types cross this boundary (rule 19).
///
/// Field shape mirrors the `transactions` table 1:1:
/// - [accountId] is the source account (the "From" account for a transfer).
/// - [toAccountId] is set only for a transfer (the destination, must differ
///   from [accountId]); `null` otherwise.
/// - [categoryId] is set for expense / income; `null` for a transfer.
/// - [plannedStatus] & [spendingType] are expense-only; `null` otherwise.
@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required TransactionType type,

    /// Positive rupiah amount (> 0); the sign is derived from [type].
    required int amount,

    /// Source account id (the "From" account for a transfer).
    required int accountId,

    /// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
    int? id,

    /// Destination account id — transfer only, must differ from [accountId].
    int? toAccountId,

    /// Category id — expense / income only (`null` for a transfer).
    int? categoryId,

    /// Planned vs. unplanned — expense only.
    PlannedStatus? plannedStatus,

    /// Need / want / lifestyle / emergency — expense only.
    SpendingType? spendingType,

    /// Day the entry belongs to, stored as midnight-local epoch millis so
    /// day-grouping is deterministic. Time-of-day lives in [createdAt].
    @Default(0) int date,
    String? note,
    @Default(0) int createdAt,

    /// Relative path (`receipts/<micros>.jpg`) under app-docs, resolved at read;
    /// null when the entry has no receipt. I/O, not aggregation (no effect on
    /// TransactionType / spend / balance).
    String? receiptPath,
  }) = _Transaction;
}
