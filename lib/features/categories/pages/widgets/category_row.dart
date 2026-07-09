import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';

/// A category row for the hierarchy list: icon avatar + name, indented when it
/// is a child. Dumb widget — tap/long-press and any [trailing] affordance
/// (add-child button, drag handle) are supplied by the list page.
class CategoryRow extends StatelessWidget {
  const CategoryRow({
    required this.category,
    super.key,
    this.isChild = false,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  final Category category;
  final bool isChild;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Opacity(
        opacity: category.archived ? 0.5 : 1,
        child: Padding(
          padding: EdgeInsets.only(
            left: isChild ? AppSpacing.xxxl : 0,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          child: Row(
            children: [
              CategoryIconAvatar(
                icon: category.icon,
                color: category.color,
                size: isChild ? 32 : 40,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
