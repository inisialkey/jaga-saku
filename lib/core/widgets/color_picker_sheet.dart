import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Bottom-sheet swatch grid over [CategoryColors.swatches]; resolves to the
/// selected ARGB `int` (or `null` if dismissed).
class ColorPickerSheet extends StatelessWidget {
  const ColorPickerSheet({required this.title, super.key, this.selected});

  final String title;
  final int? selected;

  static Future<int?> show(
    BuildContext context, {
    required String title,
    int? selected,
  }) => showModalBottomSheet<int>(
    context: context,
    builder: (_) => ColorPickerSheet(title: title, selected: selected),
  );

  @override
  Widget build(BuildContext context) => AppBottomSheet(
    title: title,
    child: GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: AppSpacing.lg,
        crossAxisSpacing: AppSpacing.lg,
      ),
      itemCount: CategoryColors.swatches.length,
      itemBuilder: (context, index) {
        final argb = CategoryColors.swatches[index];
        final color = Color(argb);
        final isSelected = argb == selected;
        return Semantics(
          button: true,
          selected: isSelected,
          child: InkResponse(
            onTap: () => Navigator.of(context).pop(argb),
            radius: 28,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                // High-contrast dark ring (was faint border-gray, invisible on
                // many swatches) so the selection reads on light/medium colors;
                // the haloed check carries it on dark swatches.
                border: isSelected
                    ? Border.all(color: AppColors.textPrimary, width: 3)
                    : null,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.white,
                      // Dark halo so the white check stays visible on light
                      // swatches.
                      shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                    )
                  : null,
            ),
          ),
        );
      },
    ),
  );
}
