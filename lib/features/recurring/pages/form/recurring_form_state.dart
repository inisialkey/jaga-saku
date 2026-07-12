part of 'recurring_form_cubit.dart';

/// Lifecycle of a form submission — a status enum gives the page clean one-shot
/// transitions to listen on.
enum RecurringFormStatus { editing, saving, success, failure }

/// Editable fields of the recurring form + the loaded picker data. Mirrors the
/// favorite form (M2) but amount is **required** (`> 0`, no amount-less path —
/// auto-generation needs it) and it adds the schedule: [freq] / [interval] /
/// [startDate] / optional [endDate].
@freezed
abstract class RecurringFormState with _$RecurringFormState {
  const factory RecurringFormState({
    @Default('') String label,
    @Default(TransactionType.expense) TransactionType type,

    /// Required rupiah amount (`> 0`) — [isValid] blocks a zero.
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
    @Default(RecurringFormStatus.editing) RecurringFormStatus status,
    Failure? error,
    @Default(false) bool isEditing,

    // ── Schedule ──
    @Default(RecurrenceFreq.monthly) RecurrenceFreq freq,
    @Default(1) int interval,

    /// First occurrence + the clamp anchor (midnight-local millis); required.
    int? startDate,

    /// Optional inclusive last bound (midnight-local millis).
    int? endDate,
  }) = _RecurringFormState;

  const RecurringFormState._();

  bool get isSaving => status == RecurringFormStatus.saving;

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

  /// All required fields for the current type are present AND amount > 0 AND a
  /// start date is set AND (no end date OR end ≥ start) — drives the Save button.
  bool get isValid {
    if (label.trim().isEmpty || accountId == null) return false;
    if (amount <= 0) return false;
    if (startDate == null) return false;
    if (endDate != null && endDate! < startDate!) return false;
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
