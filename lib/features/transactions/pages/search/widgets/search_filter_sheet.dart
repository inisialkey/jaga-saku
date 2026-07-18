import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction_source.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/account_picker_sheet.dart';
import 'package:jaga_saku/features/transactions/pages/widgets/category_picker_sheet.dart';

/// The Search filter bottom-sheet: edits a draft [SearchTransactionParams] over
/// every facet (date range, account, category, type, source, amount range,
/// planned status, spending type, receipt, sort) and pops the new params. Apply
/// pops the draft; "Clear filters" pops a filters-cleared params that keeps the
/// current keyword; a dismiss pops null. Apply is gated on a valid amount range.
class SearchFilterSheet extends StatefulWidget {
  const SearchFilterSheet({
    required this.current,
    required this.accounts,
    required this.categories,
    super.key,
  });

  final SearchTransactionParams current;
  final List<Account> accounts;
  final List<Category> categories;

  /// Opens the sheet, resolving to the new params (Apply / Clear) or `null`
  /// (dismissed).
  static Future<SearchTransactionParams?> show(
    BuildContext context, {
    required SearchTransactionParams current,
    required List<Account> accounts,
    required List<Category> categories,
  }) => showModalBottomSheet<SearchTransactionParams>(
    context: context,
    isScrollControlled: true,
    builder: (_) => SearchFilterSheet(
      current: current,
      accounts: accounts,
      categories: categories,
    ),
  );

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late SearchTransactionParams _draft;
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    _draft = widget.current;
    _minController = TextEditingController(
      text: _draft.minAmount?.toString() ?? '',
    );
    _maxController = TextEditingController(
      text: _draft.maxAmount?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return AppBottomSheet(
      title: s.searchFilters,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Date range ──────────────────────────────────────────────────
            SectionHeader(title: s.searchDateRange),
            _ClearableSelector(
              label: _dateRangeLabel(context) ?? s.searchAny,
              icon: Icons.date_range_outlined,
              isFiltered: _draft.startDate != null || _draft.endDate != null,
              onTap: () => _pickDateRange(context),
              onClear: () => setState(
                () => _draft = _draft.copyWith(startDate: null, endDate: null),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Account ─────────────────────────────────────────────────────
            SectionHeader(title: s.searchAccount),
            _ClearableSelector(
              label: _accountName(_draft.accountId) ?? s.searchAny,
              icon: Icons.account_balance_wallet_outlined,
              isFiltered: _draft.accountId != null,
              onTap: () => _pickAccount(context, s),
              onClear: () =>
                  setState(() => _draft = _draft.copyWith(accountId: null)),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Category ────────────────────────────────────────────────────
            SectionHeader(title: s.searchCategory),
            _ClearableSelector(
              label: _categoryName(_draft.categoryId) ?? s.searchAny,
              icon: Icons.category_outlined,
              isFiltered: _draft.categoryId != null,
              onTap: () => _pickCategory(context, s),
              onClear: () =>
                  setState(() => _draft = _draft.copyWith(categoryId: null)),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Type ────────────────────────────────────────────────────────
            SectionHeader(title: s.searchType),
            ChoiceChipGroup<TransactionType?>(
              selected: _draft.type,
              onChanged: (v) =>
                  setState(() => _draft = _draft.copyWith(type: v)),
              options: [
                ChipOption(value: null, label: s.searchAny),
                ChipOption(value: TransactionType.expense, label: s.expense),
                ChipOption(value: TransactionType.income, label: s.income),
                ChipOption(value: TransactionType.transfer, label: s.transfer),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Source ──────────────────────────────────────────────────────
            SectionHeader(title: s.searchSource),
            ChoiceChipGroup<TransactionSource?>(
              selected: _draft.source,
              onChanged: (v) =>
                  setState(() => _draft = _draft.copyWith(source: v)),
              options: [
                ChipOption(value: null, label: s.searchAny),
                ChipOption(
                  value: TransactionSource.manual,
                  label: s.searchSourceManual,
                ),
                ChipOption(
                  value: TransactionSource.reconciliation,
                  label: s.searchSourceReconciliation,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Amount range ────────────────────────────────────────────────
            SectionHeader(title: s.searchAmountRange),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _AmountField(
                    label: s.searchMinAmount,
                    controller: _minController,
                    onChanged: (v) => setState(
                      () =>
                          _draft = _draft.copyWith(minAmount: int.tryParse(v)),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _AmountField(
                    label: s.searchMaxAmount,
                    controller: _maxController,
                    onChanged: (v) => setState(
                      () =>
                          _draft = _draft.copyWith(maxAmount: int.tryParse(v)),
                    ),
                  ),
                ),
              ],
            ),
            if (!_draft.isAmountRangeValid) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                s.searchAmountRangeError,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: context.colors.critical),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),

            // ── Planned status ──────────────────────────────────────────────
            SectionHeader(title: s.searchPlanned),
            ChoiceChipGroup<PlannedStatus?>(
              selected: _draft.plannedStatus,
              onChanged: (v) =>
                  setState(() => _draft = _draft.copyWith(plannedStatus: v)),
              options: [
                ChipOption(value: null, label: s.searchAny),
                ChipOption(value: PlannedStatus.planned, label: s.planned),
                ChipOption(value: PlannedStatus.unplanned, label: s.unplanned),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Spending type ───────────────────────────────────────────────
            SectionHeader(title: s.searchSpendingType),
            ChoiceChipGroup<SpendingType?>(
              selected: _draft.spendingType,
              onChanged: (v) =>
                  setState(() => _draft = _draft.copyWith(spendingType: v)),
              options: [
                ChipOption(value: null, label: s.searchAny),
                ChipOption(value: SpendingType.need, label: s.need),
                ChipOption(value: SpendingType.want, label: s.want),
                ChipOption(value: SpendingType.lifestyle, label: s.lifestyle),
                ChipOption(value: SpendingType.emergency, label: s.emergency),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Receipt ─────────────────────────────────────────────────────
            SectionHeader(title: s.searchReceipt),
            ChoiceChipGroup<bool?>(
              selected: _draft.hasReceipt,
              onChanged: (v) =>
                  setState(() => _draft = _draft.copyWith(hasReceipt: v)),
              options: [
                ChipOption(value: null, label: s.searchAny),
                ChipOption(value: true, label: s.searchReceiptWith),
                ChipOption(value: false, label: s.searchReceiptWithout),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Sort (always exactly one) ───────────────────────────────────
            SectionHeader(title: s.searchSort),
            ChoiceChipGroup<SortOption>(
              selected: _draft.sort,
              onChanged: (v) =>
                  setState(() => _draft = _draft.copyWith(sort: v)),
              options: [
                ChipOption(value: SortOption.newest, label: s.searchSortNewest),
                ChipOption(value: SortOption.oldest, label: s.searchSortOldest),
                ChipOption(
                  value: SortOption.highest,
                  label: s.searchSortHighest,
                ),
                ChipOption(value: SortOption.lowest, label: s.searchSortLowest),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            // ── Footer ──────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: s.searchClearFilters,
                    onPressed: () => Navigator.of(context).pop(
                      SearchTransactionParams(keyword: widget.current.keyword),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryButton(
                    label: s.searchApply,
                    onPressed: _draft.isAmountRangeValid
                        ? () => Navigator.of(context).pop(_draft)
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAccount(BuildContext context, Strings s) async {
    final account = await AccountPickerSheet.show(
      context,
      title: s.searchAccount,
      accounts: widget.accounts,
      selectedId: _draft.accountId,
    );
    if (!context.mounted) return;
    if (account?.id == null) return;
    setState(() => _draft = _draft.copyWith(accountId: account!.id));
  }

  Future<void> _pickCategory(BuildContext context, Strings s) async {
    final category = await CategoryPickerSheet.show(
      context,
      title: s.searchCategory,
      categories: widget.categories,
      selectedId: _draft.categoryId,
    );
    if (!context.mounted) return;
    if (category?.id == null) return;
    setState(() => _draft = _draft.copyWith(categoryId: category!.id));
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final hasRange = _draft.startDate != null && _draft.endDate != null;
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5, 12, 31),
      initialDateRange: hasRange
          ? DateTimeRange(
              start: DateTime.fromMillisecondsSinceEpoch(_draft.startDate!),
              // stored end is exclusive next-day midnight → inclusive last day.
              end: DateTime.fromMillisecondsSinceEpoch(
                _draft.endDate!,
              ).subtract(const Duration(days: 1)),
            )
          : null,
    );
    if (!context.mounted) return;
    if (range == null) return;
    setState(() {
      _draft = _draft.copyWith(
        startDate: DateTime(
          range.start.year,
          range.start.month,
          range.start.day,
        ).millisecondsSinceEpoch,
        // exclusive upper bound = midnight after the picked end day.
        endDate: DateTime(
          range.end.year,
          range.end.month,
          range.end.day + 1,
        ).millisecondsSinceEpoch,
      );
    });
  }

  String? _dateRangeLabel(BuildContext context) {
    final start = _draft.startDate;
    final end = _draft.endDate;
    if (start == null && end == null) return null;
    final loc = MaterialLocalizations.of(context);
    final startLabel = start == null
        ? '…'
        : loc.formatMediumDate(DateTime.fromMillisecondsSinceEpoch(start));
    final endLabel = end == null
        ? '…'
        : loc.formatMediumDate(
            DateTime.fromMillisecondsSinceEpoch(
              end,
            ).subtract(const Duration(days: 1)),
          );
    return '$startLabel – $endLabel';
  }

  String? _accountName(int? id) {
    if (id == null) return null;
    for (final a in widget.accounts) {
      if (a.id == id) return a.name;
    }
    return null;
  }

  String? _categoryName(int? id) {
    if (id == null) return null;
    for (final c in widget.categories) {
      if (c.id == id) return c.name;
    }
    return null;
  }
}

/// A [SelectorField] with an inline "Clear" text action (shown only when the
/// facet is set) that resets it to "Any".
class _ClearableSelector extends StatelessWidget {
  const _ClearableSelector({
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

/// A labeled [AmountInputField] (label above the rupiah pill) for the min/max
/// amount bounds.
class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: context.colors.textSecondary),
      ),
      const SizedBox(height: AppSpacing.xs),
      AmountInputField(controller: controller, onChanged: onChanged),
    ],
  );
}
