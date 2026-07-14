import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/templates/pages/form/favorite_form_cubit.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/account_picker_sheet.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/category_picker_sheet.dart';

/// Create / edit favorite form: the add-tx form minus the date, plus a required
/// label and an **optional** amount. Owns the label / amount / note controllers
/// (rule 7); all other state lives in [FavoriteFormCubit]. Pops with `true` on a
/// successful save so the origin (Favorites list, or the add-tx "save as
/// favorite") knows it landed.
class FavoriteFormPage extends StatefulWidget {
  const FavoriteFormPage({super.key});

  @override
  State<FavoriteFormPage> createState() => _FavoriteFormPageState();
}

class _FavoriteFormPageState extends State<FavoriteFormPage> {
  late final TextEditingController _labelController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final state = context.read<FavoriteFormCubit>().state;
    _labelController = TextEditingController(text: state.label);
    _amountController = TextEditingController(
      text: state.amount == 0 ? '' : '${state.amount}',
    );
    _noteController = TextEditingController(text: state.note);
  }

  @override
  void dispose() {
    _labelController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocConsumer<FavoriteFormCubit, FavoriteFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FavoriteFormStatus.success) {
          context.pop(true);
        } else if (state.status == FavoriteFormStatus.failure) {
          // D1: a save failure carries `error`; an invalid submit carries only
          // `firstError` — surface whichever applies.
          (state.error?.localize(context) ??
                  state.firstError?.localize(context) ??
                  s.errorUnexpected)
              .toToastError(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<FavoriteFormCubit>();
        return UnsavedChangesGuard(
          canLeave: !cubit.hasEdits || state.isSaving,
          child: AppScaffold(
            appBar: AppBar(
              leading: const CloseButton(),
              title: Text(state.isEditing ? s.favoriteEdit : s.favoriteAdd),
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
                    SegmentOption(
                      value: TransactionType.income,
                      label: s.income,
                    ),
                    SegmentOption(
                      value: TransactionType.transfer,
                      label: s.transfer,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                _FieldLabel(s.favoriteLabel),
                TextField(
                  controller: _labelController,
                  onChanged: cubit.labelChanged,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(context, hint: s.favoriteLabel),
                ),
                const SizedBox(height: AppSpacing.xl),
                _FieldLabel(s.amount),
                AmountInputField(
                  controller: _amountController,
                  hint: s.favoriteAmountOptional,
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
                      ChipOption(
                        value: PlannedStatus.planned,
                        label: s.planned,
                      ),
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
                _FieldLabel(s.note),
                TextField(
                  controller: _noteController,
                  onChanged: cubit.noteChanged,
                  textCapitalization: TextCapitalization.sentences,
                  // D5: let a longer note wrap instead of scrolling one line.
                  minLines: 1,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                  decoration: _inputDecoration(context, hint: s.noteHint),
                ),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: PrimaryButton(
                  label: s.save,
                  isLoading: state.isSaving,
                  onPressed: cubit.submit,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAccount(BuildContext context) async {
    final cubit = context.read<FavoriteFormCubit>();
    final account = await AccountPickerSheet.show(
      context,
      title: Strings.of(context)!.selectAccount,
      accounts: cubit.state.selectableAccounts,
      selectedId: cubit.state.accountId,
    );
    if (account?.id != null) cubit.accountChanged(account!.id!);
  }

  Future<void> _pickToAccount(BuildContext context) async {
    final cubit = context.read<FavoriteFormCubit>();
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
    final cubit = context.read<FavoriteFormCubit>();
    final category = await CategoryPickerSheet.show(
      context,
      title: Strings.of(context)!.selectCategory,
      categories: cubit.state.categoriesForType,
      selectedId: cubit.state.categoryId,
    );
    if (category?.id != null) cubit.categoryChanged(category!.id!);
  }
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
