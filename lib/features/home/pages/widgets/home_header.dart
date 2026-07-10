import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Home greeting row (wireframe §1): "Hi, {name}" + the app tagline, with a
/// notification bell on the right.
///
/// The bell is **inert / decorative** in M3 — notifications were stripped in M0
/// and are out of scope (V2). It is here only to match the mockup's visual
/// balance; it does not route anywhere.
class HomeHeader extends StatelessWidget {
  const HomeHeader({required this.userName, super.key});

  /// Greeting name from settings; null → the guest greeting ("Hi 👋").
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = Strings.of(context)!;
    final name = userName?.trim();
    final greeting = (name == null || name.isEmpty)
        ? s.greetingGuest
        : s.greeting(name);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(greeting, style: theme.textTheme.headlineLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                s.appTagline,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        // ponytail: inert bell — no notification system in M3 (V2). Decorative
        // only, so it is excluded from the tap surface.
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.colors.surfaceSoft,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
