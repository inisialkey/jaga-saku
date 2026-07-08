import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/auth/auth.dart';

/// Parses the refresh endpoint's success envelope
/// (`{ data: { access_token, refresh_token, ... } }`). Returns
/// `(access, refresh)`, or `null` when the body shape is wrong or either token
/// is missing/non-string. Pure + [visibleForTesting]; the interceptor below is
/// UI/service-locator-coupled (hence coverage:ignore), but this decode logic —
/// the part most prone to silent shape bugs — is unit-tested.
@visibleForTesting
(String, String)? parseRefreshTokens(Object? body) {
  if (body is! Map<String, dynamic>) return null;
  final data = body['data'];
  if (data is! Map<String, dynamic>) return null;
  final access = data['access_token'];
  final refresh = data['refresh_token'];
  if (access is! String || refresh is! String) return null;
  return (access, refresh);
}

/// Whether a 401 with [code] is recoverable via a token refresh. Only
/// `AUTH_TOKEN_EXPIRED` is — every other 401 (token invalid, refresh-token
/// invalid, account disabled, unknown) forces a logout.
@visibleForTesting
bool shouldAttemptRefresh(ApiErrorCode code) =>
    code == ApiErrorCode.authTokenExpired;

/// The full-screen gate route for an app-status [code], or `null` when the code
/// is not a gate. `FORCE_UPDATE_REQUIRED` / `MAINTENANCE_MODE` block the app
/// until resolved. Pure + [visibleForTesting].
@visibleForTesting
String? blockingRouteForCode(ApiErrorCode code) => switch (code) {
  ApiErrorCode.forceUpdateRequired => Routes.forceUpdate.path,
  ApiErrorCode.maintenanceMode => Routes.maintenance.path,
  _ => null,
};

/// Header keys whose values must never be printed in debug logs — they carry
/// credentials/session material. Compared case-insensitively.
@visibleForTesting
const sensitiveHeaderKeys = <String>{
  'authorization',
  'x-api-key',
  'cookie',
  'set-cookie',
  'proxy-authorization',
};

/// Masks the value of any [sensitiveHeaderKeys] header; passes others through.
/// Pure + [visibleForTesting] — debug-log redaction is security-sensitive.
@visibleForTesting
String redactHeader(String key, Object? value) =>
    sensitiveHeaderKeys.contains(key.toLowerCase()) ? '[REDACTED]' : '$value';

/// Whether [path] hits an auth endpoint (`/auth/*`) whose request/response body
/// carries credentials or tokens (login password, access/refresh tokens). Such
/// bodies are redacted even in debug logs. Pure + [visibleForTesting].
@visibleForTesting
bool isSensitiveAuthPath(String path) => path.contains('/auth/');

