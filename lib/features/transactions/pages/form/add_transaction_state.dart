part of 'add_transaction_cubit.dart';

/// Lifecycle of a submission. A status enum (rather than nullable flags) gives
/// the page clean one-shot transitions to listen on.
enum AddTxStatus { editing, saving, success, failure }

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
abstract class AddTransactionState with _$AddTransactionState {
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
  }) = _AddTransactionState;

  const AddTransactionState._();

  bool get isSaving => status == AddTxStatus.saving;

  bool get isTransfer => type == TransactionType.transfer;

  bool get isExpense => type == TransactionType.expense;

  /// Active (non-archived) accounts offered by the account pickers.
  List<Account> get selectableAccounts =>
      accounts.where((a) => !a.archived).toList();

  /// Non-archived categories matching the current [type] for the category picker.
  List<Category> get categoriesForType =>
      categories.where((c) => !c.archived && _typeMatches(c)).toList();

  Account? get selectedAccount => _accountById(accountId);

  Account? get selectedToAccount => _accountById(toAccountId);

  Category? get selectedCategory {
    for (final c in categories) {
      if (c.id == categoryId) return c;
    }
    return null;
  }

  /// All required fields for the current type are present — drives the Save
  /// button's enabled state. Mirrors the cubit's submit-time validation.
  bool get isValid {
    if (amount <= 0 || accountId == null) return false;
    if (isTransfer) return toAccountId != null && toAccountId != accountId;
    return categoryId != null;
  }

  bool _typeMatches(Category c) => switch (type) {
    TransactionType.income => c.type == CategoryType.income,
    _ => c.type == CategoryType.expense,
  };

  Account? _accountById(int? id) {
    if (id == null) return null;
    for (final a in accounts) {
      if (a.id == id) return a;
    }
    return null;
  }
}
