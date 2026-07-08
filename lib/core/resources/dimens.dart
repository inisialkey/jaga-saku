import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimens {
  Dimens._();

  // Font sizes (ScreenUtil `.sp`). Exposed as getters so they recompute
  // against the current ScreenUtil config on every access instead of being
  // frozen at first class-load (before ScreenUtil.init has run).
  static double get displayLarge => 96.sp;
  static double get displayMedium => 60.sp;
  static double get displaySmall => 48.sp;
  static double get headlineMedium => 34.sp;
  static double get headlineSmall => 24.sp;
  static double get titleLarge => 20.sp;
  static double get bodyLarge => 16.sp;
  static double get bodyMedium => 14.sp;
  static double get titleMedium => 18.sp;
  static double get titleSmall => 14.sp;
  static double get labelLarge => 16.sp;
  static double get bodySmall => 12.sp;
  static double get labelSmall => 10.sp;

  // Spacing (ScreenUtil `.w`). Getters for the same reason as above.
  static const double zero = 0;
  static double get space2 => 2.w;
  static double get space3 => 3.w;
  static double get space4 => 4.w;
  static double get space5 => 5.w;
  static double get space6 => 6.w;
  static double get space8 => 8.w;
  static double get space10 => 10.w;
  static double get space12 => 12.w;
  static double get space14 => 14.w;
  static double get space16 => 16.w;
  static double get space24 => 24.w;
  static double get space20 => 20.w;
  static double get space28 => 28.w;
  static double get space34 => 34.w;
  static double get space30 => 30.w;
  static double get space36 => 36.w;
  static double get space40 => 40.w;
  static double get space42 => 42.w;
  static double get space46 => 46.w;
  static double get space48 => 48.w;
  static double get space50 => 50.w;
  static double get space52 => 52.w;
  static double get space55 => 55.w;
  static double get space60 => 60.w;
  static double get space62 => 62.w;
  static double get space64 => 64.w;
  static double get space358 => 358.w;
  static double get space105 => 105.w;
  static double get space173 => 173.w;
  static double get space120 => 120.w;
  static double get space130 => 130.w;
  static double get space160 => 160.w;
  static double get space260 => 260.w;
  static double get space280 => 280.w;

  static double get selectedIndicatorW => 43.w;
  static double get selectedIndicatorSmallW => 28.w;
  static double get heightAppbarHome => 65.w;
  static double get tab => 38.w;
  static double get menu => 72.w;
  static double get menuContainer => 250.w;
  static double get carousel => 167.w;
  static double get newsHeight => 185.w;
  static double get textField => 50.w;
  static double get logo => 80.w;

  static double get header => 200.w;
  static double get minLabel => 116.w;
  static double get bottomBar => 80.w;
  static double get profilePicture => 86.w;
  static double get birthdayCalendar => 120.w;

  static double get buttonH => 40.w;
  static double get imageW => 110.w;

  static double get bottomsheetPicker => 200.w;

  static const double cornerRadius = 30;
  static const double cornerRadiusForm = 12;
  static const double cornerRadiusBottomSheet = 30;
}
