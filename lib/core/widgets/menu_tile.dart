import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// A grouped-menu row (style guide §13, More mockup): 40 rounded soft-color icon
/// container + title + optional [trailing] + chevron. A null [onTap] renders the
/// row muted and non-tappable (used for "Soon" entries).
class MenuTile extends StatelessWidget {
  const MenuTile({
    required this.icon,
    required this.title,
    super.key,
    this.iconColor,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Color? iconColor;
  final VoidCallback? onTap;

  /// Replaces the trailing chevron (e.g. a [ComingSoonBadge]).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final color = iconColor ?? AppColors.primary;
    final theme = Theme.of(context);

    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: enabled ? null : context.colors.textTertiary,
              ),
            ),
          ),
          if (trailing != null)
            trailing!
          else if (enabled)
            Icon(
              Icons.chevron_right_rounded,
              color: context.colors.textTertiary,
            ),
        ],
      ),
    );

    if (!enabled) return row;
    return InkWell(onTap: onTap, child: row);
  }
}

/// A titled group of [MenuTile]s inside a single [AppCard], divided by hairlines
/// (plan §6). Pair with the More screen's Finance / Data / App groups.
class MenuSection extends StatelessWidget {
  const MenuSection({required this.title, required this.tiles, super.key});

  final String title;
  final List<MenuTile> tiles;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SectionHeader(title: title),
      AppCard(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          children: [
            for (var i = 0; i < tiles.length; i++) ...[
              if (i > 0) Divider(height: 1, color: context.colors.border),
              tiles[i],
            ],
          ],
        ),
      ),
    ],
  );
}
