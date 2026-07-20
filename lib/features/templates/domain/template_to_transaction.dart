import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// The canonical "favorite shape → [Transaction]" builder — **flutter-free, no
/// DB, no clock** (rule 19; the fifth pure calculation helper after
/// `BudgetStatus`, `insight_rules`, `TransactionAggregator`, `BudgetCycle`).
/// Introduced for V2-M2 favorites and now used by V2-M5 recurring — its one
/// production caller is [ConfirmOccurrence]. (The Home instant-commit path this
/// was originally written for is gone: V4-W3 replaced it with a form prefill.)
///
/// Resolves the amount from [amount] (an override, e.g. an amount-less favorite
/// the user just entered) falling back to [TxTemplate.amount], and applies the
/// same field-dropping as `AddTransactionCubit._commit`: a transfer keeps
/// [TxTemplate.toAccountId] and drops category / planned / spending; expense &
/// income drop the transfer destination.
///
/// [createdAt] is left `0` (the persist-time clock is a caller concern — the
/// caller stamps it before saving), keeping this helper deterministic.
/// Asserts a non-null resolved amount: an amount-less template must take the
/// form-prefill path, never this builder.
Transaction templateToTransaction(
  TxTemplate t, {
  required int date,
  int? amount,
}) {
  final resolved = amount ?? t.amount;
  assert(
    resolved != null,
    'templateToTransaction needs an amount for an amount-less template',
  );
  final isTransfer = t.type == TransactionType.transfer;
  final isExpense = t.type == TransactionType.expense;
  return Transaction(
    type: t.type,
    amount: resolved!,
    accountId: t.accountId,
    toAccountId: isTransfer ? t.toAccountId : null,
    categoryId: isTransfer ? null : t.categoryId,
    plannedStatus: isExpense ? t.plannedStatus : null,
    spendingType: isExpense ? t.spendingType : null,
    date: date,
    note: t.note,
  );
}
