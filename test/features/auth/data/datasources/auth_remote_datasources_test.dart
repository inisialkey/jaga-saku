import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/auth/auth.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../helpers/fake_path_provider_platform.dart';
import '../../../../helpers/json_reader.dart';
import '../../../../helpers/paths.dart';

void main() {
  late DioAdapter dioAdapter;
  late AuthRemoteDatasourceImpl dataSource;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(
      isUnitTest: true,
      prefixBox: 'auth_remote_datasource_test_',
    );
    dioAdapter = DioAdapter(dio: sl<DioClient>().dio);
    dataSource = AuthRemoteDatasourceImpl(sl<DioClient>());
  });

  group('login', () {
    const loginParams = LoginParams(
      email: 'user@mock.com',
      password: 'password123',
    );

    test('returns AuthResponseModel when response code is 200', () async {
      dioAdapter.onPost(
        ListAPI.login,
        (server) =>
            server.reply(200, json.decode(jsonReader(pathAuthResponse200))),
        data: {'email': 'user@mock.com', 'password': 'password123'},
      );

      final result = await dataSource.login(loginParams);

      result.fold(
        (l) => fail('expected Right but got $l'),
        (r) => expect(r.accessToken, isNotEmpty),
      );
    });

    test('returns UnauthorizedFailure when response code is 401', () async {
      dioAdapter.onPost(
        ListAPI.login,
        (server) =>
            server.reply(401, json.decode(jsonReader(pathAuthResponse401))),
        data: {'email': 'user@mock.com', 'password': 'password123'},
      );

      final result = await dataSource.login(loginParams);

      result.fold(
        (l) => expect(l, isA<UnauthorizedFailure>()),
        (r) => fail('expected Left but got $r'),
      );
    });
  });

  group('register', () {
    const registerParams = RegisterParams(
      name: 'Test User',
      email: 'user@mock.com',
      password: 'password123',
      phone: '+6281234567891',
    );

    test('returns AuthResponseModel when response code is 201', () async {
      dioAdapter.onPost(
        ListAPI.register,
        (server) =>
            server.reply(201, json.decode(jsonReader(pathAuthResponse200))),
        data: {
          'name': 'Test User',
          'email': 'user@mock.com',
          'password': 'password123',
          'phone': '+6281234567891',
        },
      );

      final result = await dataSource.register(registerParams);

      result.fold(
        (l) => fail('expected Right but got $l'),
        (r) => expect(r.user.email, 'user@mock.com'),
      );
    });

    test('omits phone from the request body when null', () async {
      const noPhone = RegisterParams(
        name: 'Test User',
        email: 'user@mock.com',
        password: 'password123',
      );
      dioAdapter.onPost(
        ListAPI.register,
        (server) =>
            server.reply(201, json.decode(jsonReader(pathAuthResponse200))),
        // Matcher has no `phone` key — the request must omit it, not send null.
        data: {
          'name': 'Test User',
          'email': 'user@mock.com',
          'password': 'password123',
        },
      );

      final result = await dataSource.register(noPhone);

      expect(result.isRight(), isTrue);
    });
  });

  group('logout', () {
    test('returns Right(void) when response code is 200', () async {
      dioAdapter.onPost(
        ListAPI.logout,
        (server) => server.reply(200, {
          'success': true,
          'message': 'Logged out.',
          'data': null,
        }),
      );

      final result = await dataSource.logout();

      expect(result.isRight(), isTrue);
    });
  });

  group('getCurrentUser', () {
    test('returns UserModel when response code is 200', () async {
      dioAdapter.onGet(
        ListAPI.me,
        (server) =>
            server.reply(200, json.decode(jsonReader(pathMeResponse200))),
      );

      final result = await dataSource.getCurrentUser();

      result.fold(
        (l) => fail('expected Right but got $l'),
        (r) => expect(r.email, 'user@mock.com'),
      );
    });
  });
}
