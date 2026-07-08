import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  group('uploadedUrlFrom', () {
    test('returns the url from the upload envelope', () {
      expect(
        uploadedUrlFrom({
          'data': {'url': '/uploads/a.png', 'id': '1'},
        }),
        '/uploads/a.png',
      );
    });

    test('null when body or data is not a map', () {
      expect(uploadedUrlFrom(null), isNull);
      expect(uploadedUrlFrom('x'), isNull);
      expect(uploadedUrlFrom(<String, dynamic>{}), isNull);
      expect(uploadedUrlFrom({'data': 'x'}), isNull);
    });

    test('null when url is empty or not a string', () {
      expect(
        uploadedUrlFrom({
          'data': {'url': ''},
        }),
        isNull,
      );
      expect(
        uploadedUrlFrom({
          'data': {'url': 123},
        }),
        isNull,
      );
    });
  });
}
