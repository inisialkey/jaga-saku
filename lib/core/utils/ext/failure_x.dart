import 'package:flutter/widgets.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/localization/localization.dart';

extension FailureLocalization on Failure {
  /// User-safe, localized message for a [Failure].
  ///
  /// Technical / network failures map to ARB strings so users never see raw
  /// English defaults. [ServerFailure] keeps the backend's message when present
  /// (that is the intended business-facing text, e.g. "Invalid credentials"),
  /// falling back to a generic localized string.
  String localize(BuildContext context) {
    final s = Strings.of(context)!;
    // Exhaustive over the sealed Failure hierarchy — no wildcard, so a new
    // Failure subtype is a compile error until it gets a localized branch.
    return switch (this) {
      ConnectionFailure() => s.noInternetConnection,
      TimeoutFailure() => s.errorTimeout,
      SessionExpiredFailure() => s.sessionExpiredMessage,
      CancelledFailure() => s.errorCancelled,
      NoDataFailure() => s.errorNoData,
      CacheFailure() => s.errorUnexpected,
      UnauthorizedFailure(:final message) =>
        (message == null || message.isEmpty) ? s.errorUnauthorized : message,
      ForbiddenFailure(:final message) =>
        (message == null || message.isEmpty) ? s.errorForbidden : message,
      NotFoundFailure(:final message) =>
        (message == null || message.isEmpty) ? s.errorNotFound : message,
      ConflictFailure(:final message) =>
        (message == null || message.isEmpty) ? s.errorConflict : message,
      PayloadTooLargeFailure(:final message) =>
        (message == null || message.isEmpty) ? s.errorPayloadTooLarge : message,
      UnsupportedMediaTypeFailure(:final message) =>
        (message == null || message.isEmpty)
            ? s.errorUnsupportedMediaType
            : message,
      ValidationFailure(:final message) =>
        (message == null || message.isEmpty) ? s.errorValidation : message,
      RateLimitFailure(:final message) =>
        (message == null || message.isEmpty) ? s.errorRateLimit : message,
      MaintenanceFailure(:final message) =>
        (message == null || message.isEmpty) ? s.errorMaintenance : message,
      ForceUpdateFailure(:final message) =>
        (message == null || message.isEmpty) ? s.errorForceUpdate : message,
      InternalServerFailure(:final message) =>
        (message == null || message.isEmpty) ? s.errorServer : message,
      ServerFailure(:final message) =>
        (message == null || message.isEmpty) ? s.errorUnexpected : message,
    };
  }
}
