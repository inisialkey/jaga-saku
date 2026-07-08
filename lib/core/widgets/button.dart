import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double? width;
  final Color? color;
  final Color? titleColor;
  final double? fontSize;
  final Color? splashColor;

  const Button({
    required this.title,
    required this.onPressed,
    super.key,
    this.width,
    this.color,
    this.titleColor,
    this.fontSize,
    this.splashColor,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            color ??
            (Theme.of(context).brightness == Brightness.dark
                ? Palette.buttonDark
                : Palette.primary),
        foregroundColor: context.colors.buttonText,
        disabledBackgroundColor: context.colors.buttonText?.withValues(
          alpha: 0.5,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.space16,
          vertical: Dimens.space12,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Dimens.cornerRadius)),
        ),
      ),
      child: Text(
        title,
        maxLines: 1,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color:
              titleColor ??
              (Theme.of(context).brightness == Brightness.dark
                  ? Palette.text
                  : Colors.white),
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
