import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// A single reorderable favorite row: a type-colored glyph avatar + label,
/// trailing amount (or an em dash for an amount-less favorite) and a drag handle.
/// Dumb widget — tap / long-press are wired by the list page. The manage list
/// carries no category lookup (its cubit loads only templates), so the glyph is
/// resolved from the [TxTemplate.type]; the Home chip uses the category icon.
/// Needs a stable ancestor [Key] from the [ReorderableListView].
class FavoriteTile extends StatelessWidget {
  const FavoriteTile({
    required this.template,
    required this.index,
    super.key,
    this.onTap,
    this.onLongPress,
  });

  final TxTemplate template;

  /// Position in the reorderable list — drives the drag handle.
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, color) = _glyph(context);
    final amount = template.amount;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            CategoryIconAvatar.glyph(icon: icon, color: color),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                template.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (amount != null)
              MoneyText(amount: amount, style: theme.textTheme.bodyLarge)
            else
              Text(
                '—',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
            ReorderableDragStartListener(
              index: index,
              child: Icon(
                Icons.drag_indicator_rounded,
                color: context.colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color) _glyph(BuildContext context) {
    final colors = context.colors;
    return switch (template.type) {
      TransactionType.transfer => (
        Iconsax.arrow_swap_horizontal,
        colors.transfer,
      ),
      TransactionType.income => (Iconsax.arrow_down, colors.income),
      TransactionType.expense => (Iconsax.arrow_up, colors.expense),
    };
  }
}
