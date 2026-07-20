import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/onboarding_hero.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/onboarding_step_body.dart';

/// Step 4 — a single confident success mark and a three-row recap. Purely
/// presentational (no `context.read`).
class SetupSummaryStep extends StatelessWidget {
  const SetupSummaryStep({
    required this.accountCount,
    required this.totalOpeningBalance,
    super.key,
  });

  final int accountCount;
  final int totalOpeningBalance;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return OnboardingStepBody(
      hero: OnboardingHero(
        icon: Icons.check_circle_rounded,
        semanticLabel: s.onboardingSummaryHeroSemantic,
        iconSize: 56,
      ),
      title: s.onboardingSummaryTitle,
      body: s.onboardingSummaryBody,
      child: HairlineCard(
        children: [
          // IDR-only app (V5-M1 scope): a literal, not a setting or an entity.
          _SummaryRow(
            label: s.onboardingSummaryCurrency,
            child: const Text('IDR'),
          ),
          _SummaryRow(
            label: s.onboardingSummaryAccounts,
            child: Text(s.onboardingAccountCount(accountCount)),
          ),
          _SummaryRow(
            label: s.onboardingSummaryTotalBalance,
            child: MoneyText(amount: totalOpeningBalance),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          DefaultTextStyle.merge(
            style:
                theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ) ??
                const TextStyle(fontWeight: FontWeight.w600),
            child: child,
          ),
        ],
      ),
    );
  }
}
