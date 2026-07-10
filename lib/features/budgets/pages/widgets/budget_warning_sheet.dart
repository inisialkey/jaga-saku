import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Bottom sheet shown when an expense would pass the category's safe daily limit
/// (wireframe §3). Non-judgmental copy. Resolves to `true` when the user keeps
/// saving ([keepSaving]), `false` / `null` when they choose to edit the amount.
class BudgetWarningSheet extends StatelessWidget {
  const BudgetWarningSheet({
    required this.categoryName,
    required this.safeDaily,
    required this.amount,
    super.key,
  });

  final String categoryName;
  final int safeDaily;
  final int amount;

  /// Shows the sheet and returns whether the user chose to save anyway.
  static Future<bool> show(
    BuildContext context, {
    required String categoryName,
    required int safeDaily,
    required int amount,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      builder: (_) => BudgetWarningSheet(
        categoryName: categoryName,
        safeDaily: safeDaily,
        amount: amount,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = Strings.of(context)!;
    return AppBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: context.colors.warning,
            size: 40,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            s.budgetWarningTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            s.budgetWarningBody(
              categoryName,
              formatRupiah(safeDaily),
              formatRupiah(amount),
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: s.keepSaving,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.textSecondary,
            ),
            child: Text(s.editAmount),
          ),
        ],
      ),
    );
  }
}
