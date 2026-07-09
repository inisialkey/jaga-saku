import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/utils/ext/map.dart';

void main() {
  group('MapExtension.validate', () {
    test('is true when every value is true', () {
      expect({'name': true, 'email': true}.validate(), isTrue);
    });

    test('is false when any value is false', () {
      expect({'name': true, 'email': false}.validate(), isFalse);
    });

    test('is false for an empty map', () {
      expect(<String, bool>{}.validate(), isFalse);
    });
  });
}
