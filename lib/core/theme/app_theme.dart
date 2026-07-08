import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaga_saku/core/resources/dimens.dart';
import 'package:jaga_saku/core/resources/palette.dart';
import 'package:jaga_saku/core/theme/app_colors.dart';

/// Light theme
ThemeData themeLight(BuildContext context) => ThemeData(
  fontFamily: 'Inter',
  useMaterial3: true,
  primaryColor: Palette.primary,
  disabledColor: Palette.shadowDark,
  hintColor: Palette.text,
  cardColor: Palette.background,
  scaffoldBackgroundColor: Palette.background,
  colorScheme: const ColorScheme.light().copyWith(
    primary: Palette.primary,
    surface: Palette.background,
  ),
  textTheme: TextTheme(
    displayLarge: Theme.of(context).textTheme.displayLarge?.copyWith(
      fontSize: Dimens.displayLarge,
      color: Palette.text,
    ),
    displayMedium: Theme.of(context).textTheme.displayMedium?.copyWith(
      fontSize: Dimens.displayMedium,
      color: Palette.text,
    ),
    displaySmall: Theme.of(context).textTheme.displaySmall?.copyWith(
      fontSize: Dimens.displaySmall,
      color: Palette.text,
    ),
    headlineMedium: Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontSize: Dimens.headlineMedium,
      color: Palette.text,
    ),
    headlineSmall: Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontSize: Dimens.headlineSmall,
      color: Palette.text,
    ),
    titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
      fontSize: Dimens.titleLarge,
      color: Palette.text,
    ),
    titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
      fontSize: Dimens.titleMedium,
      color: Palette.text,
    ),
    titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
      fontSize: Dimens.titleSmall,
      color: Palette.text,
    ),
    bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: Dimens.bodyLarge,
      color: Palette.text,
    ),
    bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: Dimens.bodyMedium,
      color: Palette.text,
    ),
    bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
      fontSize: Dimens.bodySmall,
      color: Palette.text,
    ),
    labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(
      fontSize: Dimens.labelLarge,
      color: Palette.text,
    ),
    labelSmall: Theme.of(context).textTheme.labelSmall?.copyWith(
      fontSize: Dimens.labelSmall,
      letterSpacing: 0.25,
      color: Palette.text,
    ),
  ),
  appBarTheme: const AppBarTheme().copyWith(
    titleTextStyle: Theme.of(context).textTheme.bodyLarge,
    backgroundColor: Palette.background,
    iconTheme: const IconThemeData(color: Palette.icon),
    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ),
    surfaceTintColor: Palette.background,
    shadowColor: Palette.shadow,
  ),
  drawerTheme: const DrawerThemeData().copyWith(
    elevation: Dimens.zero,
    surfaceTintColor: Palette.background,
    backgroundColor: Palette.background,
  ),
  bottomSheetTheme: const BottomSheetThemeData().copyWith(
    backgroundColor: Palette.background,
    surfaceTintColor: Colors.transparent,
    elevation: Dimens.zero,
  ),
  dialogTheme: const DialogThemeData().copyWith(
    backgroundColor: Palette.background,
    surfaceTintColor: Colors.transparent,
    elevation: Dimens.zero,
  ),
  brightness: Brightness.light,
  iconTheme: const IconThemeData(color: Palette.icon),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  extensions: const <ThemeExtension<AppColors>>[
    AppColors(
      background: Palette.background,
      banner: Palette.banner,
      card: Palette.card,
      buttonText: Palette.text,
      subtitle: Palette.subtitleLight,
      shadow: Palette.shadow,
      textOnGradient: Palette.textOnGradient,
      green: Palette.greenLatte,
      roseWater: Palette.roseWaterLatte,
      flamingo: Palette.flamingoLatte,
      pink: Palette.pinkLatte,
      mauve: Palette.mauveLatte,
      maroon: Palette.maroonLatte,
      peach: Palette.peachLatte,
      yellow: Palette.yellowLatte,
      teal: Palette.tealLatte,
      sapphire: Palette.sapphireLatte,
      sky: Palette.skyLatte,
      blue: Palette.blueLatte,
      lavender: Palette.lavenderLatte,
      red: Palette.redLatte,
    ),
  ],
);

