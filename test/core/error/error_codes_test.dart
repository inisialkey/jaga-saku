import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  group('ApiErrorCode.fromCode', () {
    test('resolves every known wire code to its enum', () {
      for (final value in ApiErrorCode.values) {
        expect(ApiErrorCode.fromCode(value.code), equals(value));
      }
    });

    test('maps a representative code correctly', () {
      expect(
        ApiErrorCode.fromCode('AUTH_TOKEN_EXPIRED'),
        equals(ApiErrorCode.authTokenExpired),
      );
      expect(
        ApiErrorCode.fromCode('VALIDATION_ERROR'),
        equals(ApiErrorCode.validationError),
      );
    });

    test('falls back to unknown for null, empty, and unrecognized', () {
      expect(ApiErrorCode.fromCode(null), equals(ApiErrorCode.unknown));
      expect(ApiErrorCode.fromCode(''), equals(ApiErrorCode.unknown));
      expect(
        ApiErrorCode.fromCode('NOT_A_REAL_CODE'),
        equals(ApiErrorCode.unknown),
      );
    });
  });
}
