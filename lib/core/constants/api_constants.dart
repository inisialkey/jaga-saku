/// API-level magic strings (error codes, response keys, signal messages).
///
/// Centralizes string literals used to recognize backend error shapes and to
/// signal cross-layer events (e.g. session expiry passed via `DioException.message`).
class ApiConstants {
  ApiConstants._();

  /// Sentinel message attached to `DioException` so downstream layers can
  /// recognize a session-expiry handoff without depending on HTTP status.
  static const String sessionExpiredMessage = 'SESSION_EXPIRED';
}
