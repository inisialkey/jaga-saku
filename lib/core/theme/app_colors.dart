import 'package:flutter/material.dart';

/// Custom theme extension carrying the app's semantic color palette.
///
/// Registered via `ThemeData.extensions` in [themeLight] / [themeDark] and read
/// in widgets with `Theme.of(context).extension<AppColors>()`.
class AppColors extends ThemeExtension<AppColors> {
  final Color? background;
  final Color? banner;
  final Color? card;
  final Color? buttonText;
  final Color? subtitle;
  final Color? shadow;
  final Color? green;
  final Color? roseWater;
  final Color? flamingo;
  final Color? pink;
  final Color? mauve;
  final Color? maroon;
  final Color? peach;
  final Color? yellow;
  final Color? teal;
  final Color? sky;
  final Color? sapphire;
  final Color? blue;
  final Color? lavender;
  final Color? red;
  final Color? textOnGradient;

  const AppColors({
    this.background,
    this.banner,
    this.card,
    this.buttonText,
    this.subtitle,
    this.shadow,
    this.green,
    this.roseWater,
    this.flamingo,
    this.pink,
    this.mauve,
    this.maroon,
    this.peach,
    this.yellow,
    this.teal,
    this.sapphire,
    this.sky,
    this.blue,
    this.lavender,
    this.red,
    this.textOnGradient,
  });

  @override
  ThemeExtension<AppColors> copyWith({
    Color? background,
    Color? banner,
    Color? card,
    Color? buttonText,
    Color? subtitle,
    Color? shadow,
    Color? green,
    Color? roseWater,
    Color? flamingo,
    Color? pink,
    Color? mauve,
    Color? maroon,
    Color? peach,
    Color? yellow,
    Color? teal,
    Color? sky,
    Color? sapphire,
    Color? blue,
    Color? lavender,
    Color? red,
    Color? textOnGradient,
  }) => AppColors(
    background: background ?? this.background,
    banner: banner ?? this.banner,
    card: card ?? this.card,
    buttonText: buttonText ?? this.buttonText,
    subtitle: subtitle ?? this.subtitle,
    shadow: shadow ?? this.shadow,
    green: green ?? this.green,
    roseWater: roseWater ?? this.roseWater,
    flamingo: flamingo ?? this.flamingo,
    pink: pink ?? this.pink,
    mauve: mauve ?? this.mauve,
    maroon: maroon ?? this.maroon,
    peach: peach ?? this.peach,
    yellow: yellow ?? this.yellow,
    teal: teal ?? this.teal,
    sky: sky ?? this.sky,
    sapphire: sapphire ?? this.sapphire,
    blue: blue ?? this.blue,
    lavender: lavender ?? this.lavender,
    red: red ?? this.red,
    textOnGradient: textOnGradient ?? this.textOnGradient,
  );

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      banner: Color.lerp(banner, other.banner, t),
      background: Color.lerp(background, other.background, t),
      card: Color.lerp(card, other.card, t),
      buttonText: Color.lerp(buttonText, other.buttonText, t),
      subtitle: Color.lerp(subtitle, other.subtitle, t),
      shadow: Color.lerp(shadow, other.shadow, t),
      green: Color.lerp(green, other.green, t),
      roseWater: Color.lerp(roseWater, other.roseWater, t),
      flamingo: Color.lerp(flamingo, other.flamingo, t),
      pink: Color.lerp(pink, other.pink, t),
      mauve: Color.lerp(mauve, other.mauve, t),
      maroon: Color.lerp(maroon, other.maroon, t),
      peach: Color.lerp(peach, other.peach, t),
      yellow: Color.lerp(yellow, other.yellow, t),
      teal: Color.lerp(teal, other.teal, t),
      sapphire: Color.lerp(sapphire, other.sapphire, t),
      blue: Color.lerp(blue, other.blue, t),
      lavender: Color.lerp(lavender, other.lavender, t),
      sky: Color.lerp(sky, other.sky, t),
      red: Color.lerp(red, other.red, t),
      textOnGradient: Color.lerp(textOnGradient, other.textOnGradient, t),
    );
  }
}
