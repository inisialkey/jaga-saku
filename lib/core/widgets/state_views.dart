import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Friendly empty state (style guide §15): large muted icon, H3 title,
/// body-medium description, optional CTA.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    required this.title,
    super.key,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => _CenteredState(
    icon: icon,
    iconColor: context.colors.textTertiary,
    title: title,
    message: message,
    actionLabel: actionLabel,
    onAction: onAction,
  );
}

/// Non-technical error state (style guide §16): clear copy + retry CTA.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    required this.title,
    super.key,
    this.message,
    this.icon = Icons.error_outline_rounded,
    this.retryLabel,
    this.onRetry,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => _CenteredState(
    icon: icon,
    iconColor: context.colors.critical,
    title: title,
    message: message,
    actionLabel: retryLabel,
    onAction: onRetry,
  );
}

class _CenteredState extends StatelessWidget {
  const _CenteredState({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 96, color: iconColor),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                expanded: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
