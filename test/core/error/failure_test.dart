import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  group('Failure', () {
    test('CacheFailure equality and hashCode', () {
      const failure1 = CacheFailure();
      const failure2 = CacheFailure();

      expect(failure1, equals(failure2));
      expect(failure1.hashCode, equals(failure2.hashCode));
    });

    test('message-carrying failures compare by message', () {
      expect(const ConflictFailure('x'), equals(const ConflictFailure('x')));
      expect(const ConflictFailure('x'), isNot(const ConflictFailure('y')));
      // Different subtypes are never equal even when value-empty.
      expect(const ConflictFailure(), isNot(const CacheFailure()));
    });

    test('BackupFailure compares by reason', () {
      expect(
        const BackupFailure(BackupFailureReason.corrupt),
        equals(const BackupFailure(BackupFailureReason.corrupt)),
      );
      expect(
        const BackupFailure(BackupFailureReason.corrupt),
        isNot(const BackupFailure(BackupFailureReason.io)),
      );
    });
  });
}
