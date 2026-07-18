import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction_source.dart';

part 'export_row.freezed.dart';

/// One typed, join-resolved CSV row — the output of the export query, mapped
/// from a joined `transactions` row by the export repository. Fields map 1:1 to
/// the CSV columns (in header order): readable [account] / [targetAccount] /
/// [category] names replace the raw ids, [source] is the derived
/// manual/reconciliation label, and [receiptAttached] hides the device-local
/// receipt path behind a yes/no. Amounts stay positive (the sign is implied by
/// [type], matching the ledger entity).
@freezed
abstract class ExportRow with _$ExportRow {
  const factory ExportRow({
    /// Day the entry belongs to (epoch millis) → ISO `YYYY-MM-DD`.
    required int date,
    required TransactionType type,
    required TransactionSource source,

    /// Source account name (empty if the account was hard-deleted).
    required String account,

    /// Positive rupiah amount; sign is carried by [type].
    required int amount,

    /// Row creation time (epoch millis) → ISO `YYYY-MM-DD HH:mm`.
    required int createdAt,

    /// True when the row has a stored receipt path (the path itself is never
    /// exported — it is device-local).
    required bool receiptAttached,

    /// Transfer destination name; `null` for non-transfers.
    String? targetAccount,

    /// Category name; `null` for a transfer.
    String? category,

    /// Expense-only; `null` otherwise.
    PlannedStatus? plannedStatus,

    /// Expense-only; `null` otherwise.
    SpendingType? spendingType,
    String? note,
  }) = _ExportRow;
}
