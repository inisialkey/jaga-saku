import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/onboarding_hero.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/onboarding_step_body.dart';

/// Step 1 — the reassuring opener. Purely presentational (no `context.read`) so
/// it pumps standalone in `dark_mode_smoke_test.dart` without a `BlocProvider`.
class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return OnboardingStepBody(
      hero: OnboardingHero(
        icon: Iconsax.wallet,
        semanticLabel: s.onboardingWelcomeHeroSemantic,
        satellites: [
          // "Money in, money out" — the whole app in one glance.
          OnboardingHeroSatellite(
            icon: Icons.arrow_downward_rounded,
            color: context.colors.income,
            onLeft: true,
          ),
          OnboardingHeroSatellite(
            icon: Icons.arrow_upward_rounded,
            color: context.colors.expense,
            onLeft: false,
          ),
        ],
      ),
      title: s.onboardingWelcomeTitle,
      body: s.onboardingWelcomeBody,
    );
  }
}
