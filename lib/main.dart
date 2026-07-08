import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/app.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  runZonedGuarded(
    /// Lock device orientation to portrait
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      /// Firebase MUST init before the service locator: services registered
      /// there (e.g. NotificationService → FirebaseMessaging.instance) touch
      /// Firebase in their constructor and throw [core/no-app] otherwise.
      ///
      /// Guarded + time-boxed so a missing / placeholder Firebase project
      /// (before `flutterfire configure`) can never block the first frame.
      try {
        await FirebaseServices.init().timeout(const Duration(seconds: 5));
      } on Object catch (error, stackTrace) {
        log.e('FirebaseServices.init skipped', error: error, stackTrace: stackTrace);
      }

      /// Register Service locator
      await serviceLocator();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      runApp(const App());

      /// FCM init runs AFTER runApp so the OS notification-permission prompt
      /// never blocks the first frame (otherwise the app hangs on the splash
      /// behind the system dialog). Fire-and-forget + guarded so a missing /
      /// misconfigured Firebase project never crashes startup.
      if (sl.isRegistered<NotificationService>()) {
        unawaited(_initNotifications());
      }

      // Fetch remote config / feature flags in the background (offline-safe;
      // flags fall back to their defaults until the first successful load).
      unawaited(sl<RemoteConfigService>().load());
    },
    (error, stackTrace) {
      // Always surface the real error. Guard Crashlytics: if an error escapes
      // before Firebase.initializeApp() completes, FirebaseCrashlytics.instance
      // throws [core/no-app] and masks the original error.
      log.e('Uncaught zone error', error: error, stackTrace: stackTrace);
      if (Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          fatal: true,
        );
      }
    },
  );
}

/// Guarded FCM initialization, fired post-`runApp` so the notification
/// permission prompt never blocks app launch.
Future<void> _initNotifications() async {
  try {
    await sl<NotificationService>().init(
      // Notification tap → navigate via go_router using the global key.
      onNotificationTap: (route) {
        final context = AppRoute.navigatorKey.currentContext;
        if (context != null && context.mounted) context.go(route);
      },
    );
  } on Exception catch (error, stackTrace) {
    log.e(
      'NotificationService.init failed',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
