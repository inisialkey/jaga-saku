import 'package:flutter/material.dart';

/// Raw brand + neutral + semantic color constants (style guide §4).
///
/// These are the source of truth for the theme. Widgets should NOT read these
/// directly for semantic finance colors — go through the [AppPalette] theme
/// extension (`context.colors`) so light/dark resolves automatically. Static
/// constants here are for building [ThemeData] and for the fixed brand green.
class AppColors {
  AppColors._();

  // ── Primary (brand green) ────────────────────────────────────────────────
  static const Color primary = Color(0xFF16A34A);
  static const Color primaryDark = Color(0xFF15803D);
  static const Color primaryLight = Color(0xFFDCFCE7);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color income = Color(0xFF22C55E);
  static const Color expense = Color(0xFFEF4444);
  static const Color transfer = Color(0xFF3B82F6);
  static const Color warning = Color(0xFFF59E0B);
  static const Color critical = Color(0xFFDC2626);
  static const Color info = Color(0xFF0EA5E9);
  static const Color success = Color(0xFF16A34A);

  // ── Neutrals — light ─────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color disabled = Color(0xFFCBD5E1);

  // ── Neutrals — dark (style guide §21: never pure black) ──────────────────
  static const Color backgroundDark = Color(0xFF020617);
  static const Color surfaceDark = Color(0xFF0F172A);
  static const Color surfaceSoftDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textTertiaryDark = Color(0xFF94A3B8);
  static const Color disabledDark = Color(0xFF475569);

  // ── Utility ──────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);

  /// Shadow tint (style guide §10 — #0F172A at low opacity).
  static const Color shadow = Color(0xFF0F172A);
}
