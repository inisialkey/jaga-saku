import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction_source.dart';

/// The removable active-filter chip bar shown above the search results. One pill
/// per active facet (tap it to drop just that facet) plus a "Clear filters"
/// action; renders nothing when no filter is active. Reads facet display names
/// via the injected [accountName] / [categoryName] resolvers (id → name).
class ActiveFilterChips extends StatelessWidget {
  const ActiveFilterChips({
    required this.params,
    required this.accountName,
    required this.categoryName,
    required this.onRemove,
    required this.onClearAll,
    super.key,
  });

  final SearchTransactionParams params;
  final String? Function(int? id) accountName;
  final String? Function(int? id) categoryName;
  final ValueChanged<SearchTransactionParams> onRemove;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    if (params.activeFilterCount == 0) return const SizedBox.shrink();
    final s = Strings.of(context)!;
    final chips = _chips(context, s);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        0,
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final chip in chips)
            _RemovableChip(
              label: chip.label,
              onRemove: () => onRemove(chip.removed),
            ),
          TextButtonX(label: s.searchClearFilters, onPressed: onClearAll),
        ],
      ),
    );
  }

  /// One entry per active facet: its label + the params with that facet dropped.
  /// Order matches [SearchTransactionParams.activeFilterCount] so the chip count
  /// equals the filter-button badge.
  List<({String label, SearchTransactionParams removed})> _chips(
    BuildContext context,
    Strings s,
  ) {
    final p = params;
    return [
      if (p.startDate != null || p.endDate != null)
        (
          label: _dateLabel(context, p),
          removed: p.copyWith(startDate: null, endDate: null),
        ),
      if (p.accountId != null)
        (
          label: accountName(p.accountId) ?? s.searchAccount,
          removed: p.copyWith(accountId: null),
        ),
      if (p.categoryId != null)
        (
          label: categoryName(p.categoryId) ?? s.searchCategory,
          removed: p.copyWith(categoryId: null),
        ),
      if (p.type != null)
        (label: _typeLabel(s, p.type!), removed: p.copyWith(type: null)),
      if (p.source != null)
        (label: _sourceLabel(s, p.source!), removed: p.copyWith(source: null)),
      if (p.minAmount != null)
        (
          label: '≥ ${formatRupiah(p.minAmount!)}',
          removed: p.copyWith(minAmount: null),
        ),
      if (p.maxAmount != null)
        (
          label: '≤ ${formatRupiah(p.maxAmount!)}',
          removed: p.copyWith(maxAmount: null),
        ),
      if (p.plannedStatus != null)
        (
          label: _plannedLabel(s, p.plannedStatus!),
          removed: p.copyWith(plannedStatus: null),
        ),
      if (p.spendingType != null)
        (
          label: _spendingLabel(s, p.spendingType!),
          removed: p.copyWith(spendingType: null),
        ),
      if (p.hasReceipt != null)
        (
          label: p.hasReceipt! ? s.searchReceiptWith : s.searchReceiptWithout,
          removed: p.copyWith(hasReceipt: null),
        ),
    ];
  }

  String _dateLabel(BuildContext context, SearchTransactionParams p) {
    final loc = MaterialLocalizations.of(context);
    final start = p.startDate == null
        ? '…'
        : loc.formatMediumDate(
            DateTime.fromMillisecondsSinceEpoch(p.startDate!),
          );
    // endDate is the exclusive next-day midnight; show the inclusive last day.
    final end = p.endDate == null
        ? '…'
        : loc.formatMediumDate(
            DateTime.fromMillisecondsSinceEpoch(
              p.endDate!,
            ).subtract(const Duration(days: 1)),
          );
    return '$start – $end';
  }

  String _typeLabel(Strings s, TransactionType type) => switch (type) {
    TransactionType.expense => s.expense,
    TransactionType.income => s.income,
    TransactionType.transfer => s.transfer,
  };

  String _sourceLabel(Strings s, TransactionSource source) => switch (source) {
    TransactionSource.manual => s.searchSourceManual,
    TransactionSource.reconciliation => s.searchSourceReconciliation,
  };

  String _plannedLabel(Strings s, PlannedStatus status) => switch (status) {
    PlannedStatus.planned => s.planned,
    PlannedStatus.unplanned => s.unplanned,
  };

  String _spendingLabel(Strings s, SpendingType type) => switch (type) {
    SpendingType.need => s.need,
    SpendingType.want => s.want,
    SpendingType.lifestyle => s.lifestyle,
    SpendingType.emergency => s.emergency,
  };
}

/// A pill showing one active facet with a trailing ✕; the whole pill is the tap
/// target that drops the facet (mirrors the app's chip visual language).
class _RemovableChip extends StatelessWidget {
  const _RemovableChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onRemove,
        customBorder: const StadiumBorder(),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs + 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(
                Icons.close_rounded,
                size: 16,
                color: AppColors.primaryDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
