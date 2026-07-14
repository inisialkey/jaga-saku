import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/pages/widgets/budget_status_badge.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';

/// One budget row (style guide §13.6 / wireframe Budget screen): category icon +
/// name + status badge, `spent / limit` with %, a status-colored progress bar,
/// and the remaining + safe-daily lines. Dumb widget — [onTap] edits, [onDelete]
/// (the trailing trash) is wired by the list page.
class BudgetItemCard extends StatelessWidget {
  const BudgetItemCard({
    required this.budget,
    required this.status,
    super.key,
    this.category,
    this.onTap,
    this.onDelete,
  });

  final Budget budget;
  final BudgetStatus status;
  final Category? category;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = Strings.of(context)!;
    final color = budgetStatusColor(context, status.level);
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CategoryIconAvatar(icon: category?.icon, color: category?.color),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  category?.name ?? s.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              BudgetStatusBadge(level: status.level),
              if (onDelete != null)
                IconButton(
                  tooltip: s.delete,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: context.colors.textSecondary,
                  ),
                  onPressed: onDelete,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  s.spentOfLimit(
                    formatRupiah(budget.spent),
                    formatRupiah(budget.limitAmount),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Text(
                '${status.percent}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ProgressBarX(value: status.ratio, color: color),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  status.remaining >= 0
                      ? s.remainingBudget(formatRupiah(status.remaining))
                      : s.overBudget,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: status.remaining >= 0
                        ? context.colors.textSecondary
                        : context.colors.critical,
                  ),
                ),
              ),
              Text(
                s.safeDaily(formatRupiah(status.safeDaily)),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
