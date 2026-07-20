import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// The one skeleton every onboarding step wears: optional hero, title,
/// supporting copy, then step-specific [child].
///
/// Scrolls rather than flexing, because the CTA block is bottom-pinned by the
/// page — at the 1.3× Dynamic-Type ceiling (`app.dart:88-93`) the viewport must
/// give, not the layout. Nothing in here is fixed-height.
class OnboardingStepBody extends StatelessWidget {
  const OnboardingStepBody({
    required this.title,
    required this.body,
    super.key,
    this.hero,
    this.child,
  });

  final Widget? hero;
  final String title;
  final String body;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hero case final hero?) ...[
            const SizedBox(height: AppSpacing.xxl),
            Center(child: hero),
            const SizedBox(height: AppSpacing.xxxl),
          ] else
            const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          if (child case final child?) ...[
            const SizedBox(height: AppSpacing.xxl),
            child,
          ],
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
