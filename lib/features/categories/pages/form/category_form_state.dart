part of 'category_form_cubit.dart';

enum CategoryFormStatus { editing, saving, success, failure }

/// Editable category form fields + the candidate parents for the parent picker.
/// `id` / `sortOrder` / `createdAt` / `archived` are preserved by the cubit on
/// save.
@freezed
abstract class CategoryFormState with _$CategoryFormState {
  const factory CategoryFormState({
    @Default(CategoryType.expense) CategoryType type,
    @Default('') String name,
    int? parentId,
    String? icon,
    int? color,

    /// Top-level, same-type categories offered as a parent (excludes self).
    @Default(<Category>[]) List<Category> parentOptions,
    @Default(CategoryFormStatus.editing) CategoryFormStatus status,
    Failure? error,
    @Default(false) bool isEditing,
  }) = _CategoryFormState;

  const CategoryFormState._();

  /// First failing field for the invalid-submit toast (D1).
  FormValidationError? get firstError =>
      name.trim().isEmpty ? FormValidationError.nameRequired : null;

  bool get isValid => firstError == null;

  bool get isSaving => status == CategoryFormStatus.saving;

  /// The editable fields only (D2) — excludes parentOptions / status / error.
  (CategoryType, String, int?, String?, int?) get formIdentity =>
      (type, name, parentId, icon, color);

  /// The currently selected parent (if any), resolved from [parentOptions].
  Category? get selectedParent {
    for (final c in parentOptions) {
      if (c.id == parentId) return c;
    }
    return null;
  }
}
