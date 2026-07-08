import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/auth/auth.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../../helpers/fake_path_provider_platform.dart';
import '../../../../../helpers/json_reader.dart';
import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/paths.dart';

void main() {
  late AuthCubit authCubit;
  late AuthSession session;
  late MockLogin mockLogin;
  late MockRegister mockRegister;

  const loginParams = LoginParams(
    email: 'user@mock.com',
    password: 'password123',
  );
  const registerParams = RegisterParams(
    name: 'Test User',
    email: 'user@mock.com',
    password: 'password123',
  );
  const errorMessage = 'Wrong username or password';

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(isUnitTest: true, prefixBox: 'auth_cubit_test_');
    session = AuthResponseModel.fromJson(
      (json.decode(jsonReader(pathAuthResponse200))
              as Map<String, dynamic>)['data']
          as Map<String, dynamic>,
    ).toEntity();
    mockLogin = MockLogin();
    mockRegister = MockRegister();
    authCubit = AuthCubit(mockLogin, mockRegister);
  });

  tearDown(() => authCubit.close());

  test('Initial state should be AuthState.loading', () {
    expect(authCubit.state, const AuthState.loading());
  });

  blocTest<AuthCubit, AuthState>(
    'login success emits loading then success carrying the user',
    build: () {
      when(
        () => mockLogin.call(loginParams),
      ).thenAnswer((_) async => Right(session));
      return authCubit;
    },
    act: (cubit) => cubit.login(loginParams),
    wait: const Duration(milliseconds: 100),
    expect: () => [const AuthState.loading(), AuthState.success(session.user)],
  );

  blocTest<AuthCubit, AuthState>(
    'login failure emits loading then failure',
    build: () {
      when(
        () => mockLogin.call(loginParams),
      ).thenAnswer((_) async => const Left(UnauthorizedFailure(errorMessage)));
      return authCubit;
    },
    act: (cubit) => cubit.login(loginParams),
    wait: const Duration(milliseconds: 100),
    expect: () => const [
      AuthState.loading(),
      AuthState.failure(UnauthorizedFailure(errorMessage)),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'register success emits loading then success carrying the user',
    build: () {
      when(
        () => mockRegister.call(registerParams),
      ).thenAnswer((_) async => Right(session));
      return authCubit;
    },
    act: (cubit) => cubit.register(registerParams),
    wait: const Duration(milliseconds: 100),
    expect: () => [const AuthState.loading(), AuthState.success(session.user)],
  );

  blocTest<AuthCubit, AuthState>(
    'register failure emits loading then failure',
    build: () {
      when(
        () => mockRegister.call(registerParams),
      ).thenAnswer((_) async => const Left(ServerFailure(errorMessage)));
      return authCubit;
    },
    act: (cubit) => cubit.register(registerParams),
    wait: const Duration(milliseconds: 100),
    expect: () => const [
      AuthState.loading(),
      AuthState.failure(ServerFailure(errorMessage)),
    ],
  );
}
