class Images {
  Images._();

  static String icLauncher =
      const String.fromEnvironment('ENV', defaultValue: 'staging') == 'staging'
      ? 'assets/images/ic_launcher_stg.png'
      : 'assets/images/ic_launcher.png';

  static String icLauncherDark =
      const String.fromEnvironment('ENV', defaultValue: 'staging') == 'staging'
      ? 'assets/images/ic_launcher_stg_dark.png'
      : 'assets/images/ic_launcher_dark.png';

  static String icLogoSplash = 'assets/images/ic_logo_splash.png';
  static String icLogo = 'assets/images/ic_logo.png';
  static String icHome = 'assets/icons/ic_home.png';
  static String icHomeActive = 'assets/icons/ic_home_active.png';
  static String icBloods = 'assets/icons/bloods.png';
  static String icHeartMonitor = 'assets/icons/heart_monitor.png';
  static String icKcal = 'assets/icons/kcal.png';
  static String icSleep = 'assets/icons/sleep.png';
  static String icStep = 'assets/icons/step.png';
  static String icProfile = 'assets/icons/profile.png';
  static String banner = 'assets/images/banner1.png';
}
