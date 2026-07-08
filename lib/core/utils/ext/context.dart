import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

extension ContextExtensions on BuildContext {
  /// Shorthand for the app's [AppColors] theme extension.
  ///
  /// Use `context.colors.background` instead of
  /// `Theme.of(context).extension<AppColors>()!.background`.
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

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
                color: c.colors.background,
                borderRadius: BorderRadius.circular(Dimens.cornerRadius),
              ),
              margin: EdgeInsets.symmetric(horizontal: Dimens.space30),
              padding: EdgeInsets.all(Dimens.space24),
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
