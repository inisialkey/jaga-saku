import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  group('ApiResponse.fromJson', () {
    test('parses a success envelope with an object data payload', () {
      final result = ApiResponse<Map<String, dynamic>>.fromJson(const {
        'success': true,
        'message': 'OK',
        'data': {'id': '1', 'name': 'Ada'},
      }, (json) => json! as Map<String, dynamic>);

      expect(result.success, isTrue);
      expect(result.message, equals('OK'));
      expect(result.data, equals({'id': '1', 'name': 'Ada'}));
      expect(result.meta, isNull);
    });

    test('parses a success envelope with a list payload and meta', () {
      final result = ApiResponse<List<String>>.fromJson(const {
        'success': true,
        'message': 'OK',
        'data': ['a', 'b'],
        'meta': {
          'page': 1,
          'limit': 20,
          'total': 2,
          'total_pages': 1,
          'has_next': false,
          'has_prev': false,
        },
      }, (json) => (json! as List).cast<String>());

      expect(result.data, equals(['a', 'b']));
      expect(result.meta, isA<PaginationMeta>());
      expect(result.meta?.total, equals(2));
      expect(result.meta?.totalPages, equals(1));
    });

    test('defaults success to false and tolerates null data', () {
      final result = ApiResponse<String>.fromJson(const {
        'message': 'logged out',
        'data': null,
      }, (json) => json! as String);

      expect(result.success, isFalse);
      expect(result.data, isNull);
      expect(result.message, equals('logged out'));
    });
  });

  group('ApiErrorResponse.fromJson', () {
    test('reads error_code, message, request_id and field errors', () {
      final result = ApiErrorResponse.fromJson(const {
        'success': false,
        'message': 'Validation failed',
        'errors': {
          'email': ['is required'],
        },
        'error_code': 'VALIDATION_ERROR',
        'request_id': 'req_123',
      });

      expect(result.success, isFalse);
      expect(result.message, equals('Validation failed'));
      expect(result.errorCode, equals('VALIDATION_ERROR'));
      expect(result.requestId, equals('req_123'));
      expect(result.errors?['email'], equals(['is required']));
    });
  });
}
