import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

part 'tx_template.freezed.dart';

/// A saved transaction *shape* — "a [Transaction] without a date" (V2-M2). The
/// user taps a favorite to log it in one action; V2-M5 recurring fires the same
/// shape on a schedule. Field shape mirrors the `tx_templates` table 1:1 and
/// reuses the ledger's [TransactionType] / [PlannedStatus] / [SpendingType]
/// enums (domain→domain, rule 19 — no Flutter / data types cross this boundary).
///
/// - [amount] is nullable: `null` means "ask each time" (the prefill path);
///   a set amount enables one-tap instant commit.
/// - [accountId] is the source account (the "From" account for a transfer).
/// - [toAccountId] is set only for a transfer; `null` otherwise.
/// - [categoryId] is set for expense / income; `null` for a transfer.
/// - [plannedStatus] & [spendingType] are expense-only; `null` otherwise.
/// - [isFavorite] filters the Home strip (`true`/int 1) from M5 schedule-only
///   shapes (`false`/int 0), like `Account.archived` maps int↔bool.
@freezed
abstract class TxTemplate with _$TxTemplate {
  const factory TxTemplate({
    required String label,
    required TransactionType type,

    /// Source account id (the "From" account for a transfer).
    required int accountId,

    /// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
    int? id,

    /// Positive rupiah amount, or `null` = ask at use (the prefill path).
    int? amount,

    /// Destination account id — transfer only.
    int? toAccountId,

    /// Category id — expense / income only.
    int? categoryId,

    /// Planned vs. unplanned — expense only.
    PlannedStatus? plannedStatus,

    /// Need / want / lifestyle / emergency — expense only.
    SpendingType? spendingType,
    String? note,

    /// `true` (int 1) = a Home favorite; `false` (int 0) = M5 schedule-only.
    @Default(true) bool isFavorite,
    @Default(0) int sortOrder,
    @Default(0) int createdAt,
  }) = _TxTemplate;
}
