import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// A single option in a [ChoiceChipGroup].
class ChipOption<T> {
  const ChipOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Wrapping group of single-select pill chips (style guide §13.10): 36h,
/// radius 999, surfaceSoft default, primaryLight/primaryDark when selected.
class ChoiceChipGroup<T> extends StatelessWidget {
  const ChoiceChipGroup({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<ChipOption<T>> options;
  final T? selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final option in options)
          GestureDetector(
            onTap: () => onChanged(option.value),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: option.value == selected
                    ? AppColors.primaryLight
                    : context.colors.surfaceSoft,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                option.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: option.value == selected
                      ? AppColors.primaryDark
                      : context.colors.textSecondary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
