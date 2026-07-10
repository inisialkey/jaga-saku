part of 'budget_form_cubit.dart';

/// Lifecycle of a form submission. A status enum (rather than a nullable flag)
/// gives the page clean one-shot transitions to listen on.
enum BudgetFormStatus { editing, saving, success, failure }

/// Editable budget form fields + submission status. `id` / `createdAt` are
/// preserved by the cubit from the initial budget (or resolved from an existing
/// row) on save; everything the UI edits lives here.
@freezed
abstract class BudgetFormState with _$BudgetFormState {
  const factory BudgetFormState({
    /// First-of-month for the selected period.
    required DateTime month,
    int? categoryId,
    @Default(0) int limitAmount,

    /// Active expense categories for the picker.
    @Default(<Category>[]) List<Category> categories,
    @Default(BudgetFormStatus.editing) BudgetFormStatus status,
    Failure? error,
    @Default(false) bool isEditing,
  }) = _BudgetFormState;

  const BudgetFormState._();

  /// Submit is allowed once a category is chosen and the limit is positive.
  bool get isValid => categoryId != null && limitAmount > 0;

  bool get isSaving => status == BudgetFormStatus.saving;

  Category? get selectedCategory {
    for (final c in categories) {
      if (c.id == categoryId) return c;
    }
    return null;
  }
}
