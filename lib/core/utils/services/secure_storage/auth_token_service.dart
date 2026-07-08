import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenService {
  AuthTokenService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            // Android (v10+): the default AndroidOptions uses strong custom
            // ciphers (RSA-OAEP key wrap + AES-GCM); tokens written under the
            // old EncryptedSharedPreferences impl auto-migrate on first access.
            // iOS: only readable after first unlock and never synced to iCloud/
            // device backups.
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'secure_access_token';
  static const _refreshTokenKey = 'secure_refresh_token';

  /// Writes [accessToken] and [refreshToken] to secure storage in parallel.
  /// Passing null clears the corresponding key (flutter_secure_storage
  /// treats write(value: null) as a delete).
  Future<void> saveTokens({String? accessToken, String? refreshToken}) =>
      Future.wait([
        _storage.write(key: _accessTokenKey, value: accessToken),
        _storage.write(key: _refreshTokenKey, value: refreshToken),
      ]);

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> clearTokens() => Future.wait([
    _storage.delete(key: _accessTokenKey),
    _storage.delete(key: _refreshTokenKey),
  ]);
}
