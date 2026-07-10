import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/get_budgets_for_period.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
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
    Transaction? initial,
  }) : _saveTransaction = saveTransaction,
       _getAccounts = getAccounts,
       _getCategories = getCategories,
       _getBudgetsForPeriod = getBudgetsForPeriod,
       _txChanges = txChangeNotifier,
       _initial = initial,
       super(_seed(initial));

  final SaveTransaction _saveTransaction;
  final GetAccounts _getAccounts;
  final GetCategories _getCategories;
  final GetBudgetsForPeriod _getBudgetsForPeriod;
  final TxChangeNotifier _txChanges;
  final Transaction? _initial;

  static AddTransactionState _seed(Transaction? initial) {
    if (initial == null) {
      final now = DateTime.now();
      return AddTransactionState(
        date: DateTime(now.year, now.month, now.day).millisecondsSinceEpoch,
      );
    }
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
      isEditing: true,
    );
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

  Future<void> submit() async {
    if (state.isSaving) return;

    final validation = _validate();
    if (validation != AddTxValidation.none) {
      emit(state.copyWith(status: AddTxStatus.failure, validation: validation));
      return;
    }

    // Budget guard (plan §5): a new expense whose amount exceeds its category's
    // safe-daily for the current month pauses for a confirm sheet before saving.
    // Non-expense / edit / non-current-month / no-budget → straight through.
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
    );

    final result = await _saveTransaction(transaction);
    if (isClosed) return;
    final failure = result.getLeft().toNullable();
    if (failure != null) {
      emit(state.copyWith(status: AddTxStatus.failure, error: failure));
      return;
    }
    // W2 fix: a successful write pings the shared notifier so Home + Calendar +
    // the Budget guard refresh live — even for the fire-and-forget shell FAB
    // path that can't await this form.
    _txChanges.ping();
    emit(state.copyWith(status: AddTxStatus.success));
  }

  /// The category's safe-daily when this expense would breach it (so the page
  /// warns), else null: a non-expense, an edit (its amount is already in the
  /// budget's spent), a non-current-month date, no budget for the category, or
  /// `amount <= safeDaily`.
  Future<int?> _safeDailyBreach() async {
    if (!state.isExpense || state.isEditing || state.categoryId == null) {
      return null;
    }
    final now = DateTime.now();
    final currentPeriod = periodKey(now);
    if (periodKey(DateTime.fromMillisecondsSinceEpoch(state.date)) !=
        currentPeriod) {
      return null;
    }
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
      period: currentPeriod,
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
}
