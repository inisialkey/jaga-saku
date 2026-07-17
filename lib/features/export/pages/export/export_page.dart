import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/export/domain/entities/export_date_preset.dart';
import 'package:jaga_saku/features/export/domain/entities/export_options.dart';
import 'package:jaga_saku/features/export/pages/export/cubit/export_cubit.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/account_picker_sheet.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/category_picker_sheet.dart';

/// Export Data screen (`/export`): pick a date range + filters, then export the
/// filtered ledger to a CSV and hand it to the system share sheet. The cubit is
/// provided at the route; feedback is via oktoast (repo convention). One-shot
/// success / empty / failure states are toasts (the form stays put); the
/// builder renders the last [ExportConfiguring].
class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocConsumer<ExportCubit, ExportState>(
      listenWhen: (_, c) =>
          c is ExportSuccess || c is ExportEmptyResult || c is ExportFailure,
      listener: (context, state) {
        switch (state) {
          case ExportSuccess(:final rowCount):
            s.exportSuccess(rowCount).toToastSuccess(context);
          case ExportEmptyResult():
            s.exportEmpty.toToastLoading(context);
          case ExportFailure(:final failure):
            failure.localize(context).toToastError(context);
          default:
            break;
        }
      },
      buildWhen: (_, c) =>
          c is ExportLoading ||
          c is ExportConfiguring ||
          c is ExportLoadFailure,
      builder: (context, state) => AppScaffold(
        appBar: AppBar(title: Text(s.exportTitle)),
        body: switch (state) {
          ExportLoading() => const ListSkeleton(),
          ExportLoadFailure(:final failure) => ErrorStateView(
            title: s.errorLoadTitle,
            message: failure.localize(context),
            retryLabel: s.retry,
            onRetry: () => context.read<ExportCubit>().load(),
          ),
          ExportConfiguring() => _ExportForm(state: state),
          // One-shot states never reach the builder (buildWhen filters them).
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}

/// The export options form for a given [ExportConfiguring] state. Stateless —
/// every control writes back through `cubit.updateOptions(options.copyWith(…))`
/// (clearing a filter to "All" passes `null`, which freezed's copyWith applies).
class _ExportForm extends StatelessWidget {
  const _ExportForm({required this.state});

  final ExportConfiguring state;

  ExportOptions get _options => state.options;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: [
        // ── Date range ──────────────────────────────────────────────────────
        SectionHeader(title: s.exportDateRange),
        ChoiceChipGroup<ExportDatePreset>(
          selected: _options.preset,
          onChanged: (preset) =>
              _update(context, _options.copyWith(preset: preset)),
          options: [
            ChipOption(value: ExportDatePreset.thisMonth, label: s.thisMonth),
            ChipOption(
              value: ExportDatePreset.lastMonth,
              label: s.exportPresetLastMonth,
            ),
            ChipOption(
              value: ExportDatePreset.custom,
              label: s.exportPresetCustom,
            ),
            ChipOption(value: ExportDatePreset.all, label: s.exportAll),
          ],
        ),
        if (_options.preset == ExportDatePreset.custom) ...[
          const SizedBox(height: AppSpacing.md),
          SelectorField(
            label:
                _formatDate(context, _options.customStart) ?? s.exportStartDate,
            icon: Icons.calendar_today_rounded,
            onTap: () => _pickDate(context, isStart: true),
          ),
          const SizedBox(height: AppSpacing.sm),
          SelectorField(
            label: _formatDate(context, _options.customEnd) ?? s.exportEndDate,
            icon: Icons.calendar_today_rounded,
            onTap: () => _pickDate(context, isStart: false),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),

        // ── Account ─────────────────────────────────────────────────────────
        SectionHeader(title: s.account),
        _FilterSelector(
          label:
              _nameById(state.accounts, _options.accountId) ??
              s.exportAllAccounts,
          icon: Icons.account_balance_wallet_outlined,
          isFiltered: _options.accountId != null,
          onTap: () => _pickAccount(context),
          onClear: () => _update(context, _options.copyWith(accountId: null)),
        ),
        const SizedBox(height: AppSpacing.xl),

        // ── Category ────────────────────────────────────────────────────────
        SectionHeader(title: s.category),
        _FilterSelector(
          label:
              _categoryName(state.categories, _options.categoryId) ??
              s.exportAllCategories,
          icon: Icons.category_outlined,
          isFiltered: _options.categoryId != null,
          onTap: () => _pickCategory(context),
          onClear: () => _update(context, _options.copyWith(categoryId: null)),
        ),
        const SizedBox(height: AppSpacing.xl),

        // ── Type ────────────────────────────────────────────────────────────
        SectionHeader(title: s.exportType),
        ChoiceChipGroup<TransactionType?>(
          selected: _options.type,
          onChanged: (type) => _update(context, _options.copyWith(type: type)),
          options: [
            ChipOption(value: null, label: s.exportAll),
            ChipOption(value: TransactionType.expense, label: s.expense),
            ChipOption(value: TransactionType.income, label: s.income),
            ChipOption(value: TransactionType.transfer, label: s.transfer),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // ── Planned status ──────────────────────────────────────────────────
        SectionHeader(title: s.plannedStatus),
        ChoiceChipGroup<PlannedStatus?>(
          selected: _options.plannedStatus,
          onChanged: (value) =>
              _update(context, _options.copyWith(plannedStatus: value)),
          options: [
            ChipOption(value: null, label: s.exportAll),
            ChipOption(value: PlannedStatus.planned, label: s.planned),
            ChipOption(value: PlannedStatus.unplanned, label: s.unplanned),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // ── Spending type ───────────────────────────────────────────────────
        SectionHeader(title: s.spendingType),
        ChoiceChipGroup<SpendingType?>(
          selected: _options.spendingType,
          onChanged: (value) =>
              _update(context, _options.copyWith(spendingType: value)),
          options: [
            ChipOption(value: null, label: s.exportAll),
            ChipOption(value: SpendingType.need, label: s.need),
            ChipOption(value: SpendingType.want, label: s.want),
            ChipOption(value: SpendingType.lifestyle, label: s.lifestyle),
            ChipOption(value: SpendingType.emergency, label: s.emergency),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // ── Format (CSV enabled; PDF a disabled "Later" placeholder) ─────────
        SectionHeader(title: s.exportFormat),
        Row(
          children: [
            _FormatPill(label: s.exportFormatCsv, selected: true),
            const SizedBox(width: AppSpacing.sm),
            _FormatPill(label: s.exportFormatPdfLater, selected: false),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),

        PrimaryButton(
          label: s.exportCsv,
          isLoading: state.isExporting,
          onPressed: () => context.read<ExportCubit>().export(),
        ),
      ],
    );
  }

  void _update(BuildContext context, ExportOptions options) =>
      context.read<ExportCubit>().updateOptions(options);

  Future<void> _pickAccount(BuildContext context) async {
    final s = Strings.of(context)!;
    final cubit = context.read<ExportCubit>();
    final account = await AccountPickerSheet.show(
      context,
      title: s.account,
      accounts: state.accounts,
      selectedId: _options.accountId,
    );
    if (account?.id == null) return;
    cubit.updateOptions(_options.copyWith(accountId: account!.id));
  }

  Future<void> _pickCategory(BuildContext context) async {
    final s = Strings.of(context)!;
    final cubit = context.read<ExportCubit>();
    final category = await CategoryPickerSheet.show(
      context,
      title: s.category,
      categories: state.categories,
      selectedId: _options.categoryId,
    );
    if (category?.id == null) return;
    cubit.updateOptions(_options.copyWith(categoryId: category!.id));
  }

  Future<void> _pickDate(BuildContext context, {required bool isStart}) async {
    final cubit = context.read<ExportCubit>();
    final current = isStart ? _options.customStart : _options.customEnd;
    final initial = current != null
        ? DateTime.fromMillisecondsSinceEpoch(current)
        : DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5, 12, 31),
    );
    if (picked == null) return;
    // Store midnight-local millis (the toParams window bounds expect it).
    final millis = DateTime(
      picked.year,
      picked.month,
      picked.day,
    ).millisecondsSinceEpoch;
    cubit.updateOptions(
      isStart
          ? _options.copyWith(customStart: millis)
          : _options.copyWith(customEnd: millis),
    );
  }

  String? _nameById(List<Account> accounts, int? id) {
    if (id == null) return null;
    for (final a in accounts) {
      if (a.id == id) return a.name;
    }
    return null;
  }

  String? _categoryName(List<Category> categories, int? id) {
    if (id == null) return null;
    for (final c in categories) {
      if (c.id == id) return c.name;
    }
    return null;
  }

  String? _formatDate(BuildContext context, int? millis) {
    if (millis == null) return null;
    final d = DateTime.fromMillisecondsSinceEpoch(millis);
    return MaterialLocalizations.of(context).formatMediumDate(d);
  }
}

/// A [SelectorField] plus an optional inline "Clear" button (shown only when a
/// filter is active) that resets the filter to "All".
class _FilterSelector extends StatelessWidget {
  const _FilterSelector({
    required this.label,
    required this.icon,
    required this.isFiltered,
    required this.onTap,
    required this.onClear,
  });

  final String label;
  final IconData icon;
  final bool isFiltered;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return Row(
      children: [
        Expanded(
          child: SelectorField(label: label, icon: icon, onTap: onTap),
        ),
        if (isFiltered) TextButton(onPressed: onClear, child: Text(s.clear)),
      ],
    );
  }
}

/// A static format pill. The selected (CSV) pill is highlighted; the unselected
/// (PDF — Later) pill is muted and inert — no `onTap`, no state (YAGNI until PDF
/// ships).
class _FormatPill extends StatelessWidget {
  const _FormatPill({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : context.colors.surfaceSoft,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: selected
                ? AppColors.primaryDark
                : context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
