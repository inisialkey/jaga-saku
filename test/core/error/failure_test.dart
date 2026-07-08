import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  group('Failure', () {
    test('ServerFailure equality and hashCode', () {
      const failure1 = ServerFailure('Error message');
      const failure2 = ServerFailure('Error message');
      const failure3 = ServerFailure('Different message');

      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
      expect(failure1.hashCode, equals(failure2.hashCode));
      expect(failure1.hashCode, isNot(equals(failure3.hashCode)));
    });

    test('NoDataFailure equality and hashCode', () {
      const failure1 = NoDataFailure();
      const failure2 = NoDataFailure();

      expect(failure1, equals(failure2));
      expect(failure1.hashCode, equals(failure2.hashCode));
    });

    test('CacheFailure equality and hashCode', () {
      const failure1 = CacheFailure();
      const failure2 = CacheFailure();

      expect(failure1, equals(failure2));
      expect(failure1.hashCode, equals(failure2.hashCode));
    });

    test('message-carrying failures compare by message', () {
      expect(const ConflictFailure('x'), equals(const ConflictFailure('x')));
      expect(const ConflictFailure('x'), isNot(const ConflictFailure('y')));
      expect(
        const InternalServerFailure('boom'),
        equals(const InternalServerFailure('boom')),
      );
      // Different subtypes are never equal even with the same message.
      expect(
        const ConflictFailure('x'),
        isNot(const PayloadTooLargeFailure('x')),
      );
    });

    test('ValidationFailure compares fieldErrors deeply', () {
      const a = ValidationFailure(
        message: 'invalid',
        fieldErrors: {
          'email': ['required'],
        },
      );
      const b = ValidationFailure(
        message: 'invalid',
        fieldErrors: {
          'email': ['required'],
        },
      );
      const c = ValidationFailure(
        message: 'invalid',
        fieldErrors: {
          'email': ['taken'],
        },
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}
