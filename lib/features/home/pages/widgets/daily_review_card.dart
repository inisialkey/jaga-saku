import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Daily Review card (style guide §13.7) — a light, non-judgmental summary of
/// today's spending: total spent, largest category and unplanned amount.
///
/// Tone stays helpful, never scolding (§13.7). When nothing has been spent yet
/// today it shows a friendly zero-state line instead of a row of `Rp 0`s.
class DailyReviewCard extends StatelessWidget {
  const DailyReviewCard({
    required this.todaySpent,
    required this.todayUnplanned,
    this.topCategoryName,
    super.key,
  });

  final int todaySpent;
  final int todayUnplanned;
  final String? topCategoryName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = Strings.of(context)!;
    final topCategory = topCategoryName;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ReviewIcon(),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(s.dailyReview, style: theme.textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (todaySpent <= 0)
            Text(
              s.noSpendingToday,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            )
          else ...[
            Text(
              s.todaySpent(formatRupiah(todaySpent)),
              style: theme.textTheme.bodyLarge,
            ),
            if (topCategory != null && topCategory.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                s.topCategory(topCategory),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
            if (todayUnplanned > 0) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${s.unplanned}: ${formatRupiah(todayUnplanned)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// Soft-tinted analytics glyph for the review header.
class _ReviewIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: 36,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: context.colors.info.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
    child: Icon(Icons.insights_rounded, size: 20, color: context.colors.info),
  );
}
