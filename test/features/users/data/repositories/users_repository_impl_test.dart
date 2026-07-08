import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late UsersRepositoryImpl repo;
  late MockUsersRemoteDatasource ds;

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
    ds = MockUsersRemoteDatasource();
    repo = UsersRepositoryImpl(ds);
  });

  group('getUsers', () {
    const page = Page<User>(items: [tUser], meta: PaginationMeta(total: 1));

    test('returns Right(Page) on success', () async {
      when(
        () => ds.getUsers(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          search: any(named: 'search'),
        ),
      ).thenAnswer((_) async => const Right(page));

      final result = await repo.getUsers();

      expect(result, const Right<Failure, Page<User>>(page));
    });

    test('passes through ServerFailure', () async {
      when(
        () => ds.getUsers(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          search: any(named: 'search'),
        ),
      ).thenAnswer((_) async => const Left(ServerFailure('x')));

      final result = await repo.getUsers();

      expect(result, const Left<Failure, Page<User>>(ServerFailure('x')));
    });
  });

  group('getUser', () {
    test('returns Right(User) on success', () async {
      when(() => ds.getUser('u1')).thenAnswer((_) async => const Right(tUser));
      final result = await repo.getUser('u1');
      expect(result, const Right<Failure, User>(tUser));
    });

    test('passes through NotFoundFailure', () async {
      when(
        () => ds.getUser('u1'),
      ).thenAnswer((_) async => const Left(NotFoundFailure('nf')));
      final result = await repo.getUser('u1');
      expect(result, const Left<Failure, User>(NotFoundFailure('nf')));
    });
  });

  group('updateUser', () {
    test('returns Right(User) on success', () async {
      when(
        () => ds.updateUser('u1', name: 'A'),
      ).thenAnswer((_) async => const Right(tUser));

      final result = await repo.updateUser('u1', name: 'A');

      expect(result, const Right<Failure, User>(tUser));
    });

    test('passes through ValidationFailure', () async {
      when(
        () => ds.updateUser('u1'),
      ).thenAnswer((_) async => const Left(ValidationFailure(message: 'v')));

      final result = await repo.updateUser('u1');

      expect(result.isLeft(), isTrue);
    });
  });

  group('deleteUser', () {
    test('returns Right(void) on success', () async {
      when(
        () => ds.deleteUser('u1'),
      ).thenAnswer((_) async => const Right(null));
      final result = await repo.deleteUser('u1');
      expect(result.isRight(), isTrue);
    });

    test('passes through ForbiddenFailure', () async {
      when(
        () => ds.deleteUser('u1'),
      ).thenAnswer((_) async => const Left(ForbiddenFailure('f')));
      final result = await repo.deleteUser('u1');
      expect(result, const Left<Failure, void>(ForbiddenFailure('f')));
    });
  });
}
