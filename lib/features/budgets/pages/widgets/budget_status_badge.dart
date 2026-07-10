import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';

/// Semantic color for a budget status level (safe = green, warning = orange,
/// critical = red — style guide §13.6). Shared by the progress bars + badges on
/// the Budget list and the Home guard card so the mapping lives in one place.
Color budgetStatusColor(BuildContext context, BudgetStatusLevel level) =>
    switch (level) {
      BudgetStatusLevel.safe => context.colors.success,
      BudgetStatusLevel.warning => context.colors.warning,
      BudgetStatusLevel.critical => context.colors.critical,
    };

/// Localized, non-judgmental label for a budget status level.
String budgetStatusLabel(Strings s, BudgetStatusLevel level) => switch (level) {
  BudgetStatusLevel.safe => s.statusSafe,
  BudgetStatusLevel.warning => s.statusWarning,
  BudgetStatusLevel.critical => s.statusCritical,
};

/// Small tinted pill showing the localized status label in its status color.
class BudgetStatusBadge extends StatelessWidget {
  const BudgetStatusBadge({required this.level, super.key});

  final BudgetStatusLevel level;

  @override
  Widget build(BuildContext context) {
    final color = budgetStatusColor(context, level);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        budgetStatusLabel(Strings.of(context)!, level),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
