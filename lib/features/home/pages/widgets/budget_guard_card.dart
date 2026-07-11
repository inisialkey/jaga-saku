import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/budgets/pages/widgets/budget_status_badge.dart';
import 'package:jaga_saku/features/home/pages/home_cubit.dart';

/// Budget Guard card (style guide §13.6) — the app's differentiating feature.
///
/// M4: renders the most at-risk budget's live content (remaining, safe-daily, a
/// status-colored progress bar + status badge) when [guard] is non-null; when
/// null it shows the empty state with a now-**live** "Buat Budget" CTA that
/// routes to the Budget screen (the M3 [ComingSoonBadge] + inert button are
/// gone).
class BudgetGuardCard extends StatelessWidget {
  const BudgetGuardCard({super.key, this.guard});

  final BudgetGuardView? guard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = Strings.of(context)!;
    final guard = this.guard;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CategoryIconAvatar.glyph(
                icon: Icons.shield_outlined,
                color: AppColors.primary,
                size: 36,
                iconSize: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(s.budgetGuard, style: theme.textTheme.titleMedium),
              ),
              if (guard != null) BudgetStatusBadge(level: guard.level),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (guard == null)
            ..._empty(context, s, theme)
          else
            ..._live(context, s, theme, guard),
        ],
      ),
    );
  }

  /// Empty state: friendly copy + a live CTA onto the Budget screen.
  List<Widget> _empty(BuildContext context, Strings s, ThemeData theme) => [
    Text(s.budgetEmptyTitle, style: theme.textTheme.bodyLarge),
    const SizedBox(height: AppSpacing.xs),
    Text(
      s.budgetEmptyMessage,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: context.colors.textSecondary,
      ),
    ),
    const SizedBox(height: AppSpacing.lg),
    SecondaryButton(
      label: s.createBudget,
      onPressed: () => context.push(AppRoute.budget),
    ),
  ];

  /// Live content for the most at-risk budget.
  List<Widget> _live(
    BuildContext context,
    Strings s,
    ThemeData theme,
    BudgetGuardView guard,
  ) {
    final color = budgetStatusColor(context, guard.level);
    return [
      Row(
        children: [
          CategoryIconAvatar(
            icon: guard.categoryIcon,
            color: guard.categoryColor,
            size: 36,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              guard.categoryName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      ProgressBarX(value: guard.ratio, color: color),
      const SizedBox(height: AppSpacing.sm),
      Row(
        children: [
          Expanded(
            child: Text(
              guard.remaining >= 0
                  ? s.remainingBudget(formatRupiah(guard.remaining))
                  : s.overBudget,
              style: theme.textTheme.bodySmall?.copyWith(
                color: guard.remaining >= 0
                    ? context.colors.textSecondary
                    : context.colors.critical,
              ),
            ),
          ),
          Text(
            s.safeDaily(formatRupiah(guard.safeDaily)),
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    ];
  }
}
