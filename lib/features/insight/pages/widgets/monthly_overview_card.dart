import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Monthly Overview card (wireframe §4): income / expense / saved as three
/// labelled rows. Amounts are colored (income green, expense red, saved green
/// when positive / red when negative) without a +/- sign to match the wireframe;
/// the money math is done in the cubit — this is a dumb value-in card.
class MonthlyOverviewCard extends StatelessWidget {
  const MonthlyOverviewCard({
    required this.income,
    required this.expense,
    required this.saved,
    super.key,
  });

  final int income;
  final int expense;
  final int saved;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final colors = context.colors;
    return AppCard(
      child: Column(
        children: [
          _Row(label: s.income, amount: income, color: colors.income),
          const SizedBox(height: AppSpacing.md),
          _Row(label: s.expense, amount: expense, color: colors.expense),
          const Divider(height: AppSpacing.xl),
          _Row(
            label: s.saved,
            amount: saved,
            color: saved >= 0 ? colors.income : colors.expense,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.amount, required this.color});

  final String label;
  final int amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
        // Neutral sign keeps the amount unsigned; the passed color survives
        // MoneyText's `copyWith(color: null)` for the neutral case.
        MoneyText(
          amount: amount,
          style: theme.textTheme.titleMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
