import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';
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

  const authResponseModel = AuthResponseModel(
    user: userModel,
    accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.access.token',
    refreshToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.refresh.token',
    tokenType: 'Bearer',
    expiresIn: 3600,
  );

  test('parses the success envelope data into an AuthResponseModel', () {
    final jsonMap =
        json.decode(jsonReader(pathAuthResponse200)) as Map<String, dynamic>;

    final envelope = ApiResponse<AuthResponseModel>.fromJson(
      jsonMap,
      (data) => AuthResponseModel.fromJson(data! as Map<String, dynamic>),
    );

    expect(envelope.success, isTrue);
    expect(envelope.data, equals(authResponseModel));
  });

  test('fromJson parses the data object directly', () {
    final jsonMap =
        json.decode(jsonReader(pathAuthResponse200)) as Map<String, dynamic>;
    final result = AuthResponseModel.fromJson(
      jsonMap['data'] as Map<String, dynamic>,
    );

    expect(result, equals(authResponseModel));
  });

  test('toJson emits snake_case keys including nested user', () {
    final result = authResponseModel.toJson();

    expect(result['access_token'], authResponseModel.accessToken);
    expect(result['refresh_token'], authResponseModel.refreshToken);
    expect(result['token_type'], 'Bearer');
    expect(result['expires_in'], 3600);
    expect((result['user'] as Map<String, dynamic>)['avatar_url'], isNotNull);
  });

  test('toEntity maps to an AuthSession carrying user + tokens', () {
    final session = authResponseModel.toEntity();

    expect(session.user, userModel.toEntity());
    expect(session.accessToken, authResponseModel.accessToken);
    expect(session.refreshToken, authResponseModel.refreshToken);
  });
}
