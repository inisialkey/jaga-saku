import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/templates/pages/list/favorites_list_cubit.dart';
import 'package:jaga_saku/features/templates/pages/widgets/favorite_tile.dart';

/// Favorites manage screen: a reorderable list of [FavoriteTile]s with add /
/// edit / delete / reorder. A near-clone of `account_list_page.dart` minus
/// archive (`tx_templates` is a leaf table). The cubit is provided at the route.
class FavoritesListPage extends StatelessWidget {
  const FavoritesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocBuilder<FavoritesListCubit, FavoritesListState>(
      builder: (context, state) => AppScaffold(
        appBar: AppBar(
          title: Text(s.favorites),
          actions: [
            IconButton(
              tooltip: s.favoriteAdd,
              icon: const Icon(Iconsax.add),
              onPressed: () => _openFavoriteForm(context),
            ),
          ],
        ),
        body: switch (state) {
          FavoritesListInitial() ||
          FavoritesListLoading() => const ListSkeleton(),
          FavoritesListError(:final failure) => ErrorStateView(
            title: s.errorLoadTitle,
            message: failure.localize(context),
            retryLabel: s.retry,
            onRetry: () => context.read<FavoritesListCubit>().load(),
          ),
          FavoritesListLoaded(:final items) => _FavoritesListBody(items: items),
        },
      ),
    );
  }
}

class _FavoritesListBody extends StatelessWidget {
  const _FavoritesListBody({required this.items});

  final List<TxTemplate> items;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    if (items.isEmpty) {
      return EmptyStateView(
        icon: Iconsax.star,
        title: s.favoriteEmpty,
        message: s.favoriteEmptyMessage,
        actionLabel: s.favoriteAdd,
        onAction: () => _openFavoriteForm(context),
      );
    }

    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: items.length,
      onReorderItem: (oldIndex, newIndex) =>
          context.read<FavoritesListCubit>().reorder(oldIndex, newIndex),
      itemBuilder: (context, index) {
        final template = items[index];
        return FavoriteTile(
          key: ValueKey(template.id),
          template: template,
          index: index,
          onTap: () => _openFavoriteForm(context, template: template),
          onLongPress: () => _showFavoriteActions(context, template),
        );
      },
    );
  }
}

/// Pushes the favorite form (create when [template] is null) and reloads the
/// list when it pops with a success result.
Future<void> _openFavoriteForm(
  BuildContext context, {
  TxTemplate? template,
}) async {
  final cubit = context.read<FavoritesListCubit>();
  final saved = await context.push<bool>(
    AppRoute.favoriteForm,
    extra: template,
  );
  if (saved ?? false) await cubit.load();
}

enum _FavoriteAction { edit, delete }

/// Long-press actions: edit / delete (delete goes through a confirm sheet).
Future<void> _showFavoriteActions(
  BuildContext context,
  TxTemplate template,
) async {
  final cubit = context.read<FavoritesListCubit>();
  final s = Strings.of(context)!;
  final action = await showModalBottomSheet<_FavoriteAction>(
    context: context,
    builder: (sheetContext) => AppBottomSheet(
      title: template.label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Iconsax.edit),
            title: Text(s.edit),
            onTap: () => Navigator.of(sheetContext).pop(_FavoriteAction.edit),
          ),
          ListTile(
            leading: Icon(Iconsax.trash, color: context.colors.critical),
            title: Text(
              s.delete,
              style: TextStyle(color: context.colors.critical),
            ),
            onTap: () => Navigator.of(sheetContext).pop(_FavoriteAction.delete),
          ),
        ],
      ),
    ),
  );
  if (action == null || !context.mounted) return;

  switch (action) {
    case _FavoriteAction.edit:
      await _openFavoriteForm(context, template: template);
    case _FavoriteAction.delete:
      final confirmed = await ConfirmSheet.show(
        context,
        title: s.delete,
        message: s.favoriteDeleteConfirm,
        confirmLabel: s.delete,
        cancelLabel: s.cancel,
        destructive: true,
      );
      if (!confirmed || template.id == null) return;
      await cubit.delete(template.id!);
  }
}
