// Design tokens (style guide §8, §9, §24). Plain constants — the 8-point
// spacing / radius scale is device-independent; do not run these through
// ScreenUtil.

/// 8-point spacing scale (style guide §8).
class AppSpacing {
  AppSpacing._();

  static const double xs = 4; // icon gap, tiny label
  static const double sm = 8; // item inner gap
  static const double md = 12; // tile gap
  static const double lg = 16; // page / card padding
  static const double xl = 20; // section gap
  static const double xxl = 24; // card group gap
  static const double xxxl = 32; // large section gap
}

/// Corner radius scale (style guide §9).
class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20; // card
  static const double bottomSheet = 24;
  static const double pill = 999;
}

/// Standard animation durations (style guide §24).
class AppDurations {
  AppDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
}
