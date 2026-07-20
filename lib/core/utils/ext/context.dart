import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

extension ContextExtensions on BuildContext {
  /// Shorthand for the app's [AppPalette] theme extension.
  ///
  /// Use `context.colors.income` instead of
  /// `Theme.of(context).extension<AppPalette>()!.income`.
  AppPalette get colors => Theme.of(this).extension<AppPalette>()!;
}
