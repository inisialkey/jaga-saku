import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/insight/pages/insight_cubit.dart';
import 'package:jaga_saku/features/insight/pages/widgets/section_empty.dart';

/// Planned vs. Unplanned card (wireframe §4): two labelled [ProgressBarX] rows
/// (planned green, unplanned warning) with amounts + percents. The percents are
/// of the typed subset (expenses with a `plannedStatus`); a month with no such
/// expenses shows the section's compact empty hint.
class PlannedUnplannedCard extends StatelessWidget {
  const PlannedUnplannedCard({required this.split, super.key});

  final PlannedSplit split;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final colors = context.colors;
    return AppCard(
      child: split.total == 0
          ? SectionEmpty(
              icon: Icons.donut_small_outlined,
              text: s.noDataThisMonth,
            )
          : Column(
              children: [
                _BarRow(
                  label: s.planned,
                  amount: split.planned,
                  pct: split.plannedPct,
                  color: colors.success,
                ),
                const SizedBox(height: AppSpacing.lg),
                _BarRow(
                  label: s.unplanned,
                  amount: split.unplanned,
                  pct: split.unplannedPct,
                  color: colors.warning,
                ),
              ],
            ),
    );
  }
}

/// A label + amount over a percent-filled bar (the wireframe's two-line row).
class _BarRow extends StatelessWidget {
  const _BarRow({
    required this.label,
    required this.amount,
    required this.pct,
    required this.color,
  });

  final String label;
  final int amount;
  final double pct;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
            MoneyText(amount: amount, style: theme.textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: ProgressBarX(value: pct, color: color),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 40,
              child: Text(
                '${(pct * 100).round()}%',
                textAlign: TextAlign.end,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
