import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';

/// Bottom sheet listing categories (grouped parent → child, mirroring the M1
/// list), returning the chosen [Category] (or `null` if dismissed). [categories]
/// is expected to already be filtered to one [CategoryType] and non-archived.
class CategoryPickerSheet extends StatelessWidget {
  const CategoryPickerSheet({
    required this.title,
    required this.categories,
    super.key,
    this.selectedId,
  });

  final String title;
  final List<Category> categories;
  final int? selectedId;

  static Future<Category?> show(
    BuildContext context, {
    required String title,
    required List<Category> categories,
    int? selectedId,
  }) => showModalBottomSheet<Category>(
    context: context,
    builder: (_) => CategoryPickerSheet(
      title: title,
      categories: categories,
      selectedId: selectedId,
    ),
  );

  /// Flattens [categories] into display order: each top-level parent followed by
  /// its children (indented); any child whose parent is absent is appended flat.
  List<({Category category, bool isChild})> _ordered() {
    final rows = <({Category category, bool isChild})>[];
    final shown = <int?>{};
    for (final parent in categories.where((c) => c.parentId == null)) {
      rows.add((category: parent, isChild: false));
      shown.add(parent.id);
      for (final child in categories.where((c) => c.parentId == parent.id)) {
        rows.add((category: child, isChild: true));
        shown.add(child.id);
      }
    }
    for (final orphan in categories.where((c) => !shown.contains(c.id))) {
      rows.add((category: orphan, isChild: false));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = _ordered();
    return AppBottomSheet(
      title: title,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: rows.length,
        itemBuilder: (context, index) {
          final (:category, :isChild) = rows[index];
          final selected = category.id != null && category.id == selectedId;
          return ListTile(
            contentPadding: EdgeInsets.only(left: isChild ? AppSpacing.xl : 0),
            leading: CategoryIconAvatar(
              icon: category.icon,
              color: category.color,
              size: isChild ? 32 : 40,
            ),
            title: Text(category.name, style: theme.textTheme.bodyLarge),
            trailing: selected
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                  )
                : null,
            onTap: () => Navigator.of(context).pop(category),
          );
        },
      ),
    );
  }
}
