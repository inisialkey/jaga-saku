import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:oktoast/oktoast.dart';

extension StringExtension on String {
  bool isValidEmail() => RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  ).hasMatch(this);

  //https://github.com/ponnamkarthik/FlutterToast/issues/262
  //coverage:ignore-start
  void toToastError(BuildContext context, {bool isUnitTest = false}) {
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

  void toToastSuccess(BuildContext context, {bool isUnitTest = false}) {
    try {
      final message = isEmpty ? 'success' : this;

      //dismiss before show toast
      dismissAllToast(showAnim: true);

      // showToast(msg)
      showToastWidget(
        Toast(
          bgColor: context.colors.success,
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

  void toToastLoading(BuildContext context, {bool isUnitTest = false}) {
    try {
      final message = isEmpty ? 'loading' : this;
      //dismiss before show toast
      dismissAllToast(showAnim: true);

      showToastWidget(
        Toast(
          bgColor: context.colors.info,
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

  String toStringDateAlt({bool isShort = false, bool isToLocal = true}) {
    try {
      DateTime object;
      if (isToLocal) {
        object = DateTime.parse(this).toLocal();
      } else {
        object = DateTime.parse(this);
      }

      return DateFormat(
        "dd ${isShort ? "MMM" : "MMMM"} yyyy HH:mm",
        'id',
      ).format(object);
    } on FormatException catch (e) {
      log.e('Date parse error: $e');
      return '-';
    }
  }
}
