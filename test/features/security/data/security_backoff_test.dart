import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/security/data/security_backoff.dart';

/// Locks the wrong-PIN backoff curve — 0/0/30s/1m/5m then a 15m cap that NEVER
/// escalates to a permanent lockout — plus the cooldown boundary.
void main() {
  group('backoffFor', () {
    test('first 2 wrong PINs are free', () {
      expect(backoffFor(0), Duration.zero);
      expect(backoffFor(1), Duration.zero);
      expect(backoffFor(2), Duration.zero);
    });

    test('escalates 30s / 1m / 5m', () {
      expect(backoffFor(3), const Duration(seconds: 30));
      expect(backoffFor(4), const Duration(minutes: 1));
      expect(backoffFor(5), const Duration(minutes: 5));
    });

    test('caps at 15m and never escalates further — no permanent lockout', () {
      expect(backoffFor(6), const Duration(minutes: 15));
      expect(backoffFor(7), const Duration(minutes: 15));
      expect(backoffFor(100), const Duration(minutes: 15));
      // The cap is a bounded Duration, never "forever".
      expect(backoffFor(1000000), const Duration(minutes: 15));
    });
  });

  group('isInCooldown', () {
    final now = DateTime.fromMillisecondsSinceEpoch(1000);

    test('null locked-until is never in cooldown', () {
      expect(isInCooldown(now, null), isFalse);
    });

    test('now before until is in cooldown', () {
      expect(isInCooldown(now, 2000), isTrue);
    });

    test('boundary now == until is NOT in cooldown (just lifted)', () {
      expect(isInCooldown(now, 1000), isFalse);
    });

    test('now after until is not in cooldown', () {
      expect(isInCooldown(now, 500), isFalse);
    });
  });
}
