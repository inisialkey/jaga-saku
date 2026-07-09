import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/pages/form/account_form_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockSaveAccount saveAccount;

  setUp(() => saveAccount = MockSaveAccount());

  test('seeds fields from the initial account when editing', () {
    final cubit = AccountFormCubit(
      saveAccount: saveAccount,
      initial: const Account(
        id: 1,
        name: 'BCA',
        type: AccountType.bank,
        openingBalance: 100,
      ),
    );

    expect(cubit.state.name, 'BCA');
    expect(cubit.state.type, AccountType.bank);
    expect(cubit.state.openingBalance, 100);
    expect(cubit.state.isEditing, isTrue);
  });

  blocTest<AccountFormCubit, AccountFormState>(
    'submit success emits saving then success',
    setUp: () => when(
      () => saveAccount(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(1)),
    build: () => AccountFormCubit(saveAccount: saveAccount),
    act: (cubit) {
      cubit.nameChanged('Cash');
      cubit.submit();
    },
    expect: () => const [
      AccountFormState(name: 'Cash'),
      AccountFormState(name: 'Cash', status: AccountFormStatus.saving),
      AccountFormState(name: 'Cash', status: AccountFormStatus.success),
    ],
  );

  blocTest<AccountFormCubit, AccountFormState>(
    'submit failure emits saving then failure with the error',
    setUp: () => when(
      () => saveAccount(any()),
    ).thenAnswer((_) async => const Left<Failure, int>(CacheFailure())),
    build: () => AccountFormCubit(saveAccount: saveAccount),
    act: (cubit) {
      cubit.nameChanged('Cash');
      cubit.submit();
    },
    expect: () => const [
      AccountFormState(name: 'Cash'),
      AccountFormState(name: 'Cash', status: AccountFormStatus.saving),
      AccountFormState(
        name: 'Cash',
        status: AccountFormStatus.failure,
        error: CacheFailure(),
      ),
    ],
  );

  blocTest<AccountFormCubit, AccountFormState>(
    'submit with an empty name does nothing',
    build: () => AccountFormCubit(saveAccount: saveAccount),
    act: (cubit) => cubit.submit(),
    expect: () => const <AccountFormState>[],
    verify: (_) => verifyNever(() => saveAccount(any())),
  );
}
