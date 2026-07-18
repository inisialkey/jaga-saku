import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/security/data/models/pin_hasher.dart';

/// Proves the salted-SHA-256 PIN hash round-trips, rejects a wrong PIN, and that
/// salts are unique — the security-critical invariant that the PIN is never
/// recoverable from what is stored.
void main() {
  const hasher = PinHasher();

  test('same pin + salt hashes equal; verify accepts the correct pin', () {
    final salt = hasher.newSalt();
    final h = hasher.hash('123456', salt);

    expect(hasher.hash('123456', salt), h);
    expect(hasher.verify('123456', salt: salt, hash: h), isTrue);
  });

  test('a different salt yields a different hash for the same pin', () {
    final h1 = hasher.hash('123456', hasher.newSalt());
    final h2 = hasher.hash('123456', hasher.newSalt());

    expect(h1, isNot(h2));
  });

  test('wrong pin fails verification', () {
    final salt = hasher.newSalt();
    final h = hasher.hash('123456', salt);

    expect(hasher.verify('654321', salt: salt, hash: h), isFalse);
  });

  test('newSalt is unique across many calls', () {
    final salts = List.generate(100, (_) => hasher.newSalt());

    expect(salts.toSet().length, 100);
  });

  test('hash is 64-char lowercase hex (sha256)', () {
    final h = hasher.hash('123456', hasher.newSalt());

    expect(h, matches(RegExp(r'^[0-9a-f]{64}$')));
  });
}
