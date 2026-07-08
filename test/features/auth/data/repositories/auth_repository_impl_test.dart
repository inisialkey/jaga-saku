import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/auth/auth.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../helpers/fake_path_provider_platform.dart';
import '../../../../helpers/json_reader.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/paths.dart';

void main() {
  late MockAuthRemoteDatasource mockAuthRemoteDatasource;
  late MockAuthTokenService mockAuthTokenService;
  late AuthRepositoryImpl authRepositoryImpl;
  late AuthResponseModel authResponseModel;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    FlutterSecureStorage.setMockInitialValues({});
    await serviceLocator(
      isUnitTest: true,
      prefixBox: 'auth_repository_impl_test_',
    );
    mockAuthRemoteDatasource = MockAuthRemoteDatasource();
    mockAuthTokenService = MockAuthTokenService();
    authRepositoryImpl = AuthRepositoryImpl(
      mockAuthRemoteDatasource,
      sl(),
      mockAuthTokenService,
    );
    authResponseModel = AuthResponseModel.fromJson(
      (json.decode(jsonReader(pathAuthResponse200))
              as Map<String, dynamic>)['data']
          as Map<String, dynamic>,
    );
  });

  group('login', () {
    const loginParams = LoginParams(
      email: 'user@mock.com',
      password: 'password123',
    );

    test('returns session and saves tokens when call is successful', () async {
      when(
        () => mockAuthRemoteDatasource.login(loginParams),
      ).thenAnswer((_) async => Right(authResponseModel));
      when(
        () => mockAuthTokenService.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final result = await authRepositoryImpl.login(loginParams);

      verify(() => mockAuthRemoteDatasource.login(loginParams));
      verify(
        () => mockAuthTokenService.saveTokens(
          accessToken: authResponseModel.accessToken,
          refreshToken: authResponseModel.refreshToken,
        ),
      );
      expect(result, Right(authResponseModel.toEntity()));
    });

    test('returns failure and skips token save when unsuccessful', () async {
      when(
        () => mockAuthRemoteDatasource.login(loginParams),
      ).thenAnswer((_) async => const Left(UnauthorizedFailure('bad')));

      final result = await authRepositoryImpl.login(loginParams);

      verify(() => mockAuthRemoteDatasource.login(loginParams));
      verifyNever(
        () => mockAuthTokenService.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      );
      expect(result, const Left(UnauthorizedFailure('bad')));
    });
  });

  group('register', () {
    const registerParams = RegisterParams(
      name: 'Test User',
      email: 'user@mock.com',
      password: 'password123',
    );

    test('returns session and saves tokens when call is successful', () async {
      when(
        () => mockAuthRemoteDatasource.register(registerParams),
      ).thenAnswer((_) async => Right(authResponseModel));
      when(
        () => mockAuthTokenService.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final result = await authRepositoryImpl.register(registerParams);

      verify(
        () => mockAuthTokenService.saveTokens(
          accessToken: authResponseModel.accessToken,
          refreshToken: authResponseModel.refreshToken,
        ),
      );
      expect(result, Right(authResponseModel.toEntity()));
    });
  });

  group('logout', () {
    test('clears session and returns Right even if remote fails', () async {
      when(
        () => mockAuthRemoteDatasource.logout(),
      ).thenAnswer((_) async => const Left(ServerFailure('boom')));
      when(() => mockAuthTokenService.clearTokens()).thenAnswer((_) async {});

      final result = await authRepositoryImpl.logout();

      verify(() => mockAuthRemoteDatasource.logout());
      verify(() => mockAuthTokenService.clearTokens());
      expect(result, const Right<Failure, void>(null));
    });
  });

  group('getCurrentUser', () {
    test('returns AuthUser when call is successful', () async {
      when(
        () => mockAuthRemoteDatasource.getCurrentUser(),
      ).thenAnswer((_) async => Right(authResponseModel.user));

      final result = await authRepositoryImpl.getCurrentUser();

      expect(result, Right(authResponseModel.user.toEntity()));
    });

    test('returns failure when call is unsuccessful', () async {
      when(
        () => mockAuthRemoteDatasource.getCurrentUser(),
      ).thenAnswer((_) async => const Left(UnauthorizedFailure('nope')));

      final result = await authRepositoryImpl.getCurrentUser();

      expect(result, const Left(UnauthorizedFailure('nope')));
    });
  });

  group('clearSession', () {
    test('clears tokens', () async {
      when(() => mockAuthTokenService.clearTokens()).thenAnswer((_) async {});

      await authRepositoryImpl.clearSession();

      verify(() => mockAuthTokenService.clearTokens());
    });
  });
}
