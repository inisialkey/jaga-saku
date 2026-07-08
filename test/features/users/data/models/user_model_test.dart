import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/users/users.dart';

import '../../../../helpers/json_reader.dart';
import '../../../../helpers/paths.dart';

void main() {
  test('fromJson parses the envelope data object into a UserModel', () {
    final envelope =
        json.decode(jsonReader(pathUserDetail200)) as Map<String, dynamic>;
    final model = UserModel.fromJson(envelope['data'] as Map<String, dynamic>);

    expect(model.id, '22222222-2222-2222-2222-222222222222');
    expect(model.name, 'Test User');
    expect(model.email, 'user@mock.com');
    expect(model.phone, '+6281234567891');
    expect(model.avatarUrl, isNotNull);
    expect(model.role, 'user');
    expect(model.isActive, isTrue);
  });

  test('toJson round-trips snake_case keys', () {
    const model = UserModel(
      id: 'u1',
      name: 'A',
      email: 'a@b.com',
      role: 'user',
      isActive: true,
      createdAt: 'c',
      updatedAt: 'u',
      phone: '123',
      avatarUrl: 'url',
    );
    final map = model.toJson();
    expect(map['is_active'], true);
    expect(map['avatar_url'], 'url');
    expect(map['created_at'], 'c');
  });

  test('toEntity maps to the domain User', () {
    const model = UserModel(
      id: 'u1',
      name: 'A',
      email: 'a@b.com',
      role: 'user',
      isActive: true,
      createdAt: 'c',
      updatedAt: 'u',
      phone: '123',
      avatarUrl: 'url',
    );
    final entity = model.toEntity();
    expect(entity, isA<User>());
    expect(entity.id, 'u1');
    expect(entity.phone, '123');
    expect(entity.avatarUrl, 'url');
    expect(entity.isActive, isTrue);
  });
}
