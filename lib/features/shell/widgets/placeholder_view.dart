import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Trivial M0 placeholder for a not-yet-built screen. Real screens land in
/// M1+. Shows the destination name + a calm "coming soon" line.
class PlaceholderView extends StatelessWidget {
  const PlaceholderView({
    required this.title,
    required this.icon,
    super.key,
    this.showClose = false,
  });

  final String title;
  final IconData icon;

  /// When true, shows a close button in the app bar (used by the full-screen
  /// `/add` route).
  final bool showClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      appBar: AppBar(
        title: Text(title),
        leading: showClose ? const CloseButton() : null,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: context.colors.textTertiary),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              Strings.of(context)?.comingSoon ?? 'Coming soon',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
