/// Mirrors the backend `error_code` enum from the response error envelope.
///
/// HTTP status is the *category*; `error_code` is the *specific cause* and is
/// the dispatch key the interceptor / [Failure] mapping branch on. Any code the
/// app does not recognize collapses to [ApiErrorCode.unknown].
enum ApiErrorCode {
  badRequest('BAD_REQUEST'),
  authInvalidCredentials('AUTH_INVALID_CREDENTIALS'),
  authTokenExpired('AUTH_TOKEN_EXPIRED'),
  authTokenInvalid('AUTH_TOKEN_INVALID'),
  authRefreshTokenInvalid('AUTH_REFRESH_TOKEN_INVALID'),
  authAccountDisabled('AUTH_ACCOUNT_DISABLED'),
  authorizationForbidden('AUTHORIZATION_FORBIDDEN'),
  resourceNotFound('RESOURCE_NOT_FOUND'),
  resourceAlreadyExists('RESOURCE_ALREADY_EXISTS'),
  fileTooLarge('FILE_TOO_LARGE'),
  unsupportedMediaType('UNSUPPORTED_MEDIA_TYPE'),
  validationError('VALIDATION_ERROR'),
  forceUpdateRequired('FORCE_UPDATE_REQUIRED'),
  rateLimitExceeded('RATE_LIMIT_EXCEEDED'),
  maintenanceMode('MAINTENANCE_MODE'),
  internalServerError('INTERNAL_SERVER_ERROR'),
  unknown('UNKNOWN');

  const ApiErrorCode(this.code);

  /// The wire value as sent by the backend in `error_code`.
  final String code;

  /// Resolves a raw backend `error_code` string to its enum.
  ///
  /// Returns [ApiErrorCode.unknown] for `null`, empty, or unrecognized values
  /// so callers never have to null-check.
  static ApiErrorCode fromCode(String? code) {
    if (code == null) return ApiErrorCode.unknown;
    for (final value in ApiErrorCode.values) {
      if (value.code == code) return value;
    }
    return ApiErrorCode.unknown;
  }
}
