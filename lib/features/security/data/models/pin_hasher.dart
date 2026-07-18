import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// The single hashing point for the app-lock PIN (V3-M4). The 6-digit PIN is
/// NEVER stored plaintext — only a per-install random [salt] plus
/// `sha256(salt + pin)` hex are written to secure storage.
///
/// A 6-digit PIN has only ~10^6 combinations, so the real defense is the timed
/// backoff + secure-storage encryption; SHA-256 is defense-in-depth (no
/// bcrypt / argon2 ceremony is warranted for a throttled local numeric PIN).
/// Pure Dart — no platform channel — so it is unit-tested directly.
class PinHasher {
  const PinHasher();

  /// A fresh 16-byte cryptographically-random salt, base64-encoded.
  String newSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Encode(bytes);
  }

  /// `sha256(salt + pin)` as a lowercase hex string.
  String hash(String pin, String salt) =>
      sha256.convert(utf8.encode(salt + pin)).toString();

  /// Whether [pin] hashes (under [salt]) to the stored [hash].
  bool verify(String pin, {required String salt, required String hash}) =>
      this.hash(pin, salt) == hash;
}
