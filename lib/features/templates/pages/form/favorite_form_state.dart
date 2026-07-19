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
abstract class FavoriteFormState with _$FavoriteFormState, TxFormFields {
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

  /// First failing field for the invalid-submit toast (D1), in the same order as
  /// [isValid]. Amount is intentionally excluded (a favorite may be amount-less).
  FormValidationError? get firstError {
    if (label.trim().isEmpty) return FormValidationError.labelRequired;
    if (accountId == null) return FormValidationError.accountRequired;
    if (isTransfer) {
      if (toAccountId == null) return FormValidationError.toAccountRequired;
      if (toAccountId == accountId) {
        return FormValidationError.transferSameAccount;
      }
    } else if (categoryId == null) {
      return FormValidationError.categoryRequired;
    }
    return null;
  }

  /// All required fields for the current type are present — drives the Save
  /// button. Amount is intentionally excluded (a favorite may be amount-less).
  bool get isValid => firstError == null;

  /// The editable fields only (D2) — excludes accounts / categories / status.
  (
    String,
    TransactionType,
    int,
    int?,
    int?,
    int?,
    PlannedStatus?,
    SpendingType?,
    String,
  )
  get formIdentity => (
    label,
    type,
    amount,
    accountId,
    toAccountId,
    categoryId,
    plannedStatus,
    spendingType,
    note,
  );
}
