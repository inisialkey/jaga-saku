import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// A compact top toast pill: a semantic [bgColor] background with a leading
/// [icon] and the [message]. Built on the design tokens (AppSpacing / AppRadius)
/// — never `flutter_screenutil` (dimens.dart §8/§9: the 8-point scale is
/// device-independent). Callers (`String.toToast*` in `ext/string.dart`) pass a
/// text-safe dark [bgColor] so white [textColor] clears WCAG AA.
class Toast extends StatelessWidget {
  final IconData? icon;
  final Color? bgColor;
  final Color? textColor;
  final String? message;

  const Toast({
    super.key,
    this.icon,
    this.bgColor,
    this.message,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.lg,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                message ?? '',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: textColor),
                textAlign: TextAlign.start,
                maxLines: 5,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
