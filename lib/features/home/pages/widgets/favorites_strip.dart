import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/home/pages/home_cubit.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_page.dart';

/// Home quick-tap favorites strip: a horizontal row of favorite chips. Tapping
/// any favorite opens the add-form prefilled from it as a **new** tx — the user
/// commits by saving. It used to instant-commit a fixed-amount favorite, but the
/// Undo that made that safe died with the SnackBar, leaving a mis-tap as a
/// silent write; a prefilled form is the same two taps and is reversible by
/// simply backing out. Hidden entirely when there are no favorites (no clutter).
/// The chip icon reuses the referenced category's icon/color (from the dashboard
/// lookups), falling back to the transfer glyph for transfers / uncategorized
/// favorites.
class FavoritesStrip extends StatelessWidget {
  const FavoritesStrip({
    required this.favorites,
    required this.dashboard,
    super.key,
  });

  final List<TxTemplate> favorites;
  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) return const SizedBox.shrink();
    final s = Strings.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: s.favorites),
        SizedBox(
          // Tall enough for the 36px avatar + a two-line label + the amount in
          // the real font; scales with Dynamic Type (pixel-identical at 1.0×) so
          // nothing clips when the system font size grows.
          height: MediaQuery.textScalerOf(context).scale(132),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: favorites.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) =>
                _FavoriteChip(template: favorites[index], dashboard: dashboard),
          ),
        ),
      ],
    );
  }
}

class _FavoriteChip extends StatelessWidget {
  const _FavoriteChip({required this.template, required this.dashboard});

  final TxTemplate template;
  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = template;
    final isTransfer = t.type == TransactionType.transfer;
    final category = t.categoryId == null
        ? null
        : dashboard.categoriesById[t.categoryId];
    // Transfers / uncategorized favorites fall back to the transfer glyph, like
    // the recent-transactions tile (home_page.dart).
    final iconKey = isTransfer ? 'transfer' : category?.icon;
    final color = isTransfer ? AppColors.transfer.toARGB32() : category?.color;

    return InkWell(
      onTap: () =>
          context.push(AppRoute.add, extra: AddTransactionArgs(prefill: t)),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        // Wide enough that a three-word favorite ("Uang Makan Mingguan") wraps
        // to two lines instead of spilling to a clipped third line.
        width: 116,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CategoryIconAvatar(icon: iconKey, color: color, size: 36),
            const SizedBox(height: AppSpacing.sm),
            // Two lines so a normal favorite name ("Beras Bulanan", "Uang
            // Makan") shows in full; only a genuinely long name ellipsizes.
            Text(
              t.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
            if (t.amount != null)
              // scaleDown keeps the full amount readable in the narrow 96px chip
              // — a clipped "Rp 2.50…" is unreadable money (same idiom as the
              // hero card / transaction tile). The title above stays ellipsized:
              // a label can be arbitrarily long, so truncating it reads better
              // than shrinking it to microscopic.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  formatRupiah(t.amount!),
                  maxLines: 1,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
