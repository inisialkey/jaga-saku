import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late DeleteUser usecase;
  late MockUsersRepository repo;

  setUp(() {
    repo = MockUsersRepository();
    usecase = DeleteUser(repo);
  });

  test('delegates to repository.deleteUser', () async {
    when(
      () => repo.deleteUser('u1'),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase.call('u1');

    expect(result.isRight(), isTrue);
    verify(() => repo.deleteUser('u1')).called(1);
  });

  test('propagates Left(ForbiddenFailure)', () async {
    when(
      () => repo.deleteUser('u1'),
    ).thenAnswer((_) async => const Left(ForbiddenFailure('no')));

    final result = await usecase.call('u1');

    expect(result, const Left<Failure, void>(ForbiddenFailure('no')));
  });
}
