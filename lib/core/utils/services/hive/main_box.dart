import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

enum ActiveTheme {
  light(ThemeMode.light),
  dark(ThemeMode.dark),
  system(ThemeMode.system);

  final ThemeMode mode;

  const ActiveTheme(this.mode);
}

enum MainBoxKeys { fcm, theme, locale, isLogin }

mixin class MainBoxMixin {
  static late Box? mainBox;
  static const _boxName = 'flutter_auth_app';

  static Future<void> initHive(String prefixBox) async {
    // Initialize hive (persistent database)
    await Hive.initFlutter();
    final boxName = '$prefixBox$_boxName';
    try {
      mainBox = await Hive.openBox(boxName);
    } catch (_) {
      // Corrupt box on disk would otherwise crash the app at startup.
      // Delete and recreate it so the app can still launch (local prefs reset).
      await Hive.deleteBoxFromDisk(boxName);
      mainBox = await Hive.openBox(boxName);
    }
  }

  Future<void> addData<T>(MainBoxKeys key, T value) async {
    await mainBox?.put(key.name, value);
  }

  Future<void> removeData(MainBoxKeys key) async {
    await mainBox?.delete(key.name);
  }

  T? getData<T>(MainBoxKeys key) => mainBox?.get(key.name) as T?;

  Future<void> logoutBox() async {
    await removeData(MainBoxKeys.isLogin);
  }
}
