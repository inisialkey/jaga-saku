import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  group('parseRefreshTokens', () {
    test('returns (access, refresh) from a valid envelope', () {
      final result = parseRefreshTokens({
        'data': {'access_token': 'acc', 'refresh_token': 'ref', 'extra': 1},
      });
      expect(result, ('acc', 'ref'));
    });

    test('null when the body is not a map', () {
      expect(parseRefreshTokens(null), isNull);
      expect(parseRefreshTokens('nope'), isNull);
      expect(parseRefreshTokens(42), isNull);
    });

    test('null when data is missing or not a map', () {
      expect(parseRefreshTokens(<String, dynamic>{}), isNull);
      expect(parseRefreshTokens({'data': 'x'}), isNull);
    });

    test('null when either token is missing', () {
      expect(
        parseRefreshTokens({
          'data': {'access_token': 'acc'},
        }),
        isNull,
      );
      expect(
        parseRefreshTokens({
          'data': {'refresh_token': 'ref'},
        }),
        isNull,
      );
    });

    test('null when a token is not a string', () {
      expect(
        parseRefreshTokens({
          'data': {'access_token': 1, 'refresh_token': 'ref'},
        }),
        isNull,
      );
    });
  });

  group('shouldAttemptRefresh', () {
    test('true only for AUTH_TOKEN_EXPIRED', () {
      expect(shouldAttemptRefresh(ApiErrorCode.authTokenExpired), isTrue);
    });

    test('false for every other 401 / unknown code', () {
      const others = [
        ApiErrorCode.authTokenInvalid,
        ApiErrorCode.authRefreshTokenInvalid,
        ApiErrorCode.authInvalidCredentials,
        ApiErrorCode.authAccountDisabled,
        ApiErrorCode.authorizationForbidden,
        ApiErrorCode.unknown,
      ];
      for (final code in others) {
        expect(shouldAttemptRefresh(code), isFalse, reason: '$code');
      }
    });
  });

  group('blockingRouteForCode', () {
    test('maps app-status codes to their full-screen gate routes', () {
      expect(
        blockingRouteForCode(ApiErrorCode.forceUpdateRequired),
        Routes.forceUpdate.path,
      );
      expect(
        blockingRouteForCode(ApiErrorCode.maintenanceMode),
        Routes.maintenance.path,
      );
    });

    test('null for non-gate codes', () {
      const others = [
        ApiErrorCode.authTokenExpired,
        ApiErrorCode.validationError,
        ApiErrorCode.rateLimitExceeded,
        ApiErrorCode.unknown,
      ];
      for (final code in others) {
        expect(blockingRouteForCode(code), isNull, reason: '$code');
      }
    });
  });

  group('redactHeader', () {
    test('masks sensitive headers case-insensitively', () {
      expect(redactHeader('Authorization', 'Bearer abc'), '[REDACTED]');
      expect(redactHeader('x-api-key', 'secret'), '[REDACTED]');
      expect(redactHeader('X-API-KEY', 'secret'), '[REDACTED]');
      expect(redactHeader('Cookie', 'sid=1'), '[REDACTED]');
      expect(redactHeader('set-cookie', 'sid=1'), '[REDACTED]');
      expect(redactHeader('Proxy-Authorization', 'x'), '[REDACTED]');
    });

    test('passes through non-sensitive headers as a string', () {
      expect(
        redactHeader('Content-Type', 'application/json'),
        'application/json',
      );
      expect(redactHeader('Accept', ['a', 'b']), '[a, b]');
    });
  });

  group('isSensitiveAuthPath', () {
    test('true for any /auth/* endpoint', () {
      for (final p in ['/auth/login', '/auth/register', '/auth/refresh']) {
        expect(isSensitiveAuthPath(p), isTrue, reason: p);
      }
    });

    test('false for non-auth endpoints', () {
      for (final p in ['/users', '/users/1', '/config', '/upload']) {
        expect(isSensitiveAuthPath(p), isFalse, reason: p);
      }
    });
  });
}