/// Dark theme
ThemeData themeDark(BuildContext context) => ThemeData(
  fontFamily: 'Inter',
  useMaterial3: true,
  primaryColor: Palette.primary,
  disabledColor: Palette.shadowDark,
  hintColor: Palette.textDark,
  cardColor: Palette.backgroundDark,
  scaffoldBackgroundColor: Palette.backgroundDark,
  colorScheme: const ColorScheme.dark().copyWith(primary: Palette.primary),
  textTheme: TextTheme(
    displayLarge: Theme.of(context).textTheme.displayLarge?.copyWith(
      fontSize: Dimens.displayLarge,
      color: Palette.textDark,
    ),
    displayMedium: Theme.of(context).textTheme.displayMedium?.copyWith(
      fontSize: Dimens.displayMedium,
      color: Palette.textDark,
    ),
    displaySmall: Theme.of(context).textTheme.displaySmall?.copyWith(
      fontSize: Dimens.displaySmall,
      color: Palette.textDark,
    ),
    headlineMedium: Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontSize: Dimens.headlineMedium,
      color: Palette.textDark,
    ),
    headlineSmall: Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontSize: Dimens.headlineSmall,
      color: Palette.textDark,
    ),
    titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
      fontSize: Dimens.titleLarge,
      color: Palette.textDark,
    ),
    titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
      fontSize: Dimens.titleMedium,
      color: Palette.textDark,
    ),
    titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
      fontSize: Dimens.titleSmall,
      color: Palette.textDark,
    ),
    bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: Dimens.bodyLarge,
      color: Palette.textDark,
    ),
    bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: Dimens.bodyMedium,
      color: Palette.textDark,
    ),
    bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
      fontSize: Dimens.bodySmall,
      color: Palette.textDark,
    ),
    labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(
      fontSize: Dimens.labelLarge,
      color: Palette.textDark,
    ),
    labelSmall: Theme.of(context).textTheme.labelSmall?.copyWith(
      fontSize: Dimens.labelSmall,
      letterSpacing: 0.25,
      color: Palette.textDark,
    ),
  ),
  appBarTheme: const AppBarTheme().copyWith(
    titleTextStyle: Theme.of(context).textTheme.bodyLarge,
    iconTheme: const IconThemeData(color: Palette.iconDark),
    backgroundColor: Palette.backgroundDark,
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ),
    surfaceTintColor: Palette.backgroundDark,
    shadowColor: Palette.shadowDark,
  ),
  drawerTheme: const DrawerThemeData().copyWith(
    elevation: Dimens.zero,
    surfaceTintColor: Palette.backgroundDark,
    backgroundColor: Palette.backgroundDark,
    shadowColor: Palette.shadowDark,
  ),
  bottomSheetTheme: const BottomSheetThemeData().copyWith(
    backgroundColor: Palette.backgroundDark,
    surfaceTintColor: Colors.transparent,
    elevation: Dimens.zero,
  ),
  dialogTheme: const DialogThemeData().copyWith(
    backgroundColor: Palette.backgroundDark,
    surfaceTintColor: Colors.transparent,
    elevation: Dimens.zero,
  ),
  brightness: Brightness.dark,
  iconTheme: const IconThemeData(color: Palette.iconDark),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  extensions: const <ThemeExtension<AppColors>>[
    AppColors(
      background: Palette.backgroundDark,
      banner: Palette.bannerDark,
      buttonText: Palette.textDark,
      card: Palette.cardDark,
      subtitle: Palette.subtitleDark,
      shadow: Palette.shadowDark,
      textOnGradient: Palette.textOnGradient,
      green: Palette.greenMocha,
      roseWater: Palette.roseWaterMocha,
      flamingo: Palette.flamingoMocha,
      pink: Palette.pinkMocha,
      mauve: Palette.mauveMocha,
      maroon: Palette.maroonMocha,
      peach: Palette.peachMocha,
      yellow: Palette.yellowMocha,
      teal: Palette.tealMocha,
      sapphire: Palette.sapphireMocha,
      sky: Palette.skyMocha,
      blue: Palette.blueMocha,
      lavender: Palette.lavenderMocha,
      red: Palette.redMocha,
    ),
  ],
);
