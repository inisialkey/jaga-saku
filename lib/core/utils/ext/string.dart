import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:oktoast/oktoast.dart';

extension StringExtension on String {
  //https://github.com/ponnamkarthik/FlutterToast/issues/262
  //coverage:ignore-start
  void toToastError(BuildContext context) {
    try {
      final message = isEmpty ? 'error' : this;

      //dismiss before show toast
      dismissAllToast(showAnim: true);

      showToastWidget(
        Toast(
          bgColor: context.colors.critical,
          icon: Icons.error,
          message: message,
          textColor: Colors.white,
        ),
        dismissOtherToast: true,
        position: ToastPosition.top,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      log.e('error $e');
    }
  }

  void toToastSuccess(BuildContext context) {
    try {
      final message = isEmpty ? 'success' : this;

      //dismiss before show toast
      dismissAllToast(showAnim: true);

      // showToast(msg)
      showToastWidget(
        Toast(
          // Text-safe dark green (5.0:1 vs white) — vivid success fails AA.
          bgColor: AppColors.successDark,
          icon: Icons.check_circle,
          message: message,
          textColor: Colors.white,
        ),
        dismissOtherToast: true,
        position: ToastPosition.top,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      log.e('$e');
    }
  }

  void toToastLoading(BuildContext context) {
    try {
      final message = isEmpty ? 'loading' : this;
      //dismiss before show toast
      dismissAllToast(showAnim: true);

      showToastWidget(
        Toast(
          // Text-safe dark sky (5.9:1 vs white) — vivid info fails AA.
          bgColor: AppColors.infoDark,
          icon: Icons.info,
          message: message,
          textColor: Colors.white,
        ),
        dismissOtherToast: true,
        position: ToastPosition.top,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      log.e('$e');
    }
  }

  //coverage:ignore-end
}
