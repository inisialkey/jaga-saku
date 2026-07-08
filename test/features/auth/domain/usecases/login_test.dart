import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/features/auth/auth.dart';

import '../../../../helpers/json_reader.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/paths.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late Login login;
  late AuthSession session;

  const loginParams = LoginParams(
    email: 'user@mock.com',
    password: 'password123',
  );

  setUp(() {
    session = AuthResponseModel.fromJson(
      (json.decode(jsonReader(pathAuthResponse200))
              as Map<String, dynamic>)['data']
          as Map<String, dynamic>,
    ).toEntity();
    mockAuthRepository = MockAuthRepository();
    login = Login(mockAuthRepository);
  });

  test('delegates to the repository and returns the session', () async {
    when(
      () => mockAuthRepository.login(loginParams),
    ).thenAnswer((_) async => Right(session));

    final result = await login.call(loginParams);

    expect(result, equals(Right<dynamic, AuthSession>(session)));
    verify(() => mockAuthRepository.login(loginParams));
  });
}
