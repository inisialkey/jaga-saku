import 'package:jaga_saku/core/utils/converters/bool_from_int_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const converter = BoolFromIntConverter();

  group('BoolFromIntConverter.fromJson', () {
    test('passes through native booleans', () {
      expect(converter.fromJson(true), isTrue);
      expect(converter.fromJson(false), isFalse);
    });

    test('maps SQLite-style integers (1/0)', () {
      expect(converter.fromJson(1), isTrue);
      expect(converter.fromJson(0), isFalse);
    });

    test('treats any non-zero number as true', () {
      expect(converter.fromJson(2), isTrue);
      expect(converter.fromJson(-1), isTrue);
      expect(converter.fromJson(1.0), isTrue);
      expect(converter.fromJson(0.0), isFalse);
    });

    test('parses string forms', () {
      expect(converter.fromJson('1'), isTrue);
      expect(converter.fromJson('true'), isTrue);
      expect(converter.fromJson('TRUE'), isTrue);
      expect(converter.fromJson('0'), isFalse);
      expect(converter.fromJson('false'), isFalse);
    });

    test('falls back to false for null / unexpected shapes', () {
      expect(converter.fromJson(null), isFalse);
      expect(converter.fromJson(<String, dynamic>{}), isFalse);
    });
  });

  group('BoolFromIntConverter.toJson', () {
    test('serializes back to a plain bool', () {
      expect(converter.toJson(true), true);
      expect(converter.toJson(false), false);
    });
  });
}
