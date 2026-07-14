import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/pages/form/category_form_page.dart';
import 'package:jaga_saku/features/categories/pages/list/category_list_cubit.dart';
import 'package:jaga_saku/features/categories/pages/widgets/category_row.dart';

/// Categories list: expense/income tabs + a parent -> child tree with full CRUD,
/// archive and top-level reorder. The cubit is provided at the route.
class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocBuilder<CategoryListCubit, CategoryListState>(
      builder: (context, state) {
        final type = _typeOf(state);
        final showArchived = state is CategoryListLoaded && state.showArchived;
        return AppScaffold(
          appBar: AppBar(
            title: Text(s.categories),
            actions: [
              if (state is CategoryListLoaded)
                IconButton(
                  tooltip: showArchived ? s.hideArchived : s.showArchived,
                  icon: Icon(showArchived ? Iconsax.eye : Iconsax.eye_slash),
                  onPressed: () =>
                      context.read<CategoryListCubit>().toggleArchived(),
                ),
              IconButton(
                tooltip: s.addCategory,
                icon: const Icon(Iconsax.add),
                onPressed: () => _openCategoryForm(context, presetType: type),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: SegmentedControl<CategoryType>(
                  selected: type,
                  onChanged: (t) =>
                      context.read<CategoryListCubit>().selectType(t),
                  options: [
                    SegmentOption(
                      value: CategoryType.expense,
                      label: s.expense,
                    ),
                    SegmentOption(value: CategoryType.income, label: s.income),
                  ],
                ),
              ),
              Expanded(
                child: switch (state) {
                  CategoryListInitial() ||
                  CategoryListLoading() => const ListSkeleton(),
                  CategoryListError(:final failure) => ErrorStateView(
                    title: s.errorLoadTitle,
                    message: failure.localize(context),
                    retryLabel: s.retry,
                    onRetry: () => context.read<CategoryListCubit>().load(),
                  ),
                  CategoryListLoaded() => _CategoryTree(state: state),
                },
              ),
            ],
          ),
        );
      },
    );
  }

  CategoryType _typeOf(CategoryListState state) => switch (state) {
    CategoryListLoading(:final type) => type,
    CategoryListLoaded(:final type) => type,
    CategoryListError(:final type) => type,
    CategoryListInitial() => CategoryType.expense,
  };
}

class _CategoryTree extends StatelessWidget {
  const _CategoryTree({required this.state});

  final CategoryListLoaded state;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final items = state.items;
    bool visible(Category c) => state.showArchived || !c.archived;
    final topLevel = items
        .where((c) => c.parentId == null && visible(c))
        .toList();

    if (topLevel.isEmpty) {
      return EmptyStateView(
        icon: Iconsax.category_2,
        title: s.emptyCategoriesTitle,
        message: s.emptyCategoriesMessage,
        actionLabel: s.addCategory,
        onAction: () => _openCategoryForm(context, presetType: state.type),
      );
    }

    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      itemCount: topLevel.length,
      onReorderItem: (oldIndex, newIndex) =>
          context.read<CategoryListCubit>().reorder(oldIndex, newIndex),
      itemBuilder: (context, index) {
        final parent = topLevel[index];
        final children = items
            .where((c) => c.parentId == parent.id && visible(c))
            .toList();
        final hasChildren = items.any((c) => c.parentId == parent.id);
        return Column(
          key: ValueKey(parent.id),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CategoryRow(
              category: parent,
              onTap: () => _openCategoryForm(context, category: parent),
              onLongPress: () => _showCategoryActions(
                context,
                parent,
                hasChildren: hasChildren,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: s.addCategory,
                    icon: Icon(
                      Iconsax.add,
                      color: context.colors.textSecondary,
                    ),
                    onPressed: () => _openCategoryForm(
                      context,
                      presetType: state.type,
                      presetParentId: parent.id,
                    ),
                  ),
                  ReorderableDragStartListener(
                    index: index,
                    child: Semantics(
                      label: s.reorder,
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: Icon(
                            Icons.drag_indicator_rounded,
                            color: context.colors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            for (final child in children)
              CategoryRow(
                category: child,
                isChild: true,
                onTap: () => _openCategoryForm(context, category: child),
                onLongPress: () =>
                    _showCategoryActions(context, child, hasChildren: false),
              ),
          ],
        );
      },
    );
  }
}

/// Pushes the category form and reloads on a successful save.
Future<void> _openCategoryForm(
  BuildContext context, {
  Category? category,
  CategoryType? presetType,
  int? presetParentId,
}) async {
  final cubit = context.read<CategoryListCubit>();
  final saved = await context.push<bool>(
    AppRoute.categoryForm,
    extra: CategoryFormArgs(
      category: category,
      presetType: presetType,
      presetParentId: presetParentId,
    ),
  );
  if (saved ?? false) await cubit.load();
}

enum _CategoryAction { edit, archive, delete }

Future<void> _showCategoryActions(
  BuildContext context,
  Category category, {
  required bool hasChildren,
}) async {
  final cubit = context.read<CategoryListCubit>();
  final s = Strings.of(context)!;
  final action = await showModalBottomSheet<_CategoryAction>(
    context: context,
    builder: (sheetContext) => AppBottomSheet(
      title: category.name,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Iconsax.edit),
            title: Text(s.edit),
            onTap: () => Navigator.of(sheetContext).pop(_CategoryAction.edit),
          ),
          ListTile(
            leading: Icon(
              category.archived ? Iconsax.archive_tick : Iconsax.archive,
            ),
            title: Text(category.archived ? s.unarchive : s.archive),
            onTap: () =>
                Navigator.of(sheetContext).pop(_CategoryAction.archive),
          ),
          ListTile(
            leading: Icon(Iconsax.trash, color: context.colors.critical),
            title: Text(
              s.delete,
              style: TextStyle(color: context.colors.critical),
            ),
            onTap: () => Navigator.of(sheetContext).pop(_CategoryAction.delete),
          ),
        ],
      ),
    ),
  );
  if (action == null || !context.mounted) return;

  switch (action) {
    case _CategoryAction.edit:
      await _openCategoryForm(context, category: category);
    case _CategoryAction.archive:
      await cubit.archive(category.id!, archived: !category.archived);
    case _CategoryAction.delete:
      final confirmed = await ConfirmSheet.show(
        context,
        title: s.delete,
        message: hasChildren
            ? s.deleteCategoryParentConfirm
            : s.deleteCategoryConfirm,
        confirmLabel: s.delete,
        cancelLabel: s.cancel,
        destructive: true,
      );
      if (!confirmed) return;
      final outcome = await cubit.delete(category.id!);
      if (outcome == DeleteOutcome.archivedFallback && context.mounted) {
        s.categoryArchivedFallback.toToastSuccess(context);
      }
  }
}
