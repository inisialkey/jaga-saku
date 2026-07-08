import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';

void main() {
  group('AuthStatusX', () {
    test('returns correct values for AuthStatus.loading', () {
      const status = AuthState.loading();
      expect(status, const AuthState.loading());
    });

    test('returns correct values for AuthStatus.success', () {
      const status = AuthState.success(null);
      expect(status, const AuthState.success(null));
    });

    test('AuthState.success carries an AuthUser', () {
      const user = AuthUser(
        id: 'id-1',
        name: 'Test User',
        email: 'user@mock.com',
        role: 'user',
        isActive: true,
        createdAt: '2025-06-01T00:00:00Z',
        updatedAt: '2025-06-01T00:00:00Z',
      );
      const status = AuthState.success(user);
      expect(status, const AuthState.success(user));
      expect(status, isNot(const AuthState.success(null)));
    });

    test('returns correct values for AuthStatus.failure', () {
      const status = AuthState.failure(ServerFailure(''));
      expect(status, const AuthState.failure(ServerFailure('')));
    });
  });
}
