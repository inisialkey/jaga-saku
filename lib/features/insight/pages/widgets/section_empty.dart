import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Compact per-section empty hint (a muted icon + one line) for the bar-style
/// sections (planned/unplanned, need/want, insights) — smaller than the full
/// [EmptyStateView] so an empty month reads as a calm stack of gentle notes, not
/// four large placeholders (style guide §15, non-crowded §23).
class SectionEmpty extends StatelessWidget {
  const SectionEmpty({
    required this.text,
    super.key,
    this.icon = Icons.inbox_outlined,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 20, color: context.colors.textTertiary),
      const SizedBox(width: AppSpacing.md),
      Expanded(
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: context.colors.textSecondary),
        ),
      ),
    ],
  );
}
