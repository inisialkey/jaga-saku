import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late GetCurrentUser getCurrentUser;

  const user = AuthUser(
    id: 'id-1',
    name: 'Test User',
    email: 'user@mock.com',
    role: 'user',
    isActive: true,
    createdAt: '2025-06-01T00:00:00Z',
    updatedAt: '2025-06-01T00:00:00Z',
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    getCurrentUser = GetCurrentUser(mockAuthRepository);
  });

  test('returns the current user from the repository', () async {
    when(
      () => mockAuthRepository.getCurrentUser(),
    ).thenAnswer((_) async => const Right(user));

    final result = await getCurrentUser.call(NoParams());

    expect(result, const Right<Failure, AuthUser>(user));
    verify(() => mockAuthRepository.getCurrentUser());
  });
}
