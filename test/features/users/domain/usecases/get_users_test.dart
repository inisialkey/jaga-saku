import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late GetUsers usecase;
  late MockUsersRepository repo;

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
    repo = MockUsersRepository();
    usecase = GetUsers(repo);
  });

  test('delegates to repository.getUsers and returns the page', () async {
    const page = Page<User>(items: [tUser], meta: PaginationMeta(total: 1));
    when(
      () => repo.getUsers(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        search: any(named: 'search'),
      ),
    ).thenAnswer((_) async => const Right(page));

    final result = await usecase.call(const GetUsersParams());

    expect(result, const Right<Failure, Page<User>>(page));
    verify(
      () => repo.getUsers(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        search: any(named: 'search'),
      ),
    ).called(1);
  });

  test('forwards page/limit/search params', () async {
    const page = Page<User>(items: [], meta: PaginationMeta());
    when(
      () => repo.getUsers(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        search: any(named: 'search'),
      ),
    ).thenAnswer((_) async => const Right(page));

    await usecase.call(const GetUsersParams(page: 2, search: 'bob'));

    verify(
      () => repo.getUsers(
        page: 2,
        limit: any(named: 'limit'),
        search: 'bob',
      ),
    ).called(1);
  });

  test('propagates Left(Failure)', () async {
    when(
      () => repo.getUsers(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        search: any(named: 'search'),
      ),
    ).thenAnswer((_) async => const Left(ServerFailure('boom')));

    final result = await usecase.call(const GetUsersParams());

    expect(result, const Left<Failure, Page<User>>(ServerFailure('boom')));
  });
}
