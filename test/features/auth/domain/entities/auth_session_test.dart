import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/auth/auth.dart';

void main() {
  const user = AuthUser(
    id: 'id-1',
    name: 'Test User',
    email: 'user@mock.com',
    role: 'user',
    isActive: true,
    createdAt: '2025-06-01T00:00:00Z',
    updatedAt: '2025-06-01T00:00:00Z',
  );

  group('AuthSession entity', () {
    const session = AuthSession(
      user: user,
      accessToken: 'access',
      refreshToken: 'refresh',
    );

    test('stores user and token pair', () {
      expect(session.user, user);
      expect(session.accessToken, 'access');
      expect(session.refreshToken, 'refresh');
    });

    test('equality and copyWith', () {
      const same = AuthSession(
        user: user,
        accessToken: 'access',
        refreshToken: 'refresh',
      );
      expect(session, equals(same));

      final copy = session.copyWith(accessToken: 'new');
      expect(copy.accessToken, 'new');
      expect(copy, isNot(equals(session)));
    });
  });
}
