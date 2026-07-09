import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Small muted pill marking a not-yet-built menu entry (plan §5/§6).
class ComingSoonBadge extends StatelessWidget {
  const ComingSoonBadge({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xs,
    ),
    decoration: BoxDecoration(
      color: context.colors.surfaceSoft,
      borderRadius: BorderRadius.circular(AppRadius.pill),
    ),
    child: Text(
      Strings.of(context)!.comingSoon,
      style: Theme.of(
        context,
      ).textTheme.labelSmall?.copyWith(color: context.colors.textTertiary),
    ),
  );
}
