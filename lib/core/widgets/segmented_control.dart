import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// A single option in a [SegmentedControl].
class SegmentOption<T> {
  const SegmentOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Segmented control (style guide §13.9): 44h, radius 14, surfaceSoft track,
/// selected pill in green with white text.
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<SegmentOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 44,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.colors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      // stretch so each InkWell fills the full 44px track height (a real 44px
      // touch target); the 4px pill inset lives INSIDE each cell (below) so the
      // whole 44px stays tappable instead of only the ~36px pill.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final option in options)
            Expanded(
              child: Semantics(
                button: true,
                selected: option.value == selected,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onChanged(option.value),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      child: AnimatedContainer(
                        duration: AppDurations.fast,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: option.value == selected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          option.label,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: option.value == selected
                                ? AppColors.white
                                : context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
