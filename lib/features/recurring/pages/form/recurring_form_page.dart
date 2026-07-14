import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/pages/form/recurring_form_cubit.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/account_picker_sheet.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/category_picker_sheet.dart';

/// Create / edit recurring form: the favorite-form body (type / amount /
/// account / category / planned / spending / note, amount **required**) plus a
/// schedule section (freq / interval / start / optional end). Owns the label /
/// amount / note controllers (rule 7); all other state lives in the cubit. Pops
/// with `true` on a successful save so the manage list reloads.
class RecurringFormPage extends StatefulWidget {
  const RecurringFormPage({super.key});

  @override
  State<RecurringFormPage> createState() => _RecurringFormPageState();
}

class _RecurringFormPageState extends State<RecurringFormPage> {
  late final TextEditingController _labelController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final state = context.read<RecurringFormCubit>().state;
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
    return BlocConsumer<RecurringFormCubit, RecurringFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == RecurringFormStatus.success) {
          context.pop(true);
        } else if (state.status == RecurringFormStatus.failure) {
          // D1: a save failure carries `error`; an invalid submit carries only
          // `firstError` — surface whichever applies.
          (state.error?.localize(context) ??
                  state.firstError?.localize(context) ??
                  s.errorUnexpected)
              .toToastError(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<RecurringFormCubit>();
        return UnsavedChangesGuard(
          canLeave: !cubit.hasEdits || state.isSaving,
          child: AppScaffold(
            appBar: AppBar(
              leading: const CloseButton(),
              title: Text(state.isEditing ? s.recurringEdit : s.recurringAdd),
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

                // ── Schedule ──
                const SizedBox(height: AppSpacing.xl),
                _FieldLabel(s.recurring),
                ChoiceChipGroup<RecurrenceFreq>(
                  selected: state.freq,
                  onChanged: cubit.freqChanged,
                  options: [
                    ChipOption(value: RecurrenceFreq.daily, label: s.freqDaily),
                    ChipOption(
                      value: RecurrenceFreq.weekly,
                      label: s.freqWeekly,
                    ),
                    ChipOption(
                      value: RecurrenceFreq.monthly,
                      label: s.freqMonthly,
                    ),
                    ChipOption(
                      value: RecurrenceFreq.yearly,
                      label: s.freqYearly,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _IntervalStepper(
                  value: state.interval,
                  label: s.recurringEvery(state.interval),
                  onChanged: cubit.intervalChanged,
                ),
                const SizedBox(height: AppSpacing.xl),
                _FieldLabel(s.recurringStartDate),
                SelectorField(
                  label: s.recurringStartDate,
                  value: state.startDate == null
                      ? null
                      : _formatDate(state.startDate!),
                  icon: Iconsax.calendar,
                  onTap: () => _pickStartDate(context),
                ),
                const SizedBox(height: AppSpacing.xl),
                _FieldLabel(s.recurringEndDate),
                Row(
                  children: [
                    Expanded(
                      child: SelectorField(
                        label: s.recurringEndDate,
                        value: state.endDate == null
                            ? null
                            : _formatDate(state.endDate!),
                        icon: Iconsax.calendar_1,
                        onTap: () => _pickEndDate(context),
                      ),
                    ),
                    if (state.endDate != null)
                      IconButton(
                        // D7: this clears the end date — was mislabelled "Cancel".
                        tooltip: s.clear,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => cubit.endDateChanged(null),
                      ),
                  ],
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
    final cubit = context.read<RecurringFormCubit>();
    final account = await AccountPickerSheet.show(
      context,
      title: Strings.of(context)!.selectAccount,
      accounts: cubit.state.selectableAccounts,
      selectedId: cubit.state.accountId,
    );
    if (account?.id != null) cubit.accountChanged(account!.id!);
  }

  Future<void> _pickToAccount(BuildContext context) async {
    final cubit = context.read<RecurringFormCubit>();
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
    final cubit = context.read<RecurringFormCubit>();
    final category = await CategoryPickerSheet.show(
      context,
      title: Strings.of(context)!.selectCategory,
      categories: cubit.state.categoriesForType,
      selectedId: cubit.state.categoryId,
    );
    if (category?.id != null) cubit.categoryChanged(category!.id!);
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final cubit = context.read<RecurringFormCubit>();
    final start = cubit.state.startDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: start == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(start),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5, 12, 31),
    );
    if (picked != null) cubit.startDateChanged(_midnight(picked));
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final cubit = context.read<RecurringFormCubit>();
    final end = cubit.state.endDate;
    final start = cubit.state.startDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: end == null
          ? (start == null
                ? DateTime.now()
                : DateTime.fromMillisecondsSinceEpoch(start))
          : DateTime.fromMillisecondsSinceEpoch(end),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5, 12, 31),
    );
    if (picked != null) cubit.endDateChanged(_midnight(picked));
  }
}

/// −/value/+ stepper for the recurrence interval (min 1).
class _IntervalStepper extends StatelessWidget {
  const _IntervalStepper({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final int value;
  final String label;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Iconsax.minus),
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

int _midnight(DateTime d) =>
    DateTime(d.year, d.month, d.day).millisecondsSinceEpoch;

String _formatDate(int millis) => DateFormat(
  'd MMM yyyy',
  'id',
).format(DateTime.fromMillisecondsSinceEpoch(millis));

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
