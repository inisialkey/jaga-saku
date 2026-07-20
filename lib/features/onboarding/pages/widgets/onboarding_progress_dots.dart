import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';

/// Four animated dots marking flow position. Progress is conveyed by the dots
/// AND a semantic "Step 2 of 4" label — never colour alone (§19).
class OnboardingProgressDots extends StatelessWidget {
  const OnboardingProgressDots({required this.step, super.key});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) => Semantics(
    label: Strings.of(
      context,
    )!.onboardingStepProgress(step.index + 1, OnboardingStep.values.length),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final value in OnboardingStep.values)
          AnimatedContainer(
            duration: AppDurations.fast,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            width: value == step ? 8 : 6,
            height: value == step ? 8 : 6,
            decoration: BoxDecoration(
              color: value == step ? AppColors.primary : context.colors.border,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
      ],
    ),
  );
}
