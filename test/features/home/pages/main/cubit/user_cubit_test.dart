import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/auth/auth.dart';
import 'package:jaga_saku/features/home/home.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../../helpers/fake_path_provider_platform.dart';
import '../../../../../helpers/mocks.dart';

void main() {
  late UserCubit cubit;
  late MockGetCurrentUser mockGetCurrentUser;

  const tUser = AuthUser(
    id: 'u1',
    name: 'Test User',
    email: 'test@example.com',
    role: 'user',
    isActive: true,
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T00:00:00Z',
  );

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(isUnitTest: true, prefixBox: 'user_cubit_test_');
    mockGetCurrentUser = MockGetCurrentUser();
    cubit = UserCubit(mockGetCurrentUser);
  });

  tearDown(() => cubit.close());

  test('initial state is loading', () {
    expect(cubit.state, const UserState.loading());
  });

  blocTest<UserCubit, UserState>(
    'emits [loading, success] when getUser succeeds',
    build: () {
      when(
        () => mockGetCurrentUser.call(any()),
      ).thenAnswer((_) async => const Right(tUser));
      return cubit;
    },
    act: (c) => c.getUser(),
    wait: const Duration(milliseconds: 100),
    expect: () => const [UserState.loading(), UserState.success(tUser)],
  );

  blocTest<UserCubit, UserState>(
    'emits [loading, failure] on ServerFailure',
    build: () {
      when(
        () => mockGetCurrentUser.call(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('server error')));
      return cubit;
    },
    act: (c) => c.getUser(),
    wait: const Duration(milliseconds: 100),
    expect: () => const [
      UserState.loading(),
      UserState.failure(ServerFailure('server error')),
    ],
  );

  blocTest<UserCubit, UserState>(
    'emits [loading, failure] on ConnectionFailure',
    build: () {
      when(
        () => mockGetCurrentUser.call(any()),
      ).thenAnswer((_) async => const Left(ConnectionFailure('no internet')));
      return cubit;
    },
    act: (c) => c.getUser(),
    wait: const Duration(milliseconds: 100),
    expect: () => const [
      UserState.loading(),
      UserState.failure(ConnectionFailure('no internet')),
    ],
  );

  blocTest<UserCubit, UserState>(
    'emits [loading, failure] on SessionExpiredFailure',
    build: () {
      when(
        () => mockGetCurrentUser.call(any()),
      ).thenAnswer((_) async => const Left(SessionExpiredFailure()));
      return cubit;
    },
    act: (c) => c.getUser(),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      const UserState.loading(),
      const UserState.failure(SessionExpiredFailure()),
    ],
  );
}
