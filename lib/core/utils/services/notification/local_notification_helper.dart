import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Thin wrapper over `flutter_local_notifications` used to render a heads-up
/// notification for FCM messages received while the app is in the foreground
/// (Android shows nothing automatically in that case).
///
/// Kept separate from [NotificationService] so the FCM logic and the local
/// display logic can be reasoned about / mocked independently.
class LocalNotificationHelper {
  LocalNotificationHelper({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  /// Default Android channel. Must match the `default_notification_channel_id`
  /// meta-data in AndroidManifest.xml so FCM-delivered (tray) notifications and
  /// these foreground notifications share one channel.
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';
  static const String channelDescription =
      'Used for important notifications such as reminders and updates.';

  bool _initialized = false;

  Future<void> init({void Function(String? payload)? onTap}) async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      // Permission is requested via FirebaseMessaging; don't double-prompt.
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      // Foreground local-notification tap → forward the payload for routing.
      onDidReceiveNotificationResponse: onTap == null
          ? null
          : (response) => onTap(response.payload),
    );

    // Pre-create the Android channel so the first notification isn't dropped.
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.high,
      ),
    );

    _initialized = true;
  }

  Future<void> show({String? title, String? body, String? payload}) async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    try {
      await _plugin.show(
        // Use a time-based id so concurrent notifications don't overwrite.
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        const NotificationDetails(android: androidDetails, iOS: iosDetails),
        payload: payload,
      );
    } on Exception catch (e, s) {
      // Never let a display failure crash the message handler.
      log.e('LocalNotificationHelper.show failed', error: e, stackTrace: s);
    }
  }
}
