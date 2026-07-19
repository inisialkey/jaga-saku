part of 'add_transaction_cubit.dart';

/// Lifecycle of a submission. A status enum (rather than nullable flags) gives
/// the page clean one-shot transitions to listen on. [needsBudgetConfirm] is the
/// budget-guard pause (plan §5): validation passed but the expense breaches its
/// category's safe-daily, so the page must confirm before the cubit commits.
enum AddTxStatus { editing, saving, success, failure, needsBudgetConfirm }

/// Why the last submit was rejected before touching the datasource. [none] means
/// the failure (if any) came from the save itself, carried in `error`. The page
/// maps a non-[none] value to a localized toast (rule 17 — no raw strings).
enum AddTxValidation {
  none,
  amountRequired,
  accountRequired,
  categoryRequired,
  toAccountRequired,
  transferSameAccount,
}

/// Working fields of the add/edit transaction form + the loaded picker data.
/// `id` / `createdAt` are preserved by the cubit from the initial transaction on
/// save; everything the UI edits lives here.
@freezed
abstract class AddTransactionState with _$AddTransactionState, TxFormFields {
  const factory AddTransactionState({
    @Default(TransactionType.expense) TransactionType type,
    @Default(0) int amount,
    int? accountId,
    int? toAccountId,
    int? categoryId,
    PlannedStatus? plannedStatus,
    SpendingType? spendingType,

    /// Selected day as midnight-local epoch millis.
    @Default(0) int date,
    @Default('') String note,

    /// All accounts (incl. archived — filtered by [selectableAccounts]).
    @Default(<Account>[]) List<Account> accounts,

    /// Expense + income categories loaded once; filtered by [categoriesForType].
    @Default(<Category>[]) List<Category> categories,
    @Default(AddTxStatus.editing) AddTxStatus status,
    @Default(AddTxValidation.none) AddTxValidation validation,
    Failure? error,
    @Default(false) bool isEditing,

    /// The category's safe-daily allowance, set when [status] is
    /// [AddTxStatus.needsBudgetConfirm]; drives the warning sheet.
    @Default(0) int safeDaily,

    /// Relative receipt path being edited. Non-nullable with a `''` sentinel (=
    /// "no receipt") so `copyWith` handles pick/remove — freezed's copyWith can't
    /// set a field back to null (see [AddTransactionCubit.typeChanged]). `_commit`
    /// maps `''`→null. Mirrors how `amount` (0) and `note` ('') model "empty".
    @Default('') String receiptPath,
  }) = _AddTransactionState;

  const AddTransactionState._();

  bool get isSaving => status == AddTxStatus.saving;

  /// All required fields for the current type are present — drives the Save
  /// button's enabled state. Mirrors the cubit's submit-time validation.
  bool get isValid {
    if (amount <= 0 || accountId == null) return false;
    if (isTransfer) return toAccountId != null && toAccountId != accountId;
    return categoryId != null;
  }

  /// The editable fields only (D2) — excludes accounts / categories / status /
  /// validation / safeDaily. `receiptPath` is included so an attached-but-unsaved
  /// receipt correctly marks the form dirty (the audit's headline unsaved case).
  (
    TransactionType,
    int,
    int?,
    int?,
    int?,
    PlannedStatus?,
    SpendingType?,
    int,
    String,
    String,
  )
  get formIdentity => (
    type,
    amount,
    accountId,
    toAccountId,
    categoryId,
    plannedStatus,
    spendingType,
    date,
    note,
    receiptPath,
  );
}
