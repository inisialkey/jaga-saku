import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Total Balance hero (style guide §13.5, mockup screen 1) — the strongest
/// visual on Home. A green gradient card: "Total Saldo" label, the balance as
/// the largest amount on the screen, then this month's income + expense.
///
/// On the green surface the amounts render white; the income / expense
/// direction is carried by the small up / down arrow accents (green / red) so
/// the semantics stay readable against the green (the mockup's treatment).
class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({
    required this.totalBalance,
    required this.monthIncome,
    required this.monthExpense,
    super.key,
  });

  final int totalBalance;
  final int monthIncome;
  final int monthExpense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = Strings.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.totalBalance,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // MoneyText with a white base + neutral sign keeps the amount white on
          // the green card while staying the largest text on the screen.
          MoneyText(
            amount: totalBalance,
            style: theme.textTheme.displayLarge?.copyWith(
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            s.thisMonth,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _SummaryPill(
                  icon: Icons.arrow_upward_rounded,
                  accent: context.colors.income,
                  label: s.income,
                  amount: monthIncome,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _SummaryPill(
                  icon: Icons.arrow_downward_rounded,
                  accent: context.colors.expense,
                  label: s.expense,
                  amount: monthExpense,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One income / expense figure on the hero card: a small tinted arrow chip, the
/// label, then the amount in white.
class _SummaryPill extends StatelessWidget {
  const _SummaryPill({
    required this.icon,
    required this.accent,
    required this.label,
    required this.amount,
  });

  final IconData icon;
  final Color accent;
  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: accent),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  formatRupiah(amount),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
