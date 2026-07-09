import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/utils/converters/bool_from_int_converter.dart';

void main() {
  const converter = BoolFromIntConverter();

  group('BoolFromIntConverter.fromJson', () {
    test('passes through native booleans', () {
      expect(converter.fromJson(true), isTrue);
      expect(converter.fromJson(false), isFalse);
    });

    test('maps SQLite-style ints (non-zero is true)', () {
      expect(converter.fromJson(1), isTrue);
      expect(converter.fromJson(0), isFalse);
      expect(converter.fromJson(2), isTrue);
    });

    test('maps numeric doubles', () {
      expect(converter.fromJson(1.0), isTrue);
      expect(converter.fromJson(0.0), isFalse);
    });

    test('maps string flags', () {
      expect(converter.fromJson('1'), isTrue);
      expect(converter.fromJson('true'), isTrue);
      expect(converter.fromJson('TRUE'), isTrue);
      expect(converter.fromJson('0'), isFalse);
      expect(converter.fromJson('nope'), isFalse);
    });

    test('defaults null / unknown types to false', () {
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
