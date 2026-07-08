import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

import '../../../../../helpers/mocks.dart';

void main() {
  late UsersCubit cubit;
  late MockGetUsers mockGetUsers;

  User user(String id) => User(
    id: id,
    name: 'User $id',
    email: '$id@mock.com',
    role: 'user',
    isActive: true,
    createdAt: 'c',
    updatedAt: 'u',
  );

  Page<User> pageWith(
    List<User> items, {
    required bool hasNext,
    int page = 1,
  }) => Page<User>(
    items: items,
    meta: PaginationMeta(page: page, total: 32, hasNext: hasNext),
  );

  setUp(() {
    mockGetUsers = MockGetUsers();
    cubit = UsersCubit(mockGetUsers);
  });

  tearDown(() => cubit.close());

  test('initial state is initial', () {
    expect(cubit.state, const UsersState.initial());
  });

  blocTest<UsersCubit, UsersState>(
    'fetchFirstPage emits [loading, loaded] on success',
    build: () {
      when(
        () => mockGetUsers.call(any()),
      ).thenAnswer((_) async => Right(pageWith([user('1')], hasNext: true)));
      return cubit;
    },
    act: (c) => c.fetchFirstPage(),
    expect: () => [
      const UsersState.loading(),
      isA<UsersStateLoaded>().having((s) => s.items.length, 'items', 1),
    ],
  );

  blocTest<UsersCubit, UsersState>(
    'fetchFirstPage emits [loading, empty] when no items',
    build: () {
      when(
        () => mockGetUsers.call(any()),
      ).thenAnswer((_) async => Right(pageWith([], hasNext: false)));
      return cubit;
    },
    act: (c) => c.fetchFirstPage(),
    expect: () => const [UsersState.loading(), UsersState.empty()],
  );

  blocTest<UsersCubit, UsersState>(
    'fetchFirstPage emits [loading, failure] on Left',
    build: () {
      when(
        () => mockGetUsers.call(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('boom')));
      return cubit;
    },
    act: (c) => c.fetchFirstPage(),
    expect: () => const [
      UsersState.loading(),
      UsersState.failure(ServerFailure('boom')),
    ],
  );

  blocTest<UsersCubit, UsersState>(
    'loadMore appends the next page items and increments page',
    build: () {
      when(
        () => mockGetUsers.call(const GetUsersParams()),
      ).thenAnswer((_) async => Right(pageWith([user('1')], hasNext: true)));
      when(() => mockGetUsers.call(const GetUsersParams(page: 2))).thenAnswer(
        (_) async => Right(pageWith([user('2')], hasNext: false, page: 2)),
      );
      return cubit;
    },
    act: (c) async {
      await c.fetchFirstPage();
      await c.loadMore();
    },
    expect: () => [
      const UsersState.loading(),
      isA<UsersStateLoaded>().having((s) => s.items.length, 'items', 1),
      isA<UsersStateLoaded>().having(
        (s) => s.isLoadingMore,
        'loadingMore',
        true,
      ),
      isA<UsersStateLoaded>()
          .having((s) => s.items.length, 'items', 2)
          .having((s) => s.page.meta.hasNext, 'hasNext', false),
    ],
    verify: (_) {
      verify(() => mockGetUsers.call(const GetUsersParams())).called(1);
      verify(() => mockGetUsers.call(const GetUsersParams(page: 2))).called(1);
    },
  );

  blocTest<UsersCubit, UsersState>(
    'loadMore is a no-op when the loaded page has no next page',
    build: () {
      when(
        () => mockGetUsers.call(const GetUsersParams()),
      ).thenAnswer((_) async => Right(pageWith([user('1')], hasNext: false)));
      return cubit;
    },
    act: (c) async {
      await c.fetchFirstPage();
      await c.loadMore();
    },
    expect: () => [
      const UsersState.loading(),
      isA<UsersStateLoaded>().having((s) => s.items.length, 'items', 1),
    ],
    verify: (_) {
      verify(() => mockGetUsers.call(const GetUsersParams())).called(1);
      verifyNoMoreInteractions(mockGetUsers);
    },
  );

  blocTest<UsersCubit, UsersState>(
    'loadMore is a no-op when state is not loaded',
    build: () => cubit,
    act: (c) => c.loadMore(),
    expect: () => const <UsersState>[],
    verify: (_) => verifyZeroInteractions(mockGetUsers),
  );

  blocTest<UsersCubit, UsersState>(
    'refresh reloads page 1',
    build: () {
      when(
        () => mockGetUsers.call(const GetUsersParams()),
      ).thenAnswer((_) async => Right(pageWith([user('1')], hasNext: false)));
      return cubit;
    },
    act: (c) => c.refresh(),
    expect: () => [
      isA<UsersStateLoaded>().having((s) => s.items.length, 'items', 1),
    ],
  );

  blocTest<UsersCubit, UsersState>(
    'search resets to page 1 with the new query',
    build: () {
      when(
        () => mockGetUsers.call(const GetUsersParams(search: 'bob')),
      ).thenAnswer((_) async => Right(pageWith([user('1')], hasNext: false)));
      return cubit;
    },
    act: (c) => c.search('bob'),
    expect: () => [
      const UsersState.loading(),
      isA<UsersStateLoaded>().having((s) => s.items.length, 'items', 1),
    ],
    verify: (_) {
      verify(
        () => mockGetUsers.call(const GetUsersParams(search: 'bob')),
      ).called(1);
    },
  );
}
