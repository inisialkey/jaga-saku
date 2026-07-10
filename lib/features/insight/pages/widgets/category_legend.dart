import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/insight/pages/insight_cubit.dart';

/// Legend under the donut (wireframe §4): one row per [CategorySlice] with the
/// category avatar (in its color), the name, the amount and its percent of the
/// month's expense. Dumb value-in list — the slices are pre-sorted by the cubit.
class CategoryLegend extends StatelessWidget {
  const CategoryLegend({
    required this.slices,
    required this.categoriesById,
    super.key,
  });

  final List<CategorySlice> slices;
  final Map<int, Category> categoriesById;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final slice in slices)
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md),
          child: _LegendRow(
            slice: slice,
            icon: categoriesById[slice.categoryId]?.icon,
          ),
        ),
    ],
  );
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.slice, this.icon});

  final CategorySlice slice;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CategoryIconAvatar(icon: icon, color: slice.color, size: 32),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            slice.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        MoneyText(amount: slice.amount, style: theme.textTheme.bodyMedium),
        const SizedBox(width: AppSpacing.md),
        SizedBox(
          width: 40,
          child: Text(
            '${(slice.pct * 100).round()}%',
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
