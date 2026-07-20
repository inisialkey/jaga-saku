import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/onboarding_step_body.dart';

/// Step 2 — three benefit rows in one [HairlineCard], so the dividers, padding
/// and dark-mode behaviour come from the container that already ships them.
/// Purely presentational (no `context.read`).
class ValuePropositionStep extends StatelessWidget {
  const ValuePropositionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return OnboardingStepBody(
      title: s.onboardingValueTitle,
      body: s.onboardingValueBody,
      child: HairlineCard(
        children: [
          _BenefitRow(
            icon: Iconsax.receipt_item,
            title: s.onboardingBenefitTrackTitle,
            body: s.onboardingBenefitTrackBody,
          ),
          _BenefitRow(
            icon: Iconsax.trend_up,
            title: s.onboardingBenefitBudgetTitle,
            body: s.onboardingBenefitBudgetBody,
          ),
          _BenefitRow(
            icon: Icons.lightbulb_outline,
            title: s.onboardingBenefitHabitTitle,
            body: s.onboardingBenefitHabitBody,
          ),
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryIconAvatar.glyph(icon: icon, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
