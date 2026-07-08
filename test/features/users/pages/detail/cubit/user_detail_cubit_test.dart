import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

import '../../../../../helpers/mocks.dart';

void main() {
  late UserDetailCubit cubit;
  late MockGetUser mockGetUser;

  const tUser = User(
    id: 'u1',
    name: 'A',
    email: 'a@b.com',
    role: 'user',
    isActive: true,
    createdAt: 'c',
    updatedAt: 'u',
  );

  setUp(() {
    mockGetUser = MockGetUser();
    cubit = UserDetailCubit(mockGetUser);
  });

  tearDown(() => cubit.close());

  test('initial state is loading', () {
    expect(cubit.state, const UserDetailState.loading());
  });

  blocTest<UserDetailCubit, UserDetailState>(
    'emits [loading, loaded] on success',
    build: () {
      when(
        () => mockGetUser.call('u1'),
      ).thenAnswer((_) async => const Right(tUser));
      return cubit;
    },
    act: (c) => c.load('u1'),
    expect: () => const [
      UserDetailState.loading(),
      UserDetailState.loaded(tUser),
    ],
  );

  blocTest<UserDetailCubit, UserDetailState>(
    'emits [loading, failure] on Left',
    build: () {
      when(
        () => mockGetUser.call('u1'),
      ).thenAnswer((_) async => const Left(NotFoundFailure('nf')));
      return cubit;
    },
    act: (c) => c.load('u1'),
    expect: () => const [
      UserDetailState.loading(),
      UserDetailState.failure(NotFoundFailure('nf')),
    ],
  );
}
