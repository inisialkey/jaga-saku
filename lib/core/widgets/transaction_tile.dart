import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Compact ledger row (wireframe §2, style guide §12): leading category-icon
/// avatar, a title + muted subtitle, optional small badges (Need / Planned…),
/// and a trailing signed [MoneyText].
///
/// Takes primitive display values (an [AppIcons] key, an ARGB color, strings)
/// rather than a domain entity, so it lives in `core/` and is reused verbatim by
/// the Calendar (M2), Home (M3) and Insight (M5) without any feature dependency.
/// The caller resolves the category / account names into [title] / [subtitle].
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    required this.title,
    required this.amount,
    required this.sign,
    super.key,
    this.icon,
    this.color,
    this.subtitle,
    this.badges = const [],
    this.onTap,
    this.onLongPress,
  });

  /// [AppIcons] catalog key for the leading avatar.
  final String? icon;

  /// ARGB avatar color; falls back to the brand green.
  final int? color;
  final String title;

  /// Context line, e.g. "Makan • Cash".
  final String? subtitle;

  /// Small pill labels shown under the subtitle (e.g. Need, Planned).
  final List<String> badges;

  /// Positive rupiah amount; the sign + color come from [sign].
  final int amount;
  final MoneySign sign;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            CategoryIconAvatar(icon: icon, color: color),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                  if (badges.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        for (final label in badges) _Badge(label: label),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            MoneyText(
              amount: amount,
              sign: sign,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

/// A small neutral pill used for Need / Want / Planned / Unplanned tags.
class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}
