import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_cubit.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/account_picker_sheet.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/category_picker_sheet.dart';

/// Navigation payload for the `/add` route (`extra`). Either [edit] an existing
/// transaction (`isEditing: true`) or [prefill] a **new** transaction from a
/// favorite's shape (amount-less apply path). Replaces the bare
/// `extra as Transaction?` so a favorite never trips the edit branch.
class AddTransactionArgs {
  const AddTransactionArgs({this.edit, this.prefill});

  final Transaction? edit;
  final TxTemplate? prefill;
}

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
            actions: [
              IconButton(
                icon: const Icon(Iconsax.archive_add),
                tooltip: s.favoriteSaveAs,
                onPressed: () => _saveAsFavorite(context),
              ),
            ],
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
              const SizedBox(height: AppSpacing.xl),
              _FieldLabel(s.receiptAttach),
              _ReceiptAttachment(
                receiptPath: state.receiptPath,
                resolve: cubit.resolveReceipt,
                onPick: () => _pickReceiptSource(context),
                onRemove: cubit.removeReceipt,
                onView: (file) => _viewReceipt(context, file),
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

  /// Opens the Kamera / Galeri source sheet, then delegates the pick to the
  /// cubit (rule 5 — the widget never touches the picker/service). A genuine
  /// pick error toasts [Strings.receiptPickFailed]; cancel is silent.
  Future<void> _pickReceiptSource(BuildContext context) async {
    final s = Strings.of(context)!;
    final cubit = context.read<AddTransactionCubit>();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => AppBottomSheet(
        title: s.receiptAttach,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuTile(
              icon: Iconsax.camera,
              title: s.receiptCamera,
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            MenuTile(
              icon: Iconsax.gallery,
              title: s.receiptGallery,
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final ok = await cubit.pickReceipt(source);
    if (!context.mounted) return;
    if (!ok) s.receiptPickFailed.toToastError(context);
  }

  /// Full-screen pinch-zoom view of the receipt (no new dep / route, doc §9).
  void _viewReceipt(BuildContext context, File file) => showDialog<void>(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.md),
      child: InteractiveViewer(child: Image.file(file)),
    ),
  );

  /// Captures the current form shape as a favorite seed and opens the favorite
  /// form (empty label) to name + save it. A favorite needs a source account, so
  /// this blocks until one is chosen; a blank amount seeds an amount-less
  /// favorite (the prefill path). Synchronous — no `await` before the push.
  void _saveAsFavorite(BuildContext context) {
    final s = Strings.of(context)!;
    final state = context.read<AddTransactionCubit>().state;
    if (state.accountId == null) {
      s.accountRequiredError.toToastError(context);
      return;
    }
    final seed = TxTemplate(
      label: '',
      type: state.type,
      amount: state.amount == 0 ? null : state.amount,
      accountId: state.accountId!,
      toAccountId: state.isTransfer ? state.toAccountId : null,
      categoryId: state.isTransfer ? null : state.categoryId,
      plannedStatus: state.isExpense ? state.plannedStatus : null,
      spendingType: state.isExpense ? state.spendingType : null,
      note: state.note.trim().isEmpty ? null : state.note.trim(),
    );
    context.push(AppRoute.favoriteForm, extra: seed);
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

/// Receipt attach row (V2-M4). Empty → a "Tambah struk" selector that opens the
/// source sheet. Set → a thumbnail (tap to view full-screen) with a ✕ to remove.
/// A stored-but-missing file (iOS restore) renders a graceful placeholder, never
/// a crash (doc §13). The path is resolved via the cubit — the widget never
/// touches the service (rule 5).
class _ReceiptAttachment extends StatelessWidget {
  const _ReceiptAttachment({
    required this.receiptPath,
    required this.resolve,
    required this.onPick,
    required this.onRemove,
    required this.onView,
  });

  final String receiptPath;
  final Future<File?> Function() resolve;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final void Function(File file) onView;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    if (receiptPath.isEmpty) {
      return SelectorField(
        label: s.receiptAttach,
        icon: Icons.attach_file,
        onTap: onPick,
      );
    }
    return FutureBuilder<File?>(
      future: resolve(),
      builder: (context, snapshot) {
        final file = snapshot.data;
        final theme = Theme.of(context);
        return Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: file != null
                      ? GestureDetector(
                          onTap: () => onView(file),
                          child: Image.file(file, fit: BoxFit.cover),
                        )
                      : ColoredBox(
                          color: context.colors.surfaceSoft,
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: context.colors.textTertiary,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  s.receiptView,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: s.receiptRemove,
                onPressed: onRemove,
              ),
            ],
          ),
        );
      },
    );
  }
}
