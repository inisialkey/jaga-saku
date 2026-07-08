import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jaga_saku/core/core.dart';

class _NavItem {
  /// Resolved against [Strings] at build time so labels stay localized.
  final String Function(Strings) label;
  final String iconAsset;
  final String activeIconAsset;

  const _NavItem({
    required this.label,
    required this.iconAsset,
    required this.activeIconAsset,
  });
}

final _items = [
  _NavItem(
    label: _homeLabel,
    iconAsset: Images.icHome,
    activeIconAsset: Images.icHomeActive,
  ),
  _NavItem(
    label: _settingsLabel,
    iconAsset: Images.icProfile,
    activeIconAsset: Images.icProfile,
  ),
];

String _homeLabel(Strings s) => s.home;
String _settingsLabel(Strings s) => s.settings;

const _bgColor = Color(0xffE4F1FE);
const _bgColorDark = Color(0xff022145);
const _activeColor = Color(0xff38BDF8);
const _inactiveColor = Color(0xffA8A8A8);

class FloatingBottomNavBar extends StatelessWidget {
  const FloatingBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(
      bottom: Dimens.space24,
      left: Dimens.space16,
      right: Dimens.space16,
    ),
    decoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.dark
          ? _bgColorDark
          : _bgColor,
      borderRadius: BorderRadius.circular(32),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: List.generate(
            _items.length,
            (index) => Expanded(
              child: _NavBarItem(
                item: _items[index],
                isActive: index == currentIndex,
                onTap: () => onTap(index),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? _activeColor : _inactiveColor;
    final assetPath = isActive ? item.activeIconAsset : item.iconAsset;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            assetPath,
            width: 24.w,
            height: 24.w,
            color: color,
            colorBlendMode: BlendMode.srcIn,
          ),
          SpacerV(value: Dimens.space4),
          Text(
            item.label(Strings.of(context)!),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11.sp,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
