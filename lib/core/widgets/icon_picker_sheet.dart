import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Bottom-sheet grid over [AppIcons.pickerKeys]; resolves to the selected
/// catalog key (or `null` if dismissed).
class IconPickerSheet extends StatelessWidget {
  const IconPickerSheet({required this.title, super.key, this.selected});

  final String title;
  final String? selected;

  static Future<String?> show(
    BuildContext context, {
    required String title,
    String? selected,
  }) => showModalBottomSheet<String>(
    context: context,
    builder: (_) => IconPickerSheet(title: title, selected: selected),
  );

  @override
  Widget build(BuildContext context) {
    final keys = AppIcons.pickerKeys;
    return AppBottomSheet(
      title: title,
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final key = keys[index];
          final isSelected = key == selected;
          return InkWell(
            onTap: () => Navigator.of(context).pop(key),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryLight
                    : context.colors.surfaceSoft,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: isSelected
                    ? Border.all(color: AppColors.primary)
                    : null,
              ),
              child: Icon(
                AppIcons.resolve(key),
                color: isSelected
                    ? AppColors.primaryDark
                    : context.colors.textSecondary,
              ),
            ),
          );
        },
      ),
    );
  }
}
