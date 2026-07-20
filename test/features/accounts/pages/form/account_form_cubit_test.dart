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

  setUp(() {
    saveAccount = MockSaveAccount();
  });

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

  // V5-M1: onboarding's suggestion chips prefill the form with an UNSAVED
  // Account (no id). That is an insert, not an edit — the page must title it
  // "Add Account" and hide the reconcile row (which is a no-op without an id).
  test('an id-less prefill seeds the fields but is NOT editing', () {
    final cubit = AccountFormCubit(
      saveAccount: saveAccount,
      initial: const Account(name: 'BCA', type: AccountType.bank, icon: 'bank'),
    );

    expect(cubit.state.name, 'BCA');
    expect(cubit.state.type, AccountType.bank);
    expect(cubit.state.icon, 'bank');
    expect(cubit.state.isEditing, isFalse);
    // Pristine: the prefill is the seed, so the unsaved-changes guard is quiet.
    expect(cubit.hasEdits, isFalse);
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
    'submit with an empty name emits a failure state and never saves (D1)',
    build: () => AccountFormCubit(saveAccount: saveAccount),
    act: (cubit) => cubit.submit(),
    expect: () => const [AccountFormState(status: AccountFormStatus.failure)],
    verify: (_) => verifyNever(() => saveAccount(any())),
  );

  test('openingBalanceChanged clamps a negative to 0 (C-B)', () {
    final cubit = AccountFormCubit(saveAccount: saveAccount);
    cubit.nameChanged('Cash');
    cubit.openingBalanceChanged(-5000);
    expect(cubit.state.openingBalance, 0);
    // With a name set, a clamped balance means Save is allowed and no negative
    // opening balance can ever persist (the C-B regression).
    expect(cubit.state.isValid, isTrue);
    cubit.openingBalanceChanged(25000);
    expect(cubit.state.openingBalance, 25000);
  });

  test('hasEdits tracks edits from the create + edit seed (D2)', () {
    final create = AccountFormCubit(saveAccount: saveAccount);
    expect(create.hasEdits, isFalse);
    create.nameChanged('Cash');
    expect(create.hasEdits, isTrue);

    final edit = AccountFormCubit(
      saveAccount: saveAccount,
      initial: const Account(id: 1, name: 'BCA', type: AccountType.bank),
    );
    expect(edit.hasEdits, isFalse);
    edit.nameChanged('BNI');
    expect(edit.hasEdits, isTrue);
  });
}
