import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';
import 'package:jaga_saku/features/settings/pages/user_information/cubit/cubit.dart';
import 'package:jaga_saku/features/users/users.dart';

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late MockGetCurrentUser getCurrentUser;
  late MockUpdateUser updateUser;

  const user = AuthUser(
    id: 'u1',
    name: 'Old Name',
    email: 'a@b.com',
    role: 'user',
    isActive: true,
    createdAt: '',
    updatedAt: '',
  );
  const updated = User(
    id: 'u1',
    name: 'New Name',
    email: 'a@b.com',
    role: 'user',
    isActive: true,
    createdAt: '',
    updatedAt: '',
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const UpdateUserParams(id: 'u1'));
  });

  setUp(() {
    getCurrentUser = MockGetCurrentUser();
    updateUser = MockUpdateUser();
  });

  blocTest<EditNameCubit, EditNameState>(
    'load emits [loading, loaded] with the current name',
    build: () {
      when(
        () => getCurrentUser.call(any()),
      ).thenAnswer((_) async => const Right(user));
      return EditNameCubit(getCurrentUser, updateUser);
    },
    act: (c) => c.load(),
    expect: () => const [
      EditNameState.loading(),
      EditNameState.loaded('Old Name'),
    ],
  );

  blocTest<EditNameCubit, EditNameState>(
    'load emits failure when /me fails',
    build: () {
      when(
        () => getCurrentUser.call(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('boom')));
      return EditNameCubit(getCurrentUser, updateUser);
    },
    act: (c) => c.load(),
    expect: () => const [
      EditNameState.loading(),
      EditNameState.failure(ServerFailure('boom')),
    ],
  );

  blocTest<EditNameCubit, EditNameState>(
    'submit emits [submitting, success] after load',
    build: () {
      when(
        () => getCurrentUser.call(any()),
      ).thenAnswer((_) async => const Right(user));
      when(
        () => updateUser.call(any()),
      ).thenAnswer((_) async => const Right(updated));
      return EditNameCubit(getCurrentUser, updateUser);
    },
    act: (c) async {
      await c.load();
      await c.submit('New Name');
    },
    expect: () => const [
      EditNameState.loading(),
      EditNameState.loaded('Old Name'),
      EditNameState.submitting(),
      EditNameState.success(),
    ],
    verify: (_) => verify(
      () => updateUser.call(const UpdateUserParams(id: 'u1', name: 'New Name')),
    ).called(1),
  );

  blocTest<EditNameCubit, EditNameState>(
    'submit is a no-op before load (no user id captured)',
    build: () => EditNameCubit(getCurrentUser, updateUser),
    act: (c) => c.submit('New Name'),
    expect: () => const <EditNameState>[],
    verify: (_) => verifyNever(() => updateUser.call(any())),
  );
}
