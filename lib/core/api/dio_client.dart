import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';
import 'package:jaga_saku/core/core.dart';

typedef ResponseConverter<T> = T Function(Object? response);

class DioClient with FirebaseCrashLogger {
  String baseUrl = const String.fromEnvironment('BASE_URL');

  bool _isUnitTest = false;
  late Dio _dio;

  DioClient({bool isUnitTest = false}) {
    _isUnitTest = isUnitTest;
    _dio = _createDio();

    if (!_isUnitTest) {
      _dio.interceptors.add(DioInterceptor());
      // TLS certificate pinning. No-op (default adapter untouched) unless
      // kEnableCertificatePinning is true AND kCertificatePins is non-empty —
      // so existing behavior / tests are unaffected while pinning is OFF.
      CertificatePinning.applyIfEnabled(_dio);
    }
  }

  /// Single Dio instance reused across requests to preserve connection
  /// pooling / keep-alive. The auth token is injected per-request in
  /// [DioInterceptor.onRequest] from [AuthTokenService], so there is no need
  /// to recreate Dio after login.
  Dio get dio => _dio;

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-api-key': const String.fromEnvironment('API_KEY'),
        },
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 15),
        validateStatus: (int? status) =>
            status != null && status >= 200 && status < 300,
      ),
    );
    return dio;
  }

  Future<Either<Failure, T>> getRequest<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(url, queryParameters: queryParameters);
      return Right(converter(response.data));
    } on ServerFailure catch (f) {
      return Left(f);
    } on DioException catch (e, stackTrace) {
      return Left(_mapDioException(e, stackTrace));
    } catch (e, stackTrace) {
      // Non-Dio, non-ServerFailure escape (e.g. converter / isolate error).
      // Preserve the Either<Failure, T> contract instead of crashing the caller.
      if (!_isUnitTest) {
        nonFatalError(error: e, stackTrace: stackTrace);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, T>> postRequest<T>(
    String url, {
    required ResponseConverter<T> converter,
    // Object? (not Map) so multipart FormData (e.g. file upload) can pass
    // through the same central error-mapped path as JSON-body posts.
    Object? data,
    Options? options,
  }) async {
    try {
      final response = await dio.post(url, data: data);
      return Right(converter(response.data));
    } on ServerFailure catch (f) {
      return Left(f);
    } on DioException catch (e, stackTrace) {
      return Left(_mapDioException(e, stackTrace));
    } catch (e, stackTrace) {
      // Non-Dio, non-ServerFailure escape (e.g. converter / isolate error).
      // Preserve the Either<Failure, T> contract instead of crashing the caller.
      if (!_isUnitTest) {
        nonFatalError(error: e, stackTrace: stackTrace);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, T>> putRequest<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    try {
      final response = await dio.put(url, data: data);
      return Right(converter(response.data));
    } on ServerFailure catch (f) {
      return Left(f);
    } on DioException catch (e, stackTrace) {
      return Left(_mapDioException(e, stackTrace));
    } catch (e, stackTrace) {
      // Non-Dio, non-ServerFailure escape (e.g. converter / isolate error).
      // Preserve the Either<Failure, T> contract instead of crashing the caller.
      if (!_isUnitTest) {
        nonFatalError(error: e, stackTrace: stackTrace);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, T>> deleteRequest<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    try {
      final response = await dio.delete(url, data: data);
      return Right(converter(response.data));
    } on ServerFailure catch (f) {
      return Left(f);
    } on DioException catch (e, stackTrace) {
      return Left(_mapDioException(e, stackTrace));
    } catch (e, stackTrace) {
      // Non-Dio, non-ServerFailure escape (e.g. converter error).
      // Preserve the Either<Failure, T> contract instead of crashing the caller.
      if (!_isUnitTest) {
        nonFatalError(error: e, stackTrace: stackTrace);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Maps a [DioException] to a typed [Failure], covering every
  /// [DioExceptionType]. Only genuine server faults (5xx) are reported to
  /// Crashlytics, and as a redacted string (method + path + status) so that
  /// token-bearing response bodies are never recorded.
  Failure _mapDioException(DioException e, StackTrace stackTrace) {
    if (e.message == ApiConstants.sessionExpiredMessage) {
      return const SessionExpiredFailure();
    }
    switch (e.type) {
      case DioExceptionType.connectionError:
        return ConnectionFailure(e.message ?? 'No internet connection');
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();
      case DioExceptionType.cancel:
        return const CancelledFailure();
      case DioExceptionType.badCertificate:
        return const ServerFailure('Certificate verification failed');
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        final statusCode = e.response?.statusCode;
        if (!_isUnitTest && statusCode != null && statusCode >= 500) {
          nonFatalError(
            error:
                'HTTP $statusCode ${e.requestOptions.method} ${e.requestOptions.path}',
            stackTrace: stackTrace,
          );
        }
        return _mapErrorEnvelope(e);
    }
  }

  /// Maps an error response body (`{ success:false, message, errors?,
  /// error_code, request_id }`) to a typed [Failure] via [ApiErrorCode].
  ///
  /// Guards a non-Map body and falls back to [ServerFailure] for unknown /
  /// 5xx / server codes so the `Either<Failure, T>` contract always holds.
  Failure _mapErrorEnvelope(DioException e) {
    final data = e.response?.data;
    if (data is! Map<String, dynamic>) {
      return ServerFailure(e.message);
    }

    final envelope = ApiErrorResponse.fromJson(data);
    final message = envelope.message;
    final code = ApiErrorCode.fromCode(envelope.errorCode);

    switch (code) {
      case ApiErrorCode.authInvalidCredentials:
      case ApiErrorCode.authTokenInvalid:
      case ApiErrorCode.authTokenExpired:
      case ApiErrorCode.authRefreshTokenInvalid:
      case ApiErrorCode.authAccountDisabled:
        return UnauthorizedFailure(message);
      case ApiErrorCode.authorizationForbidden:
        return ForbiddenFailure(message);
      case ApiErrorCode.resourceNotFound:
        return NotFoundFailure(message);
      case ApiErrorCode.validationError:
        return ValidationFailure(
          message: message,
          fieldErrors: envelope.errors,
        );
      case ApiErrorCode.rateLimitExceeded:
        return RateLimitFailure(message);
      case ApiErrorCode.maintenanceMode:
        return MaintenanceFailure(message);
      case ApiErrorCode.forceUpdateRequired:
        return ForceUpdateFailure(message);
      case ApiErrorCode.resourceAlreadyExists:
        return ConflictFailure(message);
      case ApiErrorCode.fileTooLarge:
        return PayloadTooLargeFailure(message);
      case ApiErrorCode.unsupportedMediaType:
        return UnsupportedMediaTypeFailure(message);
      case ApiErrorCode.internalServerError:
        return InternalServerFailure(message);
      case ApiErrorCode.badRequest:
      case ApiErrorCode.unknown:
        return ServerFailure(message ?? e.message);
    }
  }
}
