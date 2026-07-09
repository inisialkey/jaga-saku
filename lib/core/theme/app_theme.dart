import 'package:flutter/material.dart';
import 'package:jaga_saku/core/resources/dimens.dart';
import 'package:jaga_saku/core/theme/app_colors.dart';
import 'package:jaga_saku/core/theme/app_palette.dart';
import 'package:jaga_saku/core/theme/text_theme.dart';

/// App-wide [ThemeData] for light and dark modes (style guide §20–21).
/// Default is light; dark keeps calm, non-pure-black surfaces.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
    brightness: Brightness.light,
    background: AppColors.background,
    surface: AppColors.surface,
    textPrimary: AppColors.textPrimary,
    border: AppColors.border,
    palette: AppPalette.light,
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    background: AppColors.backgroundDark,
    surface: AppColors.surfaceDark,
    textPrimary: AppColors.textPrimaryDark,
    border: AppColors.borderDark,
    palette: AppPalette.dark,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color textPrimary,
    required Color border,
    required AppPalette palette,
  }) {
    final isDark = brightness == Brightness.dark;
    final textTheme = AppTextTheme.build(textPrimary);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTextTheme.fontFamily,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      primaryColor: AppColors.primary,
      disabledColor: AppColors.disabled,
      splashColor: AppColors.primary.withValues(alpha: 0.08),
      highlightColor: AppColors.primary.withValues(alpha: 0.04),
      colorScheme:
          (isDark ? const ColorScheme.dark() : const ColorScheme.light())
              .copyWith(
                brightness: brightness,
                primary: AppColors.primary,
                onPrimary: AppColors.white,
                surface: surface,
                onSurface: textPrimary,
                error: AppColors.critical,
              ),
      textTheme: textTheme,
      dividerColor: border,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.bottomSheet),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      extensions: <ThemeExtension<dynamic>>[palette],
    );
  }
}
