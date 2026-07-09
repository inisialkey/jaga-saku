import 'package:flutter/material.dart';
import 'package:jaga_saku/core/theme/app_colors.dart';

/// Semantic color palette exposed as a [ThemeExtension] (style guide §25).
///
/// Read via `context.colors` (see `ContextExtensions.colors`) so finance
/// semantics resolve to the right value for the active brightness. Never
/// hardcode these colors in widgets.
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.income,
    required this.expense,
    required this.transfer,
    required this.warning,
    required this.critical,
    required this.success,
    required this.info,
    required this.surfaceSoft,
    required this.border,
    required this.textSecondary,
    required this.textTertiary,
  });

  final Color income;
  final Color expense;
  final Color transfer;
  final Color warning;
  final Color critical;
  final Color success;
  final Color info;
  final Color surfaceSoft;
  final Color border;
  final Color textSecondary;
  final Color textTertiary;

  /// Light-mode semantic palette.
  static const AppPalette light = AppPalette(
    income: AppColors.income,
    expense: AppColors.expense,
    transfer: AppColors.transfer,
    warning: AppColors.warning,
    critical: AppColors.critical,
    success: AppColors.success,
    info: AppColors.info,
    surfaceSoft: AppColors.surfaceSoft,
    border: AppColors.border,
    textSecondary: AppColors.textSecondary,
    textTertiary: AppColors.textTertiary,
  );

  /// Dark-mode semantic palette. Semantic hues stay vivid enough to read on
  /// dark surfaces; only the neutral tokens shift.
  static const AppPalette dark = AppPalette(
    income: AppColors.income,
    expense: AppColors.expense,
    transfer: AppColors.transfer,
    warning: AppColors.warning,
    critical: AppColors.critical,
    success: AppColors.success,
    info: AppColors.info,
    surfaceSoft: AppColors.surfaceSoftDark,
    border: AppColors.borderDark,
    textSecondary: AppColors.textSecondaryDark,
    textTertiary: AppColors.textTertiaryDark,
  );

  @override
  AppPalette copyWith({
    Color? income,
    Color? expense,
    Color? transfer,
    Color? warning,
    Color? critical,
    Color? success,
    Color? info,
    Color? surfaceSoft,
    Color? border,
    Color? textSecondary,
    Color? textTertiary,
  }) => AppPalette(
    income: income ?? this.income,
    expense: expense ?? this.expense,
    transfer: transfer ?? this.transfer,
    warning: warning ?? this.warning,
    critical: critical ?? this.critical,
    success: success ?? this.success,
    info: info ?? this.info,
    surfaceSoft: surfaceSoft ?? this.surfaceSoft,
    border: border ?? this.border,
    textSecondary: textSecondary ?? this.textSecondary,
    textTertiary: textTertiary ?? this.textTertiary,
  );

  @override
  AppPalette lerp(covariant AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      transfer: Color.lerp(transfer, other.transfer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      critical: Color.lerp(critical, other.critical, t)!,
      success: Color.lerp(success, other.success, t)!,
      info: Color.lerp(info, other.info, t)!,
      surfaceSoft: Color.lerp(surfaceSoft, other.surfaceSoft, t)!,
      border: Color.lerp(border, other.border, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
    );
  }
}
