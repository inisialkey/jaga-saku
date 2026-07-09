import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

extension ContextExtensions on BuildContext {
  /// Shorthand for the app's [AppPalette] theme extension.
  ///
  /// Use `context.colors.income` instead of
  /// `Theme.of(context).extension<AppPalette>()!.income`.
  AppPalette get colors => Theme.of(this).extension<AppPalette>()!;

  double widthInPercent(double percent) {
    final toDouble = percent / 100;

    return MediaQuery.of(this).size.width * toDouble;
  }

  double heightInPercent(double percent) {
    final toDouble = percent / 100;

    return MediaQuery.of(this).size.height * toDouble;
  }

  //Start Loading Dialog
  static BuildContext? ctx;

  Future<void> show() => showDialog(
    context: this,
    barrierDismissible: false,
    builder: (c) {
      ctx = c;

      return PopScope(
        canPop: false,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(c).cardColor,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: const Loading(),
            ),
          ),
        ),
      );
    },
  );

  void dismiss() {
    final c = ctx;
    if (c != null && c.mounted) {
      Navigator.pop(c);
    }
    ctx = null;
  }
}
