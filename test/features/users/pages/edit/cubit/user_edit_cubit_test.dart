import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

import '../../../../../helpers/mocks.dart';

void main() {
  late UserEditCubit cubit;
  late MockUpdateUser mockUpdateUser;
  late MockDeleteUser mockDeleteUser;
  late MockUploadService mockUploadService;

  const tUser = User(
    id: 'u1',
    name: 'New',
    email: 'a@b.com',
    role: 'user',
    isActive: true,
    createdAt: 'c',
    updatedAt: 'u',
  );

  setUp(() {
    mockUpdateUser = MockUpdateUser();
    mockDeleteUser = MockDeleteUser();
    mockUploadService = MockUploadService();
    cubit = UserEditCubit(mockUpdateUser, mockDeleteUser, mockUploadService);
  });

  tearDown(() => cubit.close());

  test('initial state is initial', () {
    expect(cubit.state, const UserEditState.initial());
  });

  blocTest<UserEditCubit, UserEditState>(
    'submit emits [submitting, success] on update success',
    build: () {
      when(
        () => mockUpdateUser.call(any()),
      ).thenAnswer((_) async => const Right(tUser));
      return cubit;
    },
    act: (c) => c.submit('u1', name: 'New'),
    expect: () => const [
      UserEditState.submitting(),
      UserEditState.success(tUser),
    ],
    verify: (_) {
      verify(
        () =>
            mockUpdateUser.call(const UpdateUserParams(id: 'u1', name: 'New')),
      ).called(1);
    },
  );

  blocTest<UserEditCubit, UserEditState>(
    'submit emits [submitting, failure] on update failure',
    build: () {
      when(
        () => mockUpdateUser.call(any()),
      ).thenAnswer((_) async => const Left(ValidationFailure(message: 'v')));
      return cubit;
    },
    act: (c) => c.submit('u1', name: 'New'),
    expect: () => const [
      UserEditState.submitting(),
      UserEditState.failure(ValidationFailure(message: 'v')),
    ],
  );

  blocTest<UserEditCubit, UserEditState>(
    'delete emits [submitting, deleted] on success',
    build: () {
      when(
        () => mockDeleteUser.call('u1'),
      ).thenAnswer((_) async => const Right(null));
      return cubit;
    },
    act: (c) => c.delete('u1'),
    expect: () => const [UserEditState.submitting(), UserEditState.deleted()],
  );

  blocTest<UserEditCubit, UserEditState>(
    'delete emits [submitting, failure] on failure',
    build: () {
      when(
        () => mockDeleteUser.call('u1'),
      ).thenAnswer((_) async => const Left(ForbiddenFailure('no')));
      return cubit;
    },
    act: (c) => c.delete('u1'),
    expect: () => const [
      UserEditState.submitting(),
      UserEditState.failure(ForbiddenFailure('no')),
    ],
  );

  test('pickAndUploadAvatar delegates to UploadService', () async {
    when(
      () => mockUploadService.pickAndUploadImage(),
    ).thenAnswer((_) async => const Right('/uploads/a.png'));

    final result = await cubit.pickAndUploadAvatar();

    expect(result, const Right<Failure, String?>('/uploads/a.png'));
    verify(() => mockUploadService.pickAndUploadImage()).called(1);
  });
}
