import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/form/form_validation.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/templates/domain/usecases/save_tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/form/tx_form_fields.dart';

part 'favorite_form_state.dart';
part 'favorite_form_cubit.freezed.dart';

/// Backs the create / edit favorite form. Seeds fields from [initial] — which
/// covers BOTH editing an existing favorite (`id != null` → `isEditing`) and
/// "save as favorite" from the add/edit tx form (`id == null`, empty label to
/// prompt for one). Loads accounts + both category sets for the pickers,
/// validates on [submit] (amount optional), and folds [SaveTxTemplate] into a
/// status the page reacts to. Every emit is guarded by [isClosed] (rule 5).
class FavoriteFormCubit extends Cubit<FavoriteFormState> {
  FavoriteFormCubit({
    required SaveTxTemplate saveTemplate,
    required GetAccounts getAccounts,
    required GetCategories getCategories,
    TxTemplate? initial,
  }) : _saveTemplate = saveTemplate,
       _getAccounts = getAccounts,
       _getCategories = getCategories,
       _initial = initial,
       super(_seed(initial)) {
    _seedState = state;
  }

  final SaveTxTemplate _saveTemplate;
  final GetAccounts _getAccounts;
  final GetCategories _getCategories;
  final TxTemplate? _initial;

  /// The seed (initial editable fields), captured post-construction so [hasEdits]
  /// drives the unsaved-changes guard (D2). `load()` mutates only the picker
  /// lists (not identity fields), so a pristine form stays clean.
  late final FavoriteFormState _seedState;

  /// True once the user has changed an editable field from the seed (D2).
  bool get hasEdits => state.formIdentity != _seedState.formIdentity;

  static FavoriteFormState _seed(TxTemplate? initial) {
    if (initial == null) return const FavoriteFormState();
    return FavoriteFormState(
      label: initial.label,
      type: initial.type,
      amount: initial.amount ?? 0,
      accountId: initial.accountId,
      toAccountId: initial.toAccountId,
      categoryId: initial.categoryId,
      plannedStatus: initial.plannedStatus,
      spendingType: initial.spendingType,
      note: initial.note ?? '',
      isEditing: initial.id != null,
    );
  }

  /// Loads active accounts + both category sets for the pickers. Read failures
  /// leave the lists empty rather than blocking the form.
  Future<void> load() async {
    final (accounts, categories) = await loadTxFormLookups(
      _getAccounts,
      _getCategories,
    );
    if (isClosed) return;
    emit(state.copyWith(accounts: accounts, categories: categories));
  }

  void labelChanged(String label) => emit(state.copyWith(label: label));

  void amountChanged(int amount) => emit(state.copyWith(amount: amount));

  void typeChanged(TransactionType type) {
    if (type == state.type) return;
    // Switching type clears the type-specific fields; copyWith preserves the
    // rest (freezed nulls via its `= freezed` sentinel — the old rebuild was
    // working around a myth, and dropped any field it forgot to re-list).
    emit(
      state.copyWith(
        type: type,
        toAccountId: null,
        categoryId: null,
        plannedStatus: null,
        spendingType: null,
        status: FavoriteFormStatus.editing,
        error: null,
      ),
    );
  }

  void accountChanged(int accountId) =>
      emit(state.copyWith(accountId: accountId));

  void toAccountChanged(int toAccountId) =>
      emit(state.copyWith(toAccountId: toAccountId));

  void categoryChanged(int categoryId) =>
      emit(state.copyWith(categoryId: categoryId));

  void plannedStatusChanged(PlannedStatus status) =>
      emit(state.copyWith(plannedStatus: status));

  void spendingTypeChanged(SpendingType spendingType) =>
      emit(state.copyWith(spendingType: spendingType));

  void noteChanged(String note) => emit(state.copyWith(note: note));

  Future<void> submit() async {
    if (state.isSaving) return;
    if (!state.isValid) {
      // D1: surface the first failing field via the page's failure listener.
      emit(state.copyWith(status: FavoriteFormStatus.failure));
      return;
    }
    emit(state.copyWith(status: FavoriteFormStatus.saving));

    // Built explicitly (not via copyWith) so type-specific fields drop for the
    // types that don't own them; `amount == 0` → an amount-less favorite.
    final template = TxTemplate(
      id: _initial?.id,
      label: state.label.trim(),
      type: state.type,
      amount: state.amount == 0 ? null : state.amount,
      accountId: state.accountId!,
      toAccountId: state.isTransfer ? state.toAccountId : null,
      categoryId: state.isTransfer ? null : state.categoryId,
      plannedStatus: state.isExpense ? state.plannedStatus : null,
      spendingType: state.isExpense ? state.spendingType : null,
      note: state.note.trim().isEmpty ? null : state.note.trim(),
      sortOrder: _initial?.sortOrder ?? 0,
      createdAt: _initial?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
    );

    final result = await _saveTemplate(template);
    if (isClosed) return;
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: FavoriteFormStatus.failure, error: failure),
        (_) => state.copyWith(status: FavoriteFormStatus.success),
      ),
    );
  }
}
