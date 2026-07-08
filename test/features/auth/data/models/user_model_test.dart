import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/auth/auth.dart';

import '../../../../helpers/json_reader.dart';
import '../../../../helpers/paths.dart';

void main() {
  const userModel = UserModel(
    id: '93f2f838-1313-4072-b447-3cfc4362b861',
    name: 'Test User',
    email: 'user@mock.com',
    phone: '+6281234567891',
    avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=user',
    role: 'user',
    isActive: true,
    createdAt: '2025-06-01T09:32:39.846Z',
    updatedAt: '2025-06-01T09:32:39.846Z',
  );

  test('fromJson parses the /auth/me data object into a UserModel', () {
    final envelope =
        json.decode(jsonReader(pathMeResponse200)) as Map<String, dynamic>;
    final result = UserModel.fromJson(envelope['data'] as Map<String, dynamic>);

    expect(result, equals(userModel));
  });

  test('toJson emits snake_case keys', () {
    final result = userModel.toJson();

    expect(result['avatar_url'], userModel.avatarUrl);
    expect(result['is_active'], true);
    expect(result['created_at'], userModel.createdAt);
    expect(result['updated_at'], userModel.updatedAt);
  });

  test('toEntity maps to the AuthUser domain entity', () {
    final entity = userModel.toEntity();

    expect(
      entity,
      const AuthUser(
        id: '93f2f838-1313-4072-b447-3cfc4362b861',
        name: 'Test User',
        email: 'user@mock.com',
        phone: '+6281234567891',
        avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=user',
        role: 'user',
        isActive: true,
        createdAt: '2025-06-01T09:32:39.846Z',
        updatedAt: '2025-06-01T09:32:39.846Z',
      ),
    );
  });

  test('null phone and avatar_url are tolerated', () {
    final result = UserModel.fromJson({
      'id': 'id-1',
      'name': 'No Avatar',
      'email': 'noavatar@mock.com',
      'phone': null,
      'avatar_url': null,
      'role': 'user',
      'is_active': true,
      'created_at': '2025-06-01T09:32:39.846Z',
      'updated_at': '2025-06-01T09:32:39.846Z',
    });

    expect(result.phone, isNull);
    expect(result.avatarUrl, isNull);
    expect(result.toEntity().phone, isNull);
  });
}
