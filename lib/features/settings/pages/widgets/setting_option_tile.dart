import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// A selectable settings row (M6): title on the left, a primary check on the
/// right when [selected]. Backs the Appearance theme options and the Settings
/// language options. Group several inside a [HairlineCard].
class SettingOptionTile extends StatelessWidget {
  const SettingOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
    this.leading,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Optional leading widget (e.g. a category avatar for the parent picker, D4).
  /// Null keeps the plain label-only row used by the appearance/language groups.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: selected ? AppColors.primary : null,
                  fontWeight: selected ? FontWeight.w600 : null,
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
