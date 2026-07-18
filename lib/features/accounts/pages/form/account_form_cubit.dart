import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/form/form_validation.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/save_account.dart';

part 'account_form_state.dart';
part 'account_form_cubit.freezed.dart';

/// Backs the create/edit account form. Seeds fields from [initial] when editing;
/// [submit] validates, calls [SaveAccount] and folds the result into a
/// success / failure status the page listens on.
class AccountFormCubit extends Cubit<AccountFormState> {
  AccountFormCubit({required SaveAccount saveAccount, Account? initial})
    : _saveAccount = saveAccount,
      _initial = initial,
      super(
        initial == null
            ? const AccountFormState()
            : AccountFormState(
                type: initial.type,
                name: initial.name,
                openingBalance: initial.openingBalance,
                icon: initial.icon,
                color: initial.color,
                isEditing: true,
              ),
      ) {
    _seedState = state;
  }

  final SaveAccount _saveAccount;
  final Account? _initial;

  /// The seed (initial editable fields), captured post-construction so [hasEdits]
  /// can drive the unsaved-changes guard (D2).
  late final AccountFormState _seedState;

  /// The account being edited (its id + derived balance), or null for a new
  /// account. Read by the page to launch the reconcile sheet — only reached when
  /// `state.isEditing`, so it is non-null there (V2-M6).
  Account? get initial => _initial;

  /// True once the user has changed an editable field from the seed (D2).
  bool get hasEdits => state.formIdentity != _seedState.formIdentity;

  void typeChanged(AccountType type) => emit(state.copyWith(type: type));

  void nameChanged(String name) => emit(state.copyWith(name: name));

  void openingBalanceChanged(int value) =>
      // Opening balance can't be negative (cash / bank / e-wallet accounts).
      // The shared calculator keypad CAN produce a negative, so clamp it here at
      // the single funnel — this is what makes the `firstError` invariant
      // ("openingBalance is always >= 0, so only the name can fail") actually
      // hold, rather than assuming the input is digits-only.
      emit(state.copyWith(openingBalance: value < 0 ? 0 : value));

  void iconChanged(String? icon) => emit(state.copyWith(icon: icon));

  void colorChanged(int? color) => emit(state.copyWith(color: color));

  Future<void> submit() async {
    if (state.isSaving) return;
    if (!state.isValid) {
      // D1: surface the first failing field via the page's failure listener
      // (toast) instead of a silent no-op behind a disabled button.
      emit(state.copyWith(status: AccountFormStatus.failure));
      return;
    }
    emit(state.copyWith(status: AccountFormStatus.saving));

    final base = _initial ?? const Account(name: '', type: AccountType.cash);
    final account = base.copyWith(
      name: state.name.trim(),
      type: state.type,
      openingBalance: state.openingBalance,
      icon: state.icon,
      color: state.color,
      createdAt: _initial?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
    );

    final result = await _saveAccount(account);
    if (isClosed) return;
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: AccountFormStatus.failure, error: failure),
        (_) => state.copyWith(status: AccountFormStatus.success),
      ),
    );
  }
}
