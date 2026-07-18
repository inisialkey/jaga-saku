import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';

/// Thin, reusable wrapper around [FlutterSecureStorage] — the single seam for
/// any secret at rest (currently the salted PIN hash + salt, V3-M4). Mirrors how
/// [SettingsService] centralises the `settings` kv, so any future token / key
/// reuses one tested surface. Tests inject a fake [FlutterSecureStorage] through
/// the constructor (no MethodChannel).
///
/// [read] swallows a [PlatformException] and returns `null` — the keystore-reset
/// fail-safe (plan §4-E): an Android auto-backup restore can leave encrypted
/// prefs without their Keystore key, so a later decrypt throws. The opt-in lock
/// has no recovery, so the app must stay usable and let the user re-enroll
/// rather than crash. (flutter_secure_storage v10 also defaults to
/// `resetOnError: true`, wiping on such an error; this catch is belt-and-braces.)
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          // v10's default AndroidOptions already give KeyStore-backed
          // AES-GCM encryption at rest; the old `encryptedSharedPreferences`
          // flag is deprecated (ignored) in v10, so it is omitted to keep
          // `flutter analyze` clean. iOS pins first-unlock accessibility.
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  final FlutterSecureStorage _storage;

  /// Reads [key]; returns `null` when absent or when the platform throws
  /// (keystore-reset fail-safe — see class doc).
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException catch (e, s) {
      log.e('SecureStorage read failed', error: e, stackTrace: s);
      return null;
    }
  }

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<bool> containsKey(String key) => _storage.containsKey(key: key);
}
