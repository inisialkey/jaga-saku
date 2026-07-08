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
  late Register register;
  late AuthSession session;

  const registerParams = RegisterParams(
    name: 'Test User',
    email: 'user@mock.com',
    password: 'password123',
    phone: '+6281234567891',
  );

  setUp(() {
    session = AuthResponseModel.fromJson(
      (json.decode(jsonReader(pathAuthResponse200))
              as Map<String, dynamic>)['data']
          as Map<String, dynamic>,
    ).toEntity();
    mockAuthRepository = MockAuthRepository();
    register = Register(mockAuthRepository);
  });

  test('delegates to the repository and returns the session', () async {
    when(
      () => mockAuthRepository.register(registerParams),
    ).thenAnswer((_) async => Right(session));

    final result = await register.call(registerParams);

    expect(result, equals(Right<dynamic, AuthSession>(session)));
    verify(() => mockAuthRepository.register(registerParams));
  });
}
