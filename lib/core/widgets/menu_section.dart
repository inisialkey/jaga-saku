import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({
    required this.title,
    super.key,
    this.subtitle,
    this.subtitle2,
    this.onTap,
    this.showDivider = true,
    this.trailing,
    this.titleColor,
    this.trailingColor,
  });

  final String title;
  final Widget? subtitle;
  final Widget? subtitle2;
  final VoidCallback? onTap;
  final bool showDivider;
  final Widget? trailing;
  final Color? titleColor;
  final Color? trailingColor;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimens.space16,
            horizontal: Dimens.space8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: titleColor ?? Palette.primary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SpacerV(value: Dimens.space5),
                      subtitle!,
                    ],
                    if (subtitle2 != null) ...[
                      SpacerV(value: Dimens.space5),
                      subtitle2!,
                    ],
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right,
                    color: trailingColor ?? Palette.primary,
                  ),
            ],
          ),
        ),
      ),

      /// DIVIDER
      if (showDivider)
        Divider(height: 1, color: Palette.primary.withValues(alpha: 0.2)),
    ],
  );
}
