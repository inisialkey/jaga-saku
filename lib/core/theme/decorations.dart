import 'package:flutter/material.dart';
import 'package:jaga_saku/core/resources/dimens.dart';
import 'package:jaga_saku/core/resources/palette.dart';
import 'package:jaga_saku/core/theme/app_colors.dart';
import 'package:jaga_saku/core/utils/ext/context.dart';

/// Reusable [BoxDecoration] presets parameterized by the current [BuildContext]
/// so they can pick up theme-aware values (card color, shadow tint).
class BoxDecorations {
  BoxDecorations(this.context);

  final BuildContext context;

  BoxDecoration get button => BoxDecoration(
    color: Palette.primary,
    borderRadius: const BorderRadius.all(Radius.circular(Dimens.cornerRadius)),
    boxShadow: [BoxShadows(context).button],
  );

  BoxDecoration get card => BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: const BorderRadius.all(Radius.circular(Dimens.cornerRadius)),
    boxShadow: [BoxShadows(context).card],
  );
}

/// Reusable [BoxShadow] presets keyed off [AppColors.shadow] so that
/// elevation tint follows the active theme.
class BoxShadows {
  BoxShadows(this.context);

  final BuildContext context;

  BoxShadow get button => BoxShadow(
    color: context.colors.shadow!.withValues(alpha: 0.5),
    blurRadius: 16.0,
    spreadRadius: 1.0,
  );

  BoxShadow get card => BoxShadow(
    color: context.colors.shadow!.withValues(alpha: 0.5),
    blurRadius: 5.0,
    spreadRadius: 0.5,
  );

  BoxShadow get dialog => BoxShadow(
    color: context.colors.shadow!,
    offset: const Offset(0, -4),
    blurRadius: 16.0,
  );

  BoxShadow get dialogAlt => BoxShadow(
    color: context.colors.shadow!,
    offset: const Offset(0, 4),
    blurRadius: 16.0,
  );

  BoxShadow get buttonMenu =>
      BoxShadow(color: context.colors.shadow!, blurRadius: 4.0);
}
