import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
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
      );

  final SaveAccount _saveAccount;
  final Account? _initial;

  /// The account being edited (its id + derived balance), or null for a new
  /// account. Read by the page to launch the reconcile sheet — only reached when
  /// `state.isEditing`, so it is non-null there (V2-M6).
  Account? get initial => _initial;

  void typeChanged(AccountType type) => emit(state.copyWith(type: type));

  void nameChanged(String name) => emit(state.copyWith(name: name));

  void openingBalanceChanged(int value) =>
      emit(state.copyWith(openingBalance: value));

  void iconChanged(String? icon) => emit(state.copyWith(icon: icon));

  void colorChanged(int? color) => emit(state.copyWith(color: color));

  Future<void> submit() async {
    if (!state.isValid || state.isSaving) return;
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
