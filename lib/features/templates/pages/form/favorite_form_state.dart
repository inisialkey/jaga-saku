part of 'favorite_form_cubit.dart';

/// Lifecycle of a form submission. A status enum (rather than nullable flags)
/// gives the page clean one-shot transitions to listen on.
enum FavoriteFormStatus { editing, saving, success, failure }

/// Editable fields of the favorite form + the loaded picker data. Mirrors
/// [AddTransactionState] minus the date, plus a required `label`. `amount` is
/// **optional** — `0` means amount-less (mapped to `null` on save, matching the
/// add-tx save-as-favorite idiom) so a tap prefills the add-form instead of
/// instant-committing. `id` / `sortOrder` / `createdAt` are preserved by the
/// cubit from the initial template on save.
@freezed
abstract class FavoriteFormState with _$FavoriteFormState {
  const factory FavoriteFormState({
    @Default('') String label,
    @Default(TransactionType.expense) TransactionType type,

    /// Optional rupiah amount; `0` = amount-less (asks each time).
    @Default(0) int amount,
    int? accountId,
    int? toAccountId,
    int? categoryId,
    PlannedStatus? plannedStatus,
    SpendingType? spendingType,
    @Default('') String note,

    /// All accounts (incl. archived — filtered by [selectableAccounts]).
    @Default(<Account>[]) List<Account> accounts,

    /// Expense + income categories loaded once; filtered by [categoriesForType].
    @Default(<Category>[]) List<Category> categories,
    @Default(FavoriteFormStatus.editing) FavoriteFormStatus status,
    Failure? error,
    @Default(false) bool isEditing,
  }) = _FavoriteFormState;

  const FavoriteFormState._();

  bool get isSaving => status == FavoriteFormStatus.saving;

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
  /// button. Amount is intentionally excluded (a favorite may be amount-less).
  bool get isValid {
    if (label.trim().isEmpty || accountId == null) return false;
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
