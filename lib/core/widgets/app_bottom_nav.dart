import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// One destination in the [AppBottomNav].
class BottomNavItem {
  const BottomNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Bottom navigation bar (style guide §18): height 72, surface background,
/// top border, selected = primary green, unselected = text tertiary. Leaves a
/// gap in the middle for the center Add FAB (which is not a tab).
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<BottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    // items are laid out around a central gap: first half | gap | second half.
    final half = (items.length / 2).ceil();
    final left = items.sublist(0, half);
    final right = items.sublist(half);

    Widget cell(BottomNavItem item, int index) => Expanded(
      child: _NavCell(
        item: item,
        selected: index == currentIndex,
        onTap: () => onTap(index),
      ),
    );

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var i = 0; i < left.length; i++) cell(left[i], i),
            // Gap reserved for the center Add FAB.
            const SizedBox(width: 72),
            for (var i = 0; i < right.length; i++) cell(right[i], half + i),
          ],
        ),
      ),
    );
  }
}

class _NavCell extends StatelessWidget {
  const _NavCell({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final BottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : context.colors.textTertiary;
    return InkResponse(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
