import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late Logout logout;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    logout = Logout(mockAuthRepository);
  });

  test('delegates logout to the repository', () async {
    when(
      () => mockAuthRepository.logout(),
    ).thenAnswer((_) async => const Right(null));

    final result = await logout.call(NoParams());

    expect(result, const Right<Failure, void>(null));
    verify(() => mockAuthRepository.logout());
  });
}
