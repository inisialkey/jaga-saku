part of 'account_form_cubit.dart';

/// Lifecycle of a form submission. A status enum (rather than a nullable flag)
/// gives the page clean one-shot transitions to listen on — freezed `copyWith`
/// cannot reset a nullable field back to null.
enum AccountFormStatus { editing, saving, success, failure }

/// Editable form fields + submission status. `id` / `sortOrder` / `createdAt`
/// / `archived` are not edited here — the cubit preserves them from the initial
/// account when saving.
@freezed
abstract class AccountFormState with _$AccountFormState {
  const factory AccountFormState({
    @Default(AccountType.cash) AccountType type,
    @Default('') String name,
    @Default(0) int openingBalance,
    String? icon,
    int? color,
    @Default(AccountFormStatus.editing) AccountFormStatus status,
    Failure? error,
    @Default(false) bool isEditing,
  }) = _AccountFormState;

  const AccountFormState._();

  /// First failing field for the invalid-submit toast (D1), in the same order as
  /// [isValid]. `openingBalance` is clamped to >= 0 by the cubit
  /// (`openingBalanceChanged`), so only the name can fail here.
  FormValidationError? get firstError =>
      name.trim().isEmpty ? FormValidationError.nameRequired : null;

  /// Submit is allowed once the name is non-empty (`openingBalance` is clamped
  /// to >= 0 in the cubit, so it can never be the blocker).
  bool get isValid => firstError == null;

  bool get isSaving => status == AccountFormStatus.saving;

  /// The editable fields only (D2) — excludes status / error / loaded lists — so
  /// a pristine form compares equal to its seed and `hasEdits` stays false until
  /// the user actually changes something.
  (AccountType, String, int, String?, int?) get formIdentity =>
      (type, name, openingBalance, icon, color);
}
