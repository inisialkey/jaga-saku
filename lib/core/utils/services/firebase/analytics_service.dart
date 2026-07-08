import 'package:firebase_analytics/firebase_analytics.dart';

/// Thin wrapper over [FirebaseAnalytics] so the rest of the app never imports
/// the plugin directly (mirrors how [NotificationService] wraps Messaging).
///
/// Registered for the real app only — unit tests must not touch the Analytics
/// platform channels. The [observer] is added to the go_router config so a
/// `screen_view` event is logged automatically on every route change; call
/// [logEvent] / [logLogin] for custom events.
class AnalyticsService {
  AnalyticsService([FirebaseAnalytics? analytics])
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  /// Drop-in [NavigatorObserver] for `GoRouter(observers: ...)` — logs a
  /// `screen_view` whenever the active route changes.
  late final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: _analytics,
  );

  Future<void> logLogin({String method = 'password'}) =>
      _analytics.logLogin(loginMethod: method);

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) =>
      _analytics.logEvent(name: name, parameters: parameters);

  /// Associates subsequent events with the signed-in user (clear with `null`).
  Future<void> setUserId(String? id) => _analytics.setUserId(id: id);
}
