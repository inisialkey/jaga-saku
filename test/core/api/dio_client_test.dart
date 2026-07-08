import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../helpers/fake_path_provider_platform.dart';

void main() {
  late DioAdapter dioAdapter;
  late DioClient client;

  const path = '/probe';

  Map<String, dynamic> errorEnvelope(String code, {String message = 'boom'}) =>
      {
        'success': false,
        'message': message,
        'errors': null,
        'error_code': code,
        'request_id': 'req_test',
      };

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(isUnitTest: true, prefixBox: 'dio_client_test_');
    client = sl<DioClient>();
    dioAdapter = DioAdapter(dio: client.dio);
  });

  Future<Failure?> failureFor(int status, Map<String, dynamic> body) async {
    dioAdapter.onGet(path, (server) => server.reply(status, body));
    final result = await client.getRequest<String>(
      path,
      converter: (data) => data.toString(),
    );
    return result.fold((l) => l, (_) => null);
  }

  group('_mapDioException error_code dispatch', () {
    test('AUTH_INVALID_CREDENTIALS -> UnauthorizedFailure', () async {
      final failure = await failureFor(
        401,
        errorEnvelope('AUTH_INVALID_CREDENTIALS', message: 'bad creds'),
      );
      expect(failure, isA<UnauthorizedFailure>());
      expect((failure! as UnauthorizedFailure).message, equals('bad creds'));
    });

    test('AUTHORIZATION_FORBIDDEN -> ForbiddenFailure', () async {
      final failure = await failureFor(
        403,
        errorEnvelope('AUTHORIZATION_FORBIDDEN'),
      );
      expect(failure, isA<ForbiddenFailure>());
    });

    test('RESOURCE_NOT_FOUND -> NotFoundFailure', () async {
      final failure = await failureFor(
        404,
        errorEnvelope('RESOURCE_NOT_FOUND'),
      );
      expect(failure, isA<NotFoundFailure>());
    });

    test('VALIDATION_ERROR -> ValidationFailure with field errors', () async {
      dioAdapter.onGet(
        path,
        (server) => server.reply(422, {
          'success': false,
          'message': 'invalid',
          'errors': {
            'email': ['is required'],
          },
          'error_code': 'VALIDATION_ERROR',
          'request_id': 'req_test',
        }),
      );
      final result = await client.getRequest<String>(
        path,
        converter: (data) => data.toString(),
      );
      final failure = result.fold((l) => l, (_) => null);
      expect(failure, isA<ValidationFailure>());
      expect(
        (failure! as ValidationFailure).fieldErrors?['email'],
        equals(['is required']),
      );
    });

    test('RATE_LIMIT_EXCEEDED -> RateLimitFailure', () async {
      final failure = await failureFor(
        429,
        errorEnvelope('RATE_LIMIT_EXCEEDED'),
      );
      expect(failure, isA<RateLimitFailure>());
    });

    test('MAINTENANCE_MODE -> MaintenanceFailure', () async {
      final failure = await failureFor(503, errorEnvelope('MAINTENANCE_MODE'));
      expect(failure, isA<MaintenanceFailure>());
    });

    test('FORCE_UPDATE_REQUIRED -> ForceUpdateFailure', () async {
      final failure = await failureFor(
        426,
        errorEnvelope('FORCE_UPDATE_REQUIRED'),
      );
      expect(failure, isA<ForceUpdateFailure>());
    });

    test('unknown / unmapped error_code -> ServerFailure', () async {
      final failure = await failureFor(
        400,
        errorEnvelope('SOMETHING_NEW', message: 'odd'),
      );
      expect(failure, isA<ServerFailure>());
      expect((failure! as ServerFailure).message, equals('odd'));
    });

    test('non-Map error body -> ServerFailure', () async {
      dioAdapter.onGet(path, (server) => server.reply(500, 'plain text error'));
      final result = await client.getRequest<String>(
        path,
        converter: (data) => data.toString(),
      );
      final failure = result.fold((l) => l, (_) => null);
      expect(failure, isA<ServerFailure>());
    });
  });
}
