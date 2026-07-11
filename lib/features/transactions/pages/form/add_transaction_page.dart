import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_cubit.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/account_picker_sheet.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/category_picker_sheet.dart';

/// Create / edit transaction form (wireframe §3). The segmented type control
/// drives which fields show; the page owns the amount + note controllers
/// (rule 7) while all other state lives in [AddTransactionCubit]. Pops with
/// `true` on a successful save so the origin (Calendar) reloads.
class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final state = context.read<AddTransactionCubit>().state;
    _amountController = TextEditingController(
      text: state.amount == 0 ? '' : '${state.amount}',
    );
    _noteController = TextEditingController(text: state.note);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocConsumer<AddTransactionCubit, AddTransactionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        if (state.status == AddTxStatus.success) {
          context.pop(true);
        } else if (state.status == AddTxStatus.needsBudgetConfirm) {
          final cubit = context.read<AddTransactionCubit>();
          final keepSaving = await BudgetWarningSheet.show(
            context,
            categoryName: state.selectedCategory?.name ?? s.category,
            safeDaily: state.safeDaily,
            amount: state.amount,
          );
          if (keepSaving) {
            cubit.confirmSave();
          } else {
            cubit.dismissBudgetConfirm();
          }
        } else if (state.status == AddTxStatus.failure) {
          final message = switch (state.validation) {
            AddTxValidation.amountRequired => s.amountRequiredError,
            AddTxValidation.accountRequired => s.accountRequiredError,
            AddTxValidation.categoryRequired => s.categoryRequiredError,
            AddTxValidation.toAccountRequired => s.toAccountRequiredError,
            AddTxValidation.transferSameAccount => s.transferSameAccountError,
            AddTxValidation.none =>
              state.error?.localize(context) ?? s.errorUnexpected,
          };
          message.toToastError(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddTransactionCubit>();
        return AppScaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: Text(state.isEditing ? s.editTransaction : s.addTransaction),
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              SegmentedControl<TransactionType>(
                selected: state.type,
                onChanged: cubit.typeChanged,
                options: [
                  SegmentOption(
                    value: TransactionType.expense,
                    label: s.expense,
                  ),
                  SegmentOption(value: TransactionType.income, label: s.income),
                  SegmentOption(
                    value: TransactionType.transfer,
                    label: s.transfer,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              _FieldLabel(s.amount),
              AmountInputField(
                controller: _amountController,
                autofocus: !state.isEditing,
                onChanged: (value) =>
                    cubit.amountChanged(int.tryParse(value) ?? 0),
              ),
              const SizedBox(height: AppSpacing.xl),
              _FieldLabel(state.isTransfer ? s.fromAccount : s.account),
              SelectorField(
                label: state.selectedAccount?.name ?? s.selectAccount,
                icon: state.selectedAccount == null
                    ? Icons.account_balance_wallet_outlined
                    : AppIcons.resolve(state.selectedAccount!.icon),
                onTap: () => _pickAccount(context),
              ),
              if (state.isTransfer) ...[
                const SizedBox(height: AppSpacing.xl),
                _FieldLabel(s.toAccount),
                SelectorField(
                  label: state.selectedToAccount?.name ?? s.selectAccount,
                  icon: state.selectedToAccount == null
                      ? Icons.account_balance_wallet_outlined
                      : AppIcons.resolve(state.selectedToAccount!.icon),
                  onTap: () => _pickToAccount(context),
                ),
              ],
              if (!state.isTransfer) ...[
                const SizedBox(height: AppSpacing.xl),
                _FieldLabel(s.category),
                SelectorField(
                  label: state.selectedCategory?.name ?? s.selectCategory,
                  icon: state.selectedCategory == null
                      ? Icons.category_outlined
                      : AppIcons.resolve(state.selectedCategory!.icon),
                  onTap: () => _pickCategory(context),
                ),
              ],
              if (state.isExpense) ...[
                const SizedBox(height: AppSpacing.xl),
                _FieldLabel(s.plannedStatus),
                ChoiceChipGroup<PlannedStatus>(
                  selected: state.plannedStatus,
                  onChanged: cubit.plannedStatusChanged,
                  options: [
                    ChipOption(value: PlannedStatus.planned, label: s.planned),
                    ChipOption(
                      value: PlannedStatus.unplanned,
                      label: s.unplanned,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                _FieldLabel(s.spendingType),
                ChoiceChipGroup<SpendingType>(
                  selected: state.spendingType,
                  onChanged: cubit.spendingTypeChanged,
                  options: [
                    ChipOption(value: SpendingType.need, label: s.need),
                    ChipOption(value: SpendingType.want, label: s.want),
                    ChipOption(
                      value: SpendingType.lifestyle,
                      label: s.lifestyle,
                    ),
                    ChipOption(
                      value: SpendingType.emergency,
                      label: s.emergency,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              _FieldLabel(s.date),
              SelectorField(
                label: _formatDate(context, state.date),
                icon: Icons.calendar_today_rounded,
                onTap: () => _pickDate(context),
              ),
              const SizedBox(height: AppSpacing.xl),
              _FieldLabel(s.note),
              TextField(
                controller: _noteController,
                onChanged: cubit.noteChanged,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(context, hint: s.noteHint),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: PrimaryButton(
                label: state.isTransfer ? s.saveTransfer : s.saveTransaction,
                isLoading: state.isSaving,
                onPressed: state.isValid ? cubit.submit : null,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAccount(BuildContext context) async {
    final cubit = context.read<AddTransactionCubit>();
    final account = await AccountPickerSheet.show(
      context,
      title: Strings.of(context)!.selectAccount,
      accounts: cubit.state.selectableAccounts,
      selectedId: cubit.state.accountId,
    );
    if (account?.id != null) cubit.accountChanged(account!.id!);
  }

  Future<void> _pickToAccount(BuildContext context) async {
    final cubit = context.read<AddTransactionCubit>();
    final account = await AccountPickerSheet.show(
      context,
      title: Strings.of(context)!.toAccount,
      accounts: cubit.state.selectableAccounts,
      selectedId: cubit.state.toAccountId,
      excludeId: cubit.state.accountId,
    );
    if (account?.id != null) cubit.toAccountChanged(account!.id!);
  }

  Future<void> _pickCategory(BuildContext context) async {
    final cubit = context.read<AddTransactionCubit>();
    final category = await CategoryPickerSheet.show(
      context,
      title: Strings.of(context)!.selectCategory,
      categories: cubit.state.categoriesForType,
      selectedId: cubit.state.categoryId,
    );
    if (category?.id != null) cubit.categoryChanged(category!.id!);
  }

  Future<void> _pickDate(BuildContext context) async {
    final cubit = context.read<AddTransactionCubit>();
    final current = DateTime.fromMillisecondsSinceEpoch(cubit.state.date);
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5, 12, 31),
    );
    if (picked != null) cubit.dateChanged(picked);
  }
}

/// "Today, 8 Jul 2026" for today, otherwise "8 Jul 2026". Indonesian month
/// names (id symbols loaded in main.dart).
String _formatDate(BuildContext context, int millis) {
  final s = Strings.of(context)!;
  final date = DateTime.fromMillisecondsSinceEpoch(millis);
  final now = DateTime.now();
  final formatted = DateFormat('d MMM yyyy', 'id').format(date);
  final isToday =
      date.year == now.year && date.month == now.month && date.day == now.day;
  return isToday ? '${s.today}, $formatted' : formatted;
}

InputDecoration _inputDecoration(BuildContext context, {required String hint}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: context.colors.border),
  );
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Theme.of(context).cardColor,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: 14,
    ),
    border: border,
    enabledBorder: border,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: context.colors.textSecondary),
    ),
  );
}
