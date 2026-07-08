import 'package:equatable/equatable.dart';

/// Base type for every domain-facing failure.
///
/// `sealed` so `switch (failure)` is exhaustive — adding a new subtype forces
/// a localized branch in [FailureLocalization.localize] at compile time.
/// Extends [Equatable] so subclasses get value equality from [props] instead
/// of hand-rolled `==` / `hashCode`.
sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => const [];
}

class ServerFailure extends Failure {
  final String? message;

  const ServerFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class NoDataFailure extends Failure {
  const NoDataFailure();
}

class CacheFailure extends Failure {
  const CacheFailure();
}

class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure();
}

class ConnectionFailure extends Failure {
  final String message;

  const ConnectionFailure([this.message = 'No internet connection']);

  @override
  List<Object?> get props => [message];
}

class TimeoutFailure extends Failure {
  final String message;

  const TimeoutFailure([this.message = 'Request timed out']);

  @override
  List<Object?> get props => [message];
}

class CancelledFailure extends Failure {
  const CancelledFailure();
}

/// 401 `AUTH_TOKEN_INVALID` / `AUTH_INVALID_CREDENTIALS` — credentials or token
/// rejected. Carries the backend's snackbar-safe message when present.
class UnauthorizedFailure extends Failure {
  final String? message;

  const UnauthorizedFailure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// 403 `AUTHORIZATION_FORBIDDEN` — authenticated but not permitted.
class ForbiddenFailure extends Failure {
  final String? message;

  const ForbiddenFailure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// 404 `RESOURCE_NOT_FOUND`.
class NotFoundFailure extends Failure {
  final String? message;

  const NotFoundFailure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// 409 `RESOURCE_ALREADY_EXISTS` — conflict with existing state.
class ConflictFailure extends Failure {
  final String? message;

  const ConflictFailure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// 413 `FILE_TOO_LARGE` — upload exceeds the allowed size.
class PayloadTooLargeFailure extends Failure {
  final String? message;

  const PayloadTooLargeFailure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// 415 `UNSUPPORTED_MEDIA_TYPE` — content type not accepted.
class UnsupportedMediaTypeFailure extends Failure {
  final String? message;

  const UnsupportedMediaTypeFailure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// 500 `INTERNAL_SERVER_ERROR` — server fault.
class InternalServerFailure extends Failure {
  final String? message;

  const InternalServerFailure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// 422 `VALIDATION_ERROR` — carries the per-field error map from `errors`.
class ValidationFailure extends Failure {
  final String? message;
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({this.message, this.fieldErrors});

  @override
  List<Object?> get props => [message, fieldErrors];
}

/// 429 `RATE_LIMIT_EXCEEDED`.
class RateLimitFailure extends Failure {
  final String? message;

  const RateLimitFailure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// 503 `MAINTENANCE_MODE`.
class MaintenanceFailure extends Failure {
  final String? message;

  const MaintenanceFailure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// `FORCE_UPDATE_REQUIRED` — client must update before continuing.
class ForceUpdateFailure extends Failure {
  final String? message;

  const ForceUpdateFailure([this.message]);

  @override
  List<Object?> get props => [message];
}
