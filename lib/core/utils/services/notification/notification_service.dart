import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:jaga_saku/core/utils/services/hive/main_box.dart';
import 'package:jaga_saku/core/utils/services/notification/local_notification_helper.dart';
import 'package:jaga_saku/core/utils/services/notification/notification_background_handler.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';

/// Resolves a notification's data payload to an in-app route (a go_router
/// location). Convention: the payload carries `route` (e.g.
/// `{ "route": "/users/123" }`). Returns `null` when absent/empty so the tap
/// just opens the app. Pure — unit-tested; the tap plumbing below is
/// platform-channel coupled.
String? notificationRouteFor(Map<String, dynamic> data) {
  final route = data['route'];
  return (route is String && route.isNotEmpty) ? route : null;
}

/// Wraps FirebaseMessaging so the rest of the app never imports it directly.
///
/// Responsibilities:
/// - request notification permission (iOS + Android 13+),
/// - fetch and persist the FCM token to Hive ([MainBoxKeys.fcm]),
/// - re-persist on `onTokenRefresh`,
/// - expose foreground / tap streams for routing,
/// - optionally render a heads-up notification for foreground messages via
///   [LocalNotificationHelper].
///
/// All hard FirebaseMessaging IO is injected so a unit test can construct the
/// service with fakes. The Firebase plugin channels are NOT exercised in unit
/// tests — those paths are integration-only.
class NotificationService with MainBoxMixin {
  NotificationService({
    FirebaseMessaging? messaging,
    LocalNotificationHelper? localNotifications,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _local = localNotifications ?? LocalNotificationHelper();

  final FirebaseMessaging _messaging;
  final LocalNotificationHelper _local;

  /// Invoked with the resolved in-app route when a notification is tapped.
  /// Wired from `main()` to go_router via the global navigator key.
  void Function(String route)? _onTap;

  StreamSubscription<String>? _tokenRefreshSub;

  /// Emits when a notification is received while the app is in the foreground.
  Stream<RemoteMessage> get onForegroundMessage => FirebaseMessaging.onMessage;

  /// Emits when the user taps a notification that opened / resumed the app
  /// from the background (NOT terminated). Use [getInitialMessage] for the
  /// terminated-state tap.
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  /// The message that launched the app from a terminated state via a
  /// notification tap, or null. Call once after [init] to route on cold start.
  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();

  /// Full initialization. Safe to call once at startup AFTER
  /// `FirebaseServices.init()`. Callers should still guard with try/catch so a
  /// missing Firebase config never blocks app launch.
  Future<void> init({void Function(String route)? onNotificationTap}) async {
    _onTap = onNotificationTap;

    // Register the background handler before anything else.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _local.init(onTap: _handleLocalTap);
    await requestPermission();

    // iOS: show heads-up alert/badge/sound for foreground messages.
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _persistToken();

    _tokenRefreshSub = _messaging.onTokenRefresh.listen(_saveToken);

    // Render a heads-up notification for foreground messages (Android shows
    // nothing by default while the app is open; iOS handled by the options
    // above but we also mirror it locally for consistency / custom UI).
    FirebaseMessaging.onMessage.listen(_showForeground);

    // Tap → navigation. Background/resumed tap fires onMessageOpenedApp; a
    // terminated-state tap is delivered once via getInitialMessage.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteTap);
    final initialMessage = await getInitialMessage();
    if (initialMessage != null) _handleRemoteTap(initialMessage);
  }

  /// Background / terminated tap: resolve the route straight off the message.
  void _handleRemoteTap(RemoteMessage message) {
    final route = notificationRouteFor(message.data);
    if (route != null) _onTap?.call(route);
  }

  /// Foreground local-notification tap: the payload is the JSON-encoded data
  /// map (see [_showForeground]). Guards a malformed payload.
  void _handleLocalTap(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        final route = notificationRouteFor(decoded);
        if (route != null) _onTap?.call(route);
      }
    } on FormatException catch (error, stackTrace) {
      log.e('Bad notification payload', error: error, stackTrace: stackTrace);
    }
  }

  /// Requests notification permission. On Android 13+ this surfaces the
  /// POST_NOTIFICATIONS system dialog; on iOS the APNs alert/badge/sound prompt.
  Future<NotificationSettings> requestPermission() =>
      _messaging.requestPermission();

  /// Returns the current FCM registration token (or null if unavailable).
  Future<String?> getToken() => _messaging.getToken();

  Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);

  /// Fetches the token and writes it to Hive. Exposed (vs inlined) so a unit
  /// test can drive token persistence with a mockable token source.
  Future<void> _persistToken() async {
    final token = await getToken();
    await _saveToken(token);
  }

  /// Persists [token] to Hive under [MainBoxKeys.fcm]. No-op when null/empty.
  /// Package-visible for unit testing the persistence contract.
  @visibleForTesting
  Future<void> saveTokenForTest(String? token) => _saveToken(token);

  Future<void> _saveToken(String? token) async {
    if (token == null || token.isEmpty) return;
    await addData<String>(MainBoxKeys.fcm, token);
    log.i('FCM token persisted (${token.length} chars)');
  }

  Future<void> _showForeground(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    await _local.show(
      title: notification.title,
      body: notification.body,
      // JSON so the tap handler can decode it back to the data map.
      payload: message.data.isEmpty ? null : jsonEncode(message.data),
    );
  }

  /// Cancels the token-refresh subscription. App-lifetime singletons rarely
  /// need this, but it keeps the service leak-free in tests / hot restart.
  Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
  }
}
