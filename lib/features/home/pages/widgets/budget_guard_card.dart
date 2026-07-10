import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Budget Guard card (style guide §13.6) — the app's differentiating feature.
///
/// M3 renders the **empty state only**: budget CRUD + the real
/// remaining/safe-daily/progress/status content land in M4. The "Buat Budget"
/// CTA is therefore **inert** (disabled) and paired with a "Segera" badge — it
/// deliberately does NOT route anywhere (there is no budget screen yet).
///
/// ponytail: structured so M4 swaps the empty body for the live budget content
/// without touching the header or the card shell.
class BudgetGuardCard extends StatelessWidget {
  const BudgetGuardCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = Strings.of(context)!;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _GuardIcon(),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(s.budgetGuard, style: theme.textTheme.titleMedium),
              ),
              const ComingSoonBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(s.budgetEmptyTitle, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            s.budgetEmptyMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // ponytail: inert in M3 — onPressed:null disables it, so it can never
          // route to a not-yet-built budget screen. M4 wires the real action.
          SecondaryButton(label: s.createBudget, onPressed: null),
        ],
      ),
    );
  }
}

/// Brand-green shield in a soft tinted square (the Budget Guard glyph). Uses a
/// Material icon directly rather than an [AppIcons] catalog key — the catalog is
/// for DB-stored account/category icons, not decorative feature glyphs.
class _GuardIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: 36,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
    child: const Icon(
      Icons.shield_outlined,
      size: 20,
      color: AppColors.primary,
    ),
  );
}
