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

  /// Submit is allowed once the name is non-empty (opening balance is always
  /// >= 0 — the amount field is digits-only).
  bool get isValid => name.trim().isNotEmpty && openingBalance >= 0;

  bool get isSaving => status == AccountFormStatus.saving;
}
