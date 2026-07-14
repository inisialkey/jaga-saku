import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/pages/form/account_form_cubit.dart';
import 'package:jaga_saku/features/accounts/pages/widgets/reconcile_sheet.dart';

/// Create / edit account form. Owns the text controllers (rule 7); all other
/// state lives in [AccountFormCubit]. Pops with `true` on a successful save so
/// the list reloads.
class AccountFormPage extends StatefulWidget {
  const AccountFormPage({super.key});

  @override
  State<AccountFormPage> createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    final state = context.read<AccountFormCubit>().state;
    _nameController = TextEditingController(text: state.name);
    _amountController = TextEditingController(
      text: state.openingBalance == 0 ? '' : '${state.openingBalance}',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocConsumer<AccountFormCubit, AccountFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AccountFormStatus.success) {
          context.pop(true);
        } else if (state.status == AccountFormStatus.failure) {
          // D1: a save failure carries `error`; an invalid submit carries only
          // `firstError` — surface whichever applies.
          (state.error?.localize(context) ??
                  state.firstError?.localize(context) ??
                  s.errorUnexpected)
              .toToastError(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<AccountFormCubit>();
        return UnsavedChangesGuard(
          canLeave: !cubit.hasEdits || state.isSaving,
          child: AppScaffold(
            appBar: AppBar(
              leading: const CloseButton(),
              title: Text(state.isEditing ? s.editAccount : s.addAccount),
            ),
            body: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _FieldLabel(s.accountType),
                SegmentedControl<AccountType>(
                  selected: state.type,
                  onChanged: cubit.typeChanged,
                  options: [
                    SegmentOption(value: AccountType.cash, label: s.cash),
                    SegmentOption(value: AccountType.bank, label: s.bank),
                    SegmentOption(value: AccountType.ewallet, label: s.ewallet),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                _FieldLabel(s.accountName),
                TextField(
                  controller: _nameController,
                  onChanged: cubit.nameChanged,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(context, hint: s.accountName),
                ),
                const SizedBox(height: AppSpacing.xl),
                _FieldLabel(s.openingBalance),
                AmountInputField(
                  controller: _amountController,
                  onChanged: (value) =>
                      cubit.openingBalanceChanged(int.tryParse(value) ?? 0),
                ),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: CategoryIconAvatar(
                    icon: state.icon,
                    color: state.color,
                    size: 64,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SelectorField(
                  label: s.icon,
                  icon: AppIcons.resolve(state.icon),
                  onTap: () => _pickIcon(context),
                ),
                const SizedBox(height: AppSpacing.md),
                SelectorField(
                  label: s.color,
                  icon: Icons.palette_outlined,
                  onTap: () => _pickColor(context),
                ),
                // V2-M6: reconcile is only meaningful for an existing account
                // (a new one has no history/derived balance to correct).
                if (state.isEditing) ...[
                  const SizedBox(height: AppSpacing.xl),
                  SelectorField(
                    label: s.reconcile,
                    icon: Icons.tune,
                    onTap: () {
                      final account = cubit.initial;
                      if (account?.id == null) return;
                      ReconcileSheet.show(
                        context,
                        accountId: account!.id!,
                        currentBalance: account.balance,
                      );
                    },
                  ),
                ],
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

  Future<void> _pickIcon(BuildContext context) async {
    final cubit = context.read<AccountFormCubit>();
    final key = await IconPickerSheet.show(
      context,
      title: Strings.of(context)!.icon,
      selected: cubit.state.icon,
    );
    if (key != null) cubit.iconChanged(key);
  }

  Future<void> _pickColor(BuildContext context) async {
    final cubit = context.read<AccountFormCubit>();
    final argb = await ColorPickerSheet.show(
      context,
      title: Strings.of(context)!.color,
      selected: cubit.state.color,
    );
    if (argb != null) cubit.colorChanged(argb);
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
