import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/insight/pages/insight_cubit.dart';
import 'package:jaga_saku/features/insight/pages/widgets/section_empty.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// Need vs. Want card (wireframe §4): a [ProgressBarX] row per spending type
/// that occurs, in the fixed need → want → lifestyle → emergency order, each
/// with its localized label + percent of the typed subset. A month with no
/// typed expenses shows the section's compact empty hint.
class NeedWantCard extends StatelessWidget {
  const NeedWantCard({required this.needVsWant, super.key});

  final Map<SpendingType, SpendingSlice> needVsWant;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    if (needVsWant.isEmpty) {
      return AppCard(
        child: SectionEmpty(
          icon: Icons.category_outlined,
          text: s.noDataThisMonth,
        ),
      );
    }

    // Fixed enum order (wireframe), skipping types absent this month.
    final rows = [
      for (final type in SpendingType.values)
        if (needVsWant[type] case final slice?) (type, slice),
    ];
    return AppCard(
      child: Column(
        children: [
          for (final (index, entry) in rows.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.lg),
            _TypeRow(type: entry.$1, slice: entry.$2),
          ],
        ],
      ),
    );
  }
}

class _TypeRow extends StatelessWidget {
  const _TypeRow({required this.type, required this.slice});

  final SpendingType type;
  final SpendingSlice slice;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(_label(s, type), style: theme.textTheme.bodyLarge),
            ),
            Text(
              '${(slice.pct * 100).round()}%',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ProgressBarX(value: slice.pct, color: _color(context, type)),
      ],
    );
  }

  String _label(Strings s, SpendingType type) => switch (type) {
    SpendingType.need => s.need,
    SpendingType.want => s.want,
    SpendingType.lifestyle => s.lifestyle,
    SpendingType.emergency => s.emergency,
  };

  /// A distinct semantic color per bucket (need essential = green, want =
  /// orange, lifestyle = blue, emergency = red). Four categorical bars need four
  /// colors — kept to the semantic palette (style guide §14 "few colors").
  Color _color(BuildContext context, SpendingType type) => switch (type) {
    SpendingType.need => context.colors.success,
    SpendingType.want => context.colors.warning,
    SpendingType.lifestyle => context.colors.info,
    SpendingType.emergency => context.colors.critical,
  };
}
