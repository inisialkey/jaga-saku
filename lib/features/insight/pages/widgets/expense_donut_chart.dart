import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/insight/pages/insight_cubit.dart';
import 'package:jaga_saku/features/insight/pages/widgets/category_legend.dart';

/// Expense-by-Category card (wireframe §4, style guide §14 Donut) — the one real
/// `fl_chart` chart on the tab. A donut with one wedge per [CategorySlice] in
/// the category's own color, the month's total expense in the center hole, and a
/// [CategoryLegend] below. Empty (no expense) → the friendly [EmptyStateView].
class ExpenseDonutChart extends StatelessWidget {
  const ExpenseDonutChart({
    required this.slices,
    required this.totalExpense,
    required this.categoriesById,
    super.key,
  });

  final List<CategorySlice> slices;
  final int totalExpense;
  final Map<int, Category> categoriesById;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    if (slices.isEmpty) {
      return AppCard(
        child: EmptyStateView(
          icon: Icons.pie_chart_outline_rounded,
          title: s.noExpenseThisMonth,
        ),
      );
    }

    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 64,
                    sections: [
                      for (final slice in slices)
                        PieChartSectionData(
                          value: slice.amount.toDouble(),
                          color: _sliceColor(slice),
                          radius: 28,
                          showTitle: false,
                        ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s.expense,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    Text(
                      formatRupiah(totalExpense),
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          CategoryLegend(slices: slices, categoriesById: categoriesById),
        ],
      ),
    );
  }

  /// The category's stored color, falling back to the brand green (same fallback
  /// as [CategoryIconAvatar]) so a color-less category still renders a wedge.
  Color _sliceColor(CategorySlice slice) =>
      slice.color != null ? Color(slice.color!) : AppColors.primary;
}
