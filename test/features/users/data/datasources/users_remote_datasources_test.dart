import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/users/users.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../helpers/fake_path_provider_platform.dart';
import '../../../../helpers/json_reader.dart';
import '../../../../helpers/paths.dart';

void main() {
  late DioAdapter dioAdapter;
  late UsersRemoteDatasourceImpl dataSource;

  const id = '22222222-2222-2222-2222-222222222222';

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(
      isUnitTest: true,
      prefixBox: 'users_remote_datasource_test_',
    );
    dioAdapter = DioAdapter(dio: sl<DioClient>().dio);
    dataSource = UsersRemoteDatasourceImpl(sl<DioClient>(), sl<CacheStore>());
    // Cache persists across tests in the same Hive box — start each clean.
    await sl<CacheStore>().clear();
  });

  group('getUsers', () {
    test('returns a Page<User> with items and pagination meta', () async {
      dioAdapter.onGet(
        ListAPI.users,
        (server) =>
            server.reply(200, json.decode(jsonReader(pathUsersList200))),
        queryParameters: {'page': 1, 'limit': 20},
      );

      final result = await dataSource.getUsers();

      result.fold((l) => fail('expected Right but got $l'), (page) {
        expect(page.items.length, 2);
        expect(page.items.first.email, 'admin@mock.com');
        expect(page.meta.total, 32);
        expect(page.meta.hasNext, isTrue);
      });
    });

    test('forwards search query parameter', () async {
      dioAdapter.onGet(
        ListAPI.users,
        (server) =>
            server.reply(200, json.decode(jsonReader(pathUsersListEmpty200))),
        queryParameters: {'page': 1, 'limit': 20, 'search': 'bob'},
      );

      final result = await dataSource.getUsers(search: 'bob');

      result.fold(
        (l) => fail('expected Right but got $l'),
        (page) => expect(page.items, isEmpty),
      );
    });

    test('returns InternalServerFailure on 500', () async {
      dioAdapter.onGet(
        ListAPI.users,
        (server) => server.reply(500, {
          'success': false,
          'message': 'boom',
          'error_code': 'INTERNAL_SERVER_ERROR',
        }),
        queryParameters: {'page': 1, 'limit': 20},
      );

      final result = await dataSource.getUsers();

      result.fold(
        (l) => expect(l, isA<InternalServerFailure>()),
        (r) => fail('expected Left but got $r'),
      );
    });

    test('serves the cached list when the network fails', () async {
      // Seed the cache as a prior successful default-page fetch would have.
      final envelope =
          json.decode(jsonReader(pathUsersList200)) as Map<String, dynamic>;
      await sl<CacheStore>().write('users_page_1', envelope);

      dioAdapter.onGet(
        ListAPI.users,
        (server) => server.reply(500, {
          'success': false,
          'message': 'boom',
          'error_code': 'INTERNAL_SERVER_ERROR',
        }),
        queryParameters: {'page': 1, 'limit': 20},
      );

      final result = await dataSource.getUsers();

      result.fold(
        (l) => fail('expected cached Right but got $l'),
        (page) => expect(page.items.length, 2),
      );
    });
  });

  group('getUser', () {
    test('returns User on 200', () async {
      dioAdapter.onGet(
        ListAPI.userById(id),
        (server) =>
            server.reply(200, json.decode(jsonReader(pathUserDetail200))),
      );

      final result = await dataSource.getUser(id);

      result.fold(
        (l) => fail('expected Right but got $l'),
        (user) => expect(user.email, 'user@mock.com'),
      );
    });

    test('returns NotFoundFailure on 404', () async {
      dioAdapter.onGet(
        ListAPI.userById(id),
        (server) =>
            server.reply(404, json.decode(jsonReader(pathErrorNotFound404))),
      );

      final result = await dataSource.getUser(id);

      result.fold(
        (l) => expect(l, isA<NotFoundFailure>()),
        (r) => fail('expected Left but got $r'),
      );
    });
  });

  group('updateUser', () {
    test('returns updated User on 200', () async {
      dioAdapter.onPut(
        ListAPI.userById(id),
        (server) =>
            server.reply(200, json.decode(jsonReader(pathUserUpdate200))),
        data: {'name': 'Updated Name'},
      );

      final result = await dataSource.updateUser(id, name: 'Updated Name');

      result.fold(
        (l) => fail('expected Right but got $l'),
        (user) => expect(user.name, 'Updated Name'),
      );
    });
  });

  group('deleteUser', () {
    test('returns Right(void) on 200 with null data', () async {
      dioAdapter.onDelete(
        ListAPI.userById(id),
        (server) =>
            server.reply(200, json.decode(jsonReader(pathUserDelete200))),
      );

      final result = await dataSource.deleteUser(id);

      expect(result.isRight(), isTrue);
    });

    test('returns ForbiddenFailure on 403', () async {
      dioAdapter.onDelete(
        ListAPI.userById(id),
        (server) => server.reply(403, {
          'success': false,
          'message': 'Admin access required',
          'error_code': 'AUTHORIZATION_FORBIDDEN',
        }),
      );

      final result = await dataSource.deleteUser(id);

      expect(result.isLeft(), isTrue);
      result.fold((l) => expect(l, isA<ForbiddenFailure>()), (_) {});
    });
  });
}