// coverage:ignore-start
class DioInterceptor extends Interceptor with FirebaseCrashLogger {
  /// Completer-based lock: only the first 401 triggers a refresh.
  /// Subsequent 401s await this Completer's future.
  static Completer<bool>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check connectivity before proceeding
    if (sl.isRegistered<ConnectivityService>() &&
        !sl<ConnectivityService>().isConnected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'No internet connection',
        ),
      );
    }

    final token = await sl<AuthTokenService>().getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (kDebugMode) {
      String headerMessage = '';
      options.headers.forEach((k, v) {
        headerMessage += '► $k: ${redactHeader(k, v)}\n';
      });

      try {
        options.queryParameters.forEach((k, v) => log.d('► $k: $v'));
      } on Exception catch (e) {
        log.e('Failed to print query parameters: $e');
      }
      try {
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        // Auth bodies carry passwords / tokens — never print them, even in debug.
        final String prettyJson = isSensitiveAuthPath(options.path)
            ? '[REDACTED — auth request body]'
            : encoder.convert(options.data);
        log.d(
          'REQUEST ► ︎ ${options.method.toUpperCase()} ${options.baseUrl}${options.path}\n\n'
          'Headers:\n'
          '$headerMessage\n'
          '❖ QueryParameters : \n'
          'Body: $prettyJson',
        );
      } catch (e, stackTrace) {
        log.e('Failed to extract json request $e');
        nonFatalError(error: e, stackTrace: stackTrace);
      }
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException dioException,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = dioException.response?.statusCode;
    final endpoint =
        '${dioException.requestOptions.method} ${dioException.requestOptions.path}';

    if (kDebugMode) {
      // Debug-only, redacted: no response body (may contain tokens/PII).
      log.e('<-- ${statusCode ?? dioException.type.name} $endpoint');
    }

    // Report only genuine server faults (5xx) to Crashlytics, and as a redacted
    // string — never the raw DioException, whose response body can carry
    // access/refresh tokens (login & refresh endpoints) and floods non-fatals
    // with expected 4xx/connection errors.
    if (statusCode != null && statusCode >= 500) {
      nonFatalError(
        error: 'HTTP $statusCode $endpoint',
        stackTrace: dioException.stackTrace,
      );
    }

    // Dispatch on the backend `error_code` (guard a non-Map body).
    final responseData = dioException.response?.data;
    final rawCode = responseData is Map<String, dynamic>
        ? responseData['error_code']
        : null;
    final errorCode = ApiErrorCode.fromCode(rawCode is String ? rawCode : null);

    // App-status gate (any status code): force-update / maintenance route to a
    // full-screen, non-dismissable page (same global navigatorKey mechanism as
    // the 401 session-expired dialog below).
    final blockingRoute = blockingRouteForCode(errorCode);
    if (blockingRoute != null) {
      _goBlocking(blockingRoute);
      return handler.reject(dioException);
    }

    // Only 401 is handled here; everything else passes through.
    if (dioException.response?.statusCode != 401) {
      return handler.next(dioException);
    }

    final sessionExpiredException = DioException(
      requestOptions: dioException.requestOptions,
      message: ApiConstants.sessionExpiredMessage,
    );

    // Only AUTH_TOKEN_EXPIRED attempts a refresh. Refresh-token-invalid and any
    // other 401 (e.g. AUTH_TOKEN_INVALID) force a logout.
    if (!shouldAttemptRefresh(errorCode)) {
      await sl<ClearSession>().call();
      _showSessionExpiredDialog();
      return handler.reject(sessionExpiredException);
    }

    // No refresh token stored — session is invalid
    if (await sl<AuthTokenService>().getRefreshToken() == null) {
      await sl<ClearSession>().call();
      _showSessionExpiredDialog();
      return handler.reject(sessionExpiredException);
    }

    // Another request is already refreshing — wait for it
    if (_refreshCompleter != null) {
      final success = await _refreshCompleter!.future;
      if (success) {
        return handler.resolve(await _retry(dioException.requestOptions));
      }
      return handler.reject(sessionExpiredException);
    }

    // First 401 — take the lock and refresh
    _refreshCompleter = Completer<bool>();
    try {
      final success = await _refreshToken();
      _refreshCompleter!.complete(success);
      _refreshCompleter = null;

      if (success) {
        return handler.resolve(await _retry(dioException.requestOptions));
      }
      _showSessionExpiredDialog();
      return handler.reject(sessionExpiredException);
    } catch (e) {
      _refreshCompleter!.complete(false);
      _refreshCompleter = null;
      await sl<ClearSession>().call();
      _showSessionExpiredDialog();
      return handler.reject(sessionExpiredException);
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final newToken = await sl<AuthTokenService>().getAccessToken();
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        if (newToken != null) 'Authorization': 'Bearer $newToken',
      },
    );

    return sl<DioClient>().dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Calls the refresh token API using a raw Dio instance (no interceptors)
  /// to avoid recursive interceptor loops.
  /// Returns true on success, false on failure.
  Future<bool> _refreshToken() async {
    try {
      const baseUrl = String.fromEnvironment('BASE_URL');
      final currentRefreshToken = await sl<AuthTokenService>()
          .getRefreshToken();
      final rawDio = Dio(
        BaseOptions(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'x-api-key': const String.fromEnvironment('API_KEY'),
          },
          receiveTimeout: const Duration(seconds: 30),
          connectTimeout: const Duration(seconds: 15),
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
      );

      // Contract: POST /auth/refresh with body { "refresh_token": <token> }.
      // Response envelope: { data: { access_token, refresh_token, ... } }.
      final response = await rawDio.post<dynamic>(
        '$baseUrl${ListAPI.refreshToken}',
        data: {'refresh_token': currentRefreshToken},
      );

      final tokens = parseRefreshTokens(response.data);
      if (tokens == null) {
        await sl<ClearSession>().call();
        return false;
      }

      await sl<AuthTokenService>().saveTokens(
        accessToken: tokens.$1,
        refreshToken: tokens.$2,
      );
      return true;
    } catch (e, stackTrace) {
      nonFatalError(error: e, stackTrace: stackTrace);
      await sl<ClearSession>().call();
      return false;
    }
  }

  /// Routes to a full-screen app-status gate (force-update / maintenance) via
  /// the global navigator key. `go` replaces the stack so the gate can't be
  /// popped; the route's own redirect keeps the user there.
  void _goBlocking(String path) {
    final context = AppRoute.navigatorKey.currentContext;
    if (context == null || !context.mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) context.go(path);
    });
  }

  void _showSessionExpiredDialog() {
    final context = AppRoute.navigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text(
            Strings.of(context)?.sessionExpiredTitle ?? 'Session Expired',
          ),
          content: Text(
            Strings.of(context)?.sessionExpiredMessage ??
                'Your session has expired. Please log in again.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                context.pop();
                await sl<ClearSession>().call();
                if (context.mounted) context.goNamed(Routes.root.name);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      String headerMessage = '';
      response.headers.forEach(
        (k, v) => headerMessage += '► $k: ${redactHeader(k, v)}\n',
      );

      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      // Auth responses carry access/refresh tokens — never print them, even in debug.
      final String prettyJson =
          isSensitiveAuthPath(response.requestOptions.path)
          ? '[REDACTED — auth response body]'
          : encoder.convert(response.data);
      log.d(
        '◀ ︎RESPONSE ${response.statusCode} ${response.requestOptions.baseUrl}${response.requestOptions.path}\n\n'
        'Headers:\n'
        '$headerMessage\n'
        '❖ Results : \n'
        'Response: $prettyJson',
      );
    }
    super.onResponse(response, handler);
  }
}

// coverage:ignore-end
