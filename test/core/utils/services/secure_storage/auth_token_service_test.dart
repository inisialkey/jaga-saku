import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/utils/services/secure_storage/auth_token_service.dart';

void main() {
  late AuthTokenService authTokenService;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    authTokenService = AuthTokenService();
  });

  group('saveTokens', () {
    test('saves accessToken to secure storage', () async {
      await authTokenService.saveTokens(
        accessToken: 'access123',
        refreshToken: 'refresh456',
      );

      expect(await authTokenService.getAccessToken(), 'access123');
    });

    test('saves refreshToken to secure storage', () async {
      await authTokenService.saveTokens(
        accessToken: 'access123',
        refreshToken: 'refresh456',
      );

      expect(await authTokenService.getRefreshToken(), 'refresh456');
    });

    test('does not write null accessToken', () async {
      await authTokenService.saveTokens(refreshToken: 'refresh456');

      expect(await authTokenService.getAccessToken(), isNull);
    });

    test('does not write null refreshToken', () async {
      await authTokenService.saveTokens(accessToken: 'access123');

      expect(await authTokenService.getRefreshToken(), isNull);
    });
  });

  group('getAccessToken', () {
    test('returns null when no token stored', () async {
      expect(await authTokenService.getAccessToken(), isNull);
    });

    test('returns stored value after save', () async {
      await authTokenService.saveTokens(accessToken: 'mytoken');

      expect(await authTokenService.getAccessToken(), 'mytoken');
    });
  });

  group('getRefreshToken', () {
    test('returns null when no token stored', () async {
      expect(await authTokenService.getRefreshToken(), isNull);
    });

    test('returns stored value after save', () async {
      await authTokenService.saveTokens(refreshToken: 'myrefresh');

      expect(await authTokenService.getRefreshToken(), 'myrefresh');
    });
  });

  group('clearTokens', () {
    test('removes accessToken from secure storage', () async {
      await authTokenService.saveTokens(
        accessToken: 'access123',
        refreshToken: 'refresh456',
      );

      await authTokenService.clearTokens();

      expect(await authTokenService.getAccessToken(), isNull);
    });

    test('removes refreshToken from secure storage', () async {
      await authTokenService.saveTokens(
        accessToken: 'access123',
        refreshToken: 'refresh456',
      );

      await authTokenService.clearTokens();

      expect(await authTokenService.getRefreshToken(), isNull);
    });
  });
}
