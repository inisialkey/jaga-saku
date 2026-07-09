import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Tappable selector row (style guide §13.12): 52h, bordered, leading label,
/// current value, trailing chevron. Opens a picker / bottom sheet via [onTap].
class SelectorField extends StatelessWidget {
  const SelectorField({
    required this.label,
    required this.onTap,
    super.key,
    this.value,
    this.icon,
  });

  final String label;
  final String? value;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: context.colors.textSecondary),
              const SizedBox(width: AppSpacing.md),
            ],
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const Spacer(),
            if (value != null)
              Flexible(
                child: Text(
                  value!,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.chevron_right_rounded,
              color: context.colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
