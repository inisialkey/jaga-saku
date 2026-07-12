import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/home/pages/home_cubit.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_page.dart';

/// Home quick-tap favorites strip: a horizontal row of favorite chips. Tapping a
/// fixed-amount favorite instant-commits it (with an Undo SnackBar); an
/// amount-less favorite opens the add-form prefilled as a **new** tx. Hidden
/// entirely when there are no favorites (no clutter). The chip icon reuses the
/// referenced category's icon/color (from the dashboard lookups), falling back
/// to the transfer glyph for transfers / uncategorized favorites.
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
          height: 108,
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
      onTap: () => _apply(context),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: 96,
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
            Text(
              t.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
            if (t.amount != null)
              Text(
                formatRupiah(t.amount!),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Applies the favorite and reacts to the cubit's [ApplyFavoriteResult]:
  /// commit → an Undo SnackBar (the app `Toast` has no action button, so this
  /// uses the native [ScaffoldMessenger]); amount-less → open the prefilled
  /// add-form; failure → a localized error toast.
  Future<void> _apply(BuildContext context) async {
    final s = Strings.of(context)!;
    final cubit = context.read<HomeCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final result = await cubit.applyFavorite(template);
    if (!context.mounted) return;
    switch (result) {
      case FavoriteCommitted(:final txId):
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(s.favoriteApplied),
              action: SnackBarAction(
                label: s.favoriteUndo,
                onPressed: () => cubit.undoApply(txId),
              ),
            ),
          );
      case FavoriteNeedsPrefill(:final template):
        context.push(
          AppRoute.add,
          extra: AddTransactionArgs(prefill: template),
        );
      case FavoriteApplyFailed(:final failure):
        failure.localize(context).toToastError(context);
    }
  }
}
