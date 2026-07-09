import 'package:flutter/material.dart';

/// Plus Jakarta Sans type scale (style guide §6). The family itself is applied
/// via `ThemeData.fontFamily`; this only defines size / weight / color per slot.
class AppTextTheme {
  AppTextTheme._();

  /// The bundled variable font family (see `pubspec.yaml` fonts).
  static const String fontFamily = 'Plus Jakarta Sans';

  static TextTheme build(Color primary) => TextTheme(
    // Display — total balance / major amounts
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.25,
      color: primary,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: primary,
    ),
    // Headings
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700, // H1 page title
      color: primary,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600, // H2 section title
      color: primary,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600, // H3 card title
      color: primary,
    ),
    // Body
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: primary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: primary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: primary,
    ),
    // Labels
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600, // button text
      color: primary,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500, // chip / status badge
      color: primary,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500, // tiny label
      color: primary,
    ),
  );
}
