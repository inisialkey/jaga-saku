import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.centerTitle = true,
    this.actions,
    this.onBack,
  });

  final String? title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final bool centerTitle;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    elevation: 0,
    scrolledUnderElevation: 0.2,
    title:
        titleWidget ??
        (title != null
            ? Text(
                title!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Palette.iconDark
                      : Palette.backgroundDark,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null),
    centerTitle: centerTitle,
    actions: actions,
    automaticallyImplyLeading: onBack != null,
    leading: onBack != null
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Palette.iconDark
                  : Palette.backgroundDark,
            ),
            onPressed: onBack,
          )
        : null,
    iconTheme: IconThemeData(
      color: Theme.of(context).brightness == Brightness.dark
          ? Palette.iconDark
          : Palette.icon,
    ),
  );
}
