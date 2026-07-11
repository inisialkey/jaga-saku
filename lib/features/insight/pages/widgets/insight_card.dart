import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/insight/pages/insight_rules.dart';

/// Spending-Insight card (style guide §13.14): a 32 icon container in the type's
/// color + the localized, non-judgmental body (style guide §23 — help, don't
/// blame). The pure [InsightItem] carries only the type + interpolation params;
/// the localized copy is chosen here from the type (each type is produced by
/// exactly one rule in [computeInsights]).
class InsightCard extends StatelessWidget {
  const InsightCard({required this.item, super.key});

  final InsightItem item;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final color = _color(context, item.type);
    return AppCard(
      child: Row(
        children: [
          CategoryIconAvatar.glyph(
            icon: _icon(item.type),
            color: color,
            size: 32,
            iconSize: 18,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              _message(s, item),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Color _color(BuildContext context, InsightType type) => switch (type) {
    InsightType.warning => context.colors.warning,
    InsightType.critical => context.colors.critical,
    InsightType.trendUp => context.colors.transfer,
    InsightType.tip => context.colors.info,
  };

  IconData _icon(InsightType type) => switch (type) {
    InsightType.warning => Icons.warning_amber_rounded,
    InsightType.critical => Icons.error_outline_rounded,
    InsightType.trendUp => Icons.trending_up_rounded,
    InsightType.tip => Icons.lightbulb_outline_rounded,
  };

  /// Localized copy per type — each type is produced by exactly one rule in
  /// [computeInsights].
  String _message(Strings s, InsightItem item) => switch (item.type) {
    InsightType.warning => s.insightBudgetUsed(
      item.category ?? '',
      item.pct ?? 0,
    ),
    InsightType.critical => s.insightBudgetOver(item.category ?? ''),
    InsightType.trendUp => s.insightCategoryUp(
      item.category ?? '',
      item.pct ?? 0,
    ),
    InsightType.tip => s.insightUnplannedUp,
  };
}
