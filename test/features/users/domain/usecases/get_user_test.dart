import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late GetUser usecase;
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
    usecase = GetUser(repo);
  });

  test('delegates to repository.getUser', () async {
    when(() => repo.getUser('u1')).thenAnswer((_) async => const Right(tUser));

    final result = await usecase.call('u1');

    expect(result, const Right<Failure, User>(tUser));
    verify(() => repo.getUser('u1')).called(1);
  });

  test('propagates Left(NotFoundFailure)', () async {
    when(
      () => repo.getUser('nope'),
    ).thenAnswer((_) async => const Left(NotFoundFailure('missing')));

    final result = await usecase.call('nope');

    expect(result, const Left<Failure, User>(NotFoundFailure('missing')));
  });
}
