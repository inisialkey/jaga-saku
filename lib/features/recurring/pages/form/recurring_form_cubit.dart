import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/recurrence_schedule.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/save_recurring_rule.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

part 'recurring_form_state.dart';
part 'recurring_form_cubit.freezed.dart';

/// Backs the create / edit recurring form. Reuses M2's favorite-form shape
/// (type / amount / account / category / planned / spending / note) with amount
/// **required**, plus the schedule (freq / interval / start / end?). Seeds from
/// [initial] (an existing rule with its joined template). On save it builds an
/// owned [TxTemplate] (`isFavorite = false`) + a [RecurringRule] whose `nextDue`
/// is computed by [_computeNextDue] (C5: a schedule edit never backfills the
/// re-cadenced past). Every emit is guarded by [isClosed] (rule 5).
class RecurringFormCubit extends Cubit<RecurringFormState> {
  RecurringFormCubit({
    required SaveRecurringRule saveRule,
    required GetAccounts getAccounts,
    required GetCategories getCategories,
    RecurringRule? initial,
  }) : _saveRule = saveRule,
       _getAccounts = getAccounts,
       _getCategories = getCategories,
       _initial = initial,
       super(_seed(initial));

  final SaveRecurringRule _saveRule;
  final GetAccounts _getAccounts;
  final GetCategories _getCategories;
  final RecurringRule? _initial;

  static RecurringFormState _seed(RecurringRule? initial) {
    if (initial == null) return const RecurringFormState();
    final t = initial.template;
    return RecurringFormState(
      label: t?.label ?? '',
      type: t?.type ?? TransactionType.expense,
      amount: t?.amount ?? 0,
      accountId: t?.accountId,
      toAccountId: t?.toAccountId,
      categoryId: t?.categoryId,
      plannedStatus: t?.plannedStatus,
      spendingType: t?.spendingType,
      note: t?.note ?? '',
      freq: initial.freq,
      interval: initial.interval,
      startDate: initial.startDate,
      endDate: initial.endDate,
      isEditing: initial.id != null,
    );
  }

  /// Loads active accounts + both category sets for the pickers. Read failures
  /// leave the lists empty rather than blocking the form.
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

  void labelChanged(String label) => emit(state.copyWith(label: label));

  void amountChanged(int amount) => emit(state.copyWith(amount: amount));

  void typeChanged(TransactionType type) {
    if (type == state.type) return;
    // Rebuild (not copyWith) so category / toAccount / planned / spending clear
    // to null; the schedule fields carry over unchanged.
    emit(
      RecurringFormState(
        label: state.label,
        type: type,
        amount: state.amount,
        accountId: state.accountId,
        note: state.note,
        accounts: state.accounts,
        categories: state.categories,
        isEditing: state.isEditing,
        freq: state.freq,
        interval: state.interval,
        startDate: state.startDate,
        endDate: state.endDate,
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

  void freqChanged(RecurrenceFreq freq) => emit(state.copyWith(freq: freq));

  /// Clamps to a minimum of 1 (every N units, N ≥ 1).
  void intervalChanged(int interval) =>
      emit(state.copyWith(interval: interval < 1 ? 1 : interval));

  void startDateChanged(int startDate) =>
      emit(state.copyWith(startDate: startDate));

  /// Sets or clears (`null`) the optional end date. Rebuilds so `null` genuinely
  /// clears (freezed copyWith cannot set a field to null).
  void endDateChanged(int? endDate) => emit(
    RecurringFormState(
      label: state.label,
      type: state.type,
      amount: state.amount,
      accountId: state.accountId,
      toAccountId: state.toAccountId,
      categoryId: state.categoryId,
      plannedStatus: state.plannedStatus,
      spendingType: state.spendingType,
      note: state.note,
      accounts: state.accounts,
      categories: state.categories,
      status: state.status,
      error: state.error,
      isEditing: state.isEditing,
      freq: state.freq,
      interval: state.interval,
      startDate: state.startDate,
      endDate: endDate,
    ),
  );

  Future<void> submit() async {
    if (!state.isValid || state.isSaving) return;
    emit(state.copyWith(status: RecurringFormStatus.saving));

    final now = DateTime.now().millisecondsSinceEpoch;
    final initial = _initial;

    // Built explicitly so type-specific fields drop for the types that don't own
    // them; `isFavorite: false` keeps the owned template out of the Home strip.
    final template = TxTemplate(
      id: initial?.templateId,
      label: state.label.trim(),
      type: state.type,
      amount:
          state.amount, // form-required > 0, so templateToTransaction is safe
      accountId: state.accountId!,
      toAccountId: state.isTransfer ? state.toAccountId : null,
      categoryId: state.isTransfer ? null : state.categoryId,
      plannedStatus: state.isExpense ? state.plannedStatus : null,
      spendingType: state.isExpense ? state.spendingType : null,
      note: state.note.trim().isEmpty ? null : state.note.trim(),
      isFavorite: false,
      sortOrder: initial?.template?.sortOrder ?? 0,
      createdAt: initial?.template?.createdAt ?? now,
    );

    final rule = RecurringRule(
      id: initial?.id,
      templateId: initial?.templateId ?? 0,
      freq: state.freq,
      interval: state.interval,
      startDate: state.startDate!,
      endDate: state.endDate,
      nextDue: _computeNextDue(),
      createdAt: initial?.createdAt ?? now,
    );

    final result = await _saveRule(
      SaveRecurringRuleParams(template: template, rule: rule),
    );
    if (isClosed) return;
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: RecurringFormStatus.failure, error: failure),
        (_) => state.copyWith(status: RecurringFormStatus.success),
      ),
    );
  }

  /// C5 — the idempotency cursor on save:
  /// - insert: `next_due = startDate` (the intended backfill from the start).
  /// - shape-only edit (schedule unchanged): preserve the existing cursor.
  /// - schedule edit (freq / interval / start changed): reset to the first
  ///   occurrence `>= max(startDate, today)`, so a re-cadenced rule never
  ///   backfills its entire past on the next open.
  int _computeNextDue() {
    final start = state.startDate!;
    final initial = _initial;
    if (initial == null) return start;
    final scheduleChanged =
        initial.freq != state.freq ||
        initial.interval != state.interval ||
        initial.startDate != start;
    if (!scheduleChanged) return initial.nextDue;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    return RecurrenceSchedule.firstDueOnOrAfter(
      startDate: start,
      floor: start > today ? start : today,
      freq: state.freq,
      interval: state.interval,
    );
  }
}
