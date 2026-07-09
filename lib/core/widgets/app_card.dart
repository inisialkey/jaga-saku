import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Surface card (style guide §13.4): radius 20, padding 16, soft shadow,
/// optional 1px border. Wrap content that groups related info.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.bordered = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: bordered ? Border.all(color: context.colors.border) : null,
        boxShadow: [
          // Soft shadow (style guide §10).
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: card,
    );
  }
}
