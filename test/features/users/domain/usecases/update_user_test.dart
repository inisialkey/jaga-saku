import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late UpdateUser usecase;
  late MockUsersRepository repo;

  const tUser = User(
    id: 'u1',
    name: 'New Name',
    email: 'a@b.com',
    role: 'user',
    isActive: true,
    createdAt: 'c',
    updatedAt: 'u',
  );

  setUp(() {
    repo = MockUsersRepository();
    usecase = UpdateUser(repo);
  });

  test('delegates to repository.updateUser forwarding fields', () async {
    when(
      () => repo.updateUser('u1', name: 'New Name', phone: '123'),
    ).thenAnswer((_) async => const Right(tUser));

    final result = await usecase.call(
      const UpdateUserParams(id: 'u1', name: 'New Name', phone: '123'),
    );

    expect(result, const Right<Failure, User>(tUser));
    verify(
      () => repo.updateUser('u1', name: 'New Name', phone: '123'),
    ).called(1);
  });

  test('propagates Left(ValidationFailure)', () async {
    when(
      () => repo.updateUser('u1'),
    ).thenAnswer((_) async => const Left(ValidationFailure(message: 'bad')));

    final result = await usecase.call(const UpdateUserParams(id: 'u1'));

    expect(result.isLeft(), isTrue);
  });
}
