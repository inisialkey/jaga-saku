import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Icon-led hero (NON-BLOCKING Q10 — no illustrator dependency). Swappable for
/// art later without a layout change: this returns an intrinsically-sized
/// widget, never a `SizedBox` with a fixed height, because the CTA block is
/// bottom-pinned and a fixed hero overflows at the 1.3× Dynamic-Type ceiling
/// (`app.dart:88-93`).
class OnboardingHero extends StatelessWidget {
  const OnboardingHero({
    required this.icon,
    required this.semanticLabel,
    super.key,
    this.size = 96,
    this.iconSize = 48,
    this.satellites = const [],
  });

  final IconData icon;

  /// Read aloud in place of the composition (§19 — a hero is never mute).
  final String semanticLabel;
  final double size;
  final double iconSize;

  /// Optional small glyphs overlaid on the wash circle's lower corners — the
  /// Welcome step's "money in / money out" arrows.
  final List<OnboardingHeroSatellite> satellites;

  @override
  Widget build(BuildContext context) {
    // primaryLight is a LIGHT-MODE value; on dark it turns into a glaring mint
    // chip, so the dark wash is a translucent primary instead.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wash = isDark
        ? AppColors.primary.withValues(alpha: 0.16)
        : AppColors.primaryLight;

    return Semantics(
      label: semanticLabel,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(color: wash, shape: BoxShape.circle),
              child: Icon(icon, size: iconSize, color: AppColors.primary),
            ),
            for (final satellite in satellites)
              Positioned(
                bottom: 0,
                left: satellite.onLeft ? -AppSpacing.sm : null,
                right: satellite.onLeft ? null : -AppSpacing.sm,
                child: _Satellite(satellite: satellite),
              ),
          ],
        ),
      ),
    );
  }
}

/// One overlaid glyph on an [OnboardingHero]'s wash circle.
class OnboardingHeroSatellite {
  const OnboardingHeroSatellite({
    required this.icon,
    required this.color,
    required this.onLeft,
  });

  final IconData icon;
  final Color color;

  /// Which lower corner of the wash circle this glyph sits on.
  final bool onLeft;
}

class _Satellite extends StatelessWidget {
  const _Satellite({required this.satellite});

  final OnboardingHeroSatellite satellite;

  @override
  Widget build(BuildContext context) => Container(
    width: 32,
    height: 32,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      shape: BoxShape.circle,
      border: Border.all(color: context.colors.border),
    ),
    child: Icon(satellite.icon, size: 18, color: satellite.color),
  );
}
