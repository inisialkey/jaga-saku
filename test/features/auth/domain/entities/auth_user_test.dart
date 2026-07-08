import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/auth/auth.dart';

void main() {
  group('AuthUser entity', () {
    const user = AuthUser(
      id: 'id-1',
      name: 'Test User',
      email: 'user@mock.com',
      phone: '+62',
      avatarUrl: 'http://avatar',
      role: 'user',
      isActive: true,
      createdAt: '2025-06-01T00:00:00Z',
      updatedAt: '2025-06-01T00:00:00Z',
    );

    test('stores fields correctly', () {
      expect(user.id, 'id-1');
      expect(user.name, 'Test User');
      expect(user.email, 'user@mock.com');
      expect(user.phone, '+62');
      expect(user.avatarUrl, 'http://avatar');
      expect(user.role, 'user');
      expect(user.isActive, isTrue);
    });

    test('optional fields default to null', () {
      const minimal = AuthUser(
        id: 'id-2',
        name: 'No Phone',
        email: 'np@mock.com',
        role: 'user',
        isActive: true,
        createdAt: '2025-06-01T00:00:00Z',
        updatedAt: '2025-06-01T00:00:00Z',
      );
      expect(minimal.phone, isNull);
      expect(minimal.avatarUrl, isNull);
    });

    test('equality and copyWith', () {
      final copy = user.copyWith(name: 'Renamed');
      expect(copy.name, 'Renamed');
      expect(copy.id, user.id);
      expect(copy, isNot(equals(user)));
      expect(user.copyWith(), equals(user));
    });
  });
}
