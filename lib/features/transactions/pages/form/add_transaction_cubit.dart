import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/core/utils/services/receipt_storage_service.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_cycle.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/get_budgets_for_period.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/save_transaction.dart';

part 'add_transaction_state.dart';
part 'add_transaction_cubit.freezed.dart';

/// Backs the create/edit transaction form. Loads accounts + categories for the
/// pickers, seeds fields from [initial] when editing, validates on [submit], and
/// folds [SaveTransaction] into a status the page reacts to. Every emit is
/// guarded by [isClosed] (rule 5).
class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit({
    required SaveTransaction saveTransaction,
    required GetAccounts getAccounts,
    required GetCategories getCategories,
    required GetBudgetsForPeriod getBudgetsForPeriod,
    required TxChangeNotifier txChangeNotifier,
    required ReceiptStorageService receiptStorage,
    required AppSettingsCubit appSettings,
    Transaction? initial,
    TxTemplate? prefill,
  }) : _saveTransaction = saveTransaction,
       _getAccounts = getAccounts,
       _getCategories = getCategories,
       _getBudgetsForPeriod = getBudgetsForPeriod,
       _txChanges = txChangeNotifier,
       _receiptStorage = receiptStorage,
       _appSettings = appSettings,
       _initial = initial,
       super(_seed(initial, prefill));

  final SaveTransaction _saveTransaction;
  final GetAccounts _getAccounts;
  final GetCategories _getCategories;
  final GetBudgetsForPeriod _getBudgetsForPeriod;
  final TxChangeNotifier _txChanges;
  final ReceiptStorageService _receiptStorage;
  final AppSettingsCubit _appSettings;
  final Transaction? _initial;

  /// True once a save has persisted the current [state.receiptPath]. Gates
  /// [close]'s orphan sweep: an uncommitted picked file is deleted on dismiss,
  /// a committed one is kept.
  bool _committed = false;

  /// The receipt path already persisted for the edited transaction (empty for a
  /// new tx). A picked file that differs from this is a *session* file — safe to
  /// delete on replace/remove/dismiss; the committed original is deleted only
  /// after a successful save.
  String get _originalPath => _initial?.receiptPath ?? '';

  /// Seeds the form. [initial] → the existing editing behavior
  /// (`isEditing: true`); [prefill] (a favorite applied via the amount-less
  /// path) → a **new** transaction pre-filled from the shape but with today's
  /// date, no id and `isEditing: false` — `prefill` is NOT stored in `_initial`,
  /// so `_commit` inserts it fresh (id null, `createdAt` now). A bare seed is the
  /// blank new-tx form. [initial] wins if both are somehow supplied.
  static AddTransactionState _seed(Transaction? initial, TxTemplate? prefill) {
    if (initial != null) {
      return AddTransactionState(
        type: initial.type,
        amount: initial.amount,
        accountId: initial.accountId,
        toAccountId: initial.toAccountId,
        categoryId: initial.categoryId,
        plannedStatus: initial.plannedStatus,
        spendingType: initial.spendingType,
        date: initial.date,
        note: initial.note ?? '',
        receiptPath: initial.receiptPath ?? '',
        isEditing: true,
      );
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    if (prefill != null) {
      return AddTransactionState(
        type: prefill.type,
        amount: prefill.amount ?? 0,
        accountId: prefill.accountId,
        toAccountId: prefill.toAccountId,
        categoryId: prefill.categoryId,
        plannedStatus: prefill.plannedStatus,
        spendingType: prefill.spendingType,
        note: prefill.note ?? '',
        date: today,
      );
    }
    return AddTransactionState(date: today);
  }

  /// Loads active accounts + both category sets for the pickers. Read failures
  /// leave the lists empty (the pickers show an empty state) rather than
  /// blocking the form — a save still surfaces its own failure.
  Future<void> load() async {
    final accountsResult = await _getAccounts(NoParams());
    final expenseResult = await _getCategories(CategoryType.expense);
    final incomeResult = await _getCategories(CategoryType.income);
    if (isClosed) return;
    final accounts =
        accountsResult.getRight().toNullable() ?? const <Account>[];
    final expense = expenseResult.getRight().toNullable() ?? const <Category>[];
    final income = incomeResult.getRight().toNullable() ?? const <Category>[];
    emit(
      state.copyWith(accounts: accounts, categories: [...expense, ...income]),
    );
  }

  void typeChanged(TransactionType type) {
    if (type == state.type) return;
    // Switching type resets the type-specific fields. Rebuild the state (not
    // copyWith) so category / toAccount / planned / spending genuinely clear to
    // null — freezed's copyWith cannot set a field back to null.
    emit(
      AddTransactionState(
        type: type,
        amount: state.amount,
        accountId: state.accountId,
        date: state.date,
        note: state.note,
        accounts: state.accounts,
        categories: state.categories,
        isEditing: state.isEditing,
        // C3: this rebuild drops any field not re-listed. Carry the picked
        // receipt so switching type never silently discards it.
        receiptPath: state.receiptPath,
      ),
    );
  }

  void amountChanged(int amount) => emit(state.copyWith(amount: amount));

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

  /// Normalizes [date] to midnight-local so day-grouping stays deterministic.
  void dateChanged(DateTime date) => emit(
    state.copyWith(
      date: DateTime(date.year, date.month, date.day).millisecondsSinceEpoch,
    ),
  );

  /// Picks a receipt from [source] and stores it. Returns false only on a
  /// genuine pick/copy error (the page toasts `receiptPickFailed`); a user-cancel
  /// returns true silently. When replacing, a prior *session-new* file (not the
  /// committed original) is deleted immediately.
  Future<bool> pickReceipt(ImageSource source) async {
    try {
      final path = await _receiptStorage.pickAndStore(source);
      // A cancelled pick (null) or a closed cubit is not an error.
      if (isClosed || path == null) return true;
      final previous = state.receiptPath;
      emit(state.copyWith(receiptPath: path));
      if (previous.isNotEmpty && previous != _originalPath) {
        await _receiptStorage.delete(previous); // session orphan
      }
      return true;
    } catch (e, s) {
      log.e('receipt pick failed', error: e, stackTrace: s);
      return false;
    }
  }

  /// Clears the receipt (the ✕ action). A session-new file is deleted now; the
  /// committed original is deleted only after a successful save (see [_commit]).
  Future<void> removeReceipt() async {
    final previous = state.receiptPath;
    emit(state.copyWith(receiptPath: '')); // '' sentinel — copyWith-safe
    if (previous.isNotEmpty && previous != _originalPath) {
      await _receiptStorage.delete(previous);
    }
  }

  /// Absolute [File] for the current receipt (rule 5 — the widget never calls the
  /// service). Null when empty or missing → the form shows a placeholder.
  Future<File?> resolveReceipt() => state.receiptPath.isEmpty
      ? Future.value()
      : _receiptStorage.resolve(state.receiptPath);

  Future<void> submit() async {
    if (state.isSaving) return;

    final validation = _validate();
    if (validation != AddTxValidation.none) {
      emit(state.copyWith(status: AddTxStatus.failure, validation: validation));
      return;
    }

    // Budget guard (plan §5): a new expense whose amount exceeds its category's
    // safe-daily for the current cycle pauses for a confirm sheet before saving.
    // Non-expense / edit / outside-current-cycle / no-budget → straight through.
    final safeDaily = await _safeDailyBreach();
    if (isClosed) return;
    if (safeDaily != null) {
      emit(
        state.copyWith(
          status: AddTxStatus.needsBudgetConfirm,
          safeDaily: safeDaily,
          validation: AddTxValidation.none,
        ),
      );
      return;
    }

    await _commit();
  }

  /// Commits after the user chose "Tetap Simpan" on the warning sheet. Shares
  /// the save path with the straight-through [submit].
  Future<void> confirmSave() => _commit();

  /// Clears the budget-confirm pause (the user chose "Ubah Nominal") back to
  /// editing, so a subsequent over-limit save re-triggers the warning.
  void dismissBudgetConfirm() {
    if (state.status == AddTxStatus.needsBudgetConfirm) {
      emit(state.copyWith(status: AddTxStatus.editing));
    }
  }

  Future<void> _commit() async {
    emit(
      state.copyWith(
        status: AddTxStatus.saving,
        validation: AddTxValidation.none,
      ),
    );

    // Built explicitly (not via copyWith) so type-specific fields are dropped
    // for the types that don't own them (transfer has no category, income has
    // no planned/spending, etc.).
    final transaction = Transaction(
      id: _initial?.id,
      type: state.type,
      amount: state.amount,
      accountId: state.accountId!,
      toAccountId: state.isTransfer ? state.toAccountId : null,
      categoryId: state.isTransfer ? null : state.categoryId,
      plannedStatus: state.isExpense ? state.plannedStatus : null,
      spendingType: state.isExpense ? state.spendingType : null,
      date: state.date,
      note: state.note.trim().isEmpty ? null : state.note.trim(),
      createdAt: _initial?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
      receiptPath: state.receiptPath.isEmpty ? null : state.receiptPath,
    );

    final result = await _saveTransaction(transaction);
    // W1: a Right result means the row — and the receiptPath it now points at —
    // is persisted. Mark committed BEFORE the isClosed short-circuit so close()'s
    // orphan sweep can never delete the just-saved receipt when the form is
    // dismissed mid-save (the save-race data-loss path).
    if (result.isRight()) _committed = true;
    if (isClosed) return;
    final failure = result.getLeft().toNullable();
    if (failure != null) {
      emit(state.copyWith(status: AddTxStatus.failure, error: failure));
      return;
    }
    // After a successful save: if editing changed/removed the receipt, the old
    // file is now orphaned (the persisted row no longer references it). Covers
    // both replace and remove on an edit; a no-op for a new tx (_originalPath '').
    final saved = state.receiptPath.isEmpty ? null : state.receiptPath;
    if (_originalPath.isNotEmpty && _originalPath != saved) {
      await _receiptStorage.delete(_originalPath);
    }
    // W2 fix: a successful write pings the shared notifier so Home + Calendar +
    // the Budget guard refresh live — even for the fire-and-forget shell FAB
    // path that can't await this form.
    _txChanges.ping();
    emit(state.copyWith(status: AddTxStatus.success));
  }

  /// The category's safe-daily when this expense would breach it (so the page
  /// warns), else null: a non-expense, an edit (its amount is already in the
  /// budget's spent), a date outside the current cycle, no budget for the
  /// category, or `amount <= safeDaily`.
  Future<int?> _safeDailyBreach() async {
    if (!state.isExpense || state.isEditing || state.categoryId == null) {
      return null;
    }
    final now = DateTime.now();
    // The guard is for the budget cycle CONTAINING now (V2-M1). At start-day 1
    // this is exactly the calendar month; its lookup label is the cycle-start
    // month (matching how the budget row was stamped).
    final cycle = BudgetCycle.range(
      startDay: _appSettings.state.budgetCycleStartDay,
      reference: now,
    );
    // Only warn when the tx date falls inside the current cycle window
    // (half-open `[start, end)`).
    if (state.date < cycle.start || state.date >= cycle.end) return null;
    final currentPeriod = periodKey(
      DateTime.fromMillisecondsSinceEpoch(cycle.start),
    );
    final result = await _getBudgetsForPeriod(currentPeriod);
    final budgets = result.getRight().toNullable() ?? const <Budget>[];
    Budget? budget;
    for (final b in budgets) {
      if (b.categoryId == state.categoryId) {
        budget = b;
        break;
      }
    }
    if (budget == null) return null;
    final status = BudgetStatus.compute(
      limitAmount: budget.limitAmount,
      spent: budget.spent,
      now: now,
      periodStart: budget.periodStart,
      periodEnd: budget.periodEnd,
    );
    return state.amount > status.safeDaily ? status.safeDaily : null;
  }

  /// First failing rule for the current type, or [AddTxValidation.none].
  AddTxValidation _validate() {
    if (state.amount <= 0) return AddTxValidation.amountRequired;
    if (state.accountId == null) return AddTxValidation.accountRequired;
    if (state.isTransfer) {
      if (state.toAccountId == null) return AddTxValidation.toAccountRequired;
      if (state.toAccountId == state.accountId) {
        return AddTxValidation.transferSameAccount;
      }
    } else if (state.categoryId == null) {
      return AddTxValidation.categoryRequired;
    }
    return AddTxValidation.none;
  }

  @override
  Future<void> close() {
    // A picked-but-unsaved receipt (not the committed original) is an orphan when
    // the form is dismissed. Fire-and-forget — delete is no-throw.
    if (!_committed &&
        state.receiptPath.isNotEmpty &&
        state.receiptPath != _originalPath) {
      unawaited(_receiptStorage.delete(state.receiptPath));
    }
    return super.close();
  }
}
