import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  group('ListAPI', () {
    test('Auth endpoints', () {
      expect(ListAPI.login, equals('/auth/login'));
      expect(ListAPI.register, equals('/auth/register'));
      expect(ListAPI.refreshToken, equals('/auth/refresh'));
      expect(ListAPI.logout, equals('/auth/logout'));
      expect(ListAPI.me, equals('/auth/me'));
    });

    test('User endpoints', () {
      expect(ListAPI.users, equals('/users'));
      expect(ListAPI.userById('42'), equals('/users/42'));
    });
  });
}
