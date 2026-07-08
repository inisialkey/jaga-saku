import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';

/// Top-level background / terminated-state FCM message handler.
///
/// MUST be a top-level (or static) function and annotated with
/// `@pragma('vm:entry-point')` so the Flutter engine can find it after a
/// background isolate is spawned. Runs in its OWN isolate — it cannot touch
/// app state / UI / the main-isolate Firebase instance.
///
/// Kept in its own file so the `@pragma('vm:entry-point')` annotation does not
/// make the whole NotificationService library analyze as an executable
/// (which would flag every public member as `unreachable_from_main`).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Keep this minimal and crash-proof. For a `notification` payload the OS
  // already renders the tray entry; this hook is only for data-only background
  // work. Avoid any plugin call that needs the main isolate. Logging is safe.
  log.i('FCM background message: ${message.messageId}');
}
