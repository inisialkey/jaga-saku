import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/pages/list/account_list_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockGetAccounts getAccounts;
  late MockDeleteAccount deleteAccount;
  late MockArchiveAccount archiveAccount;
  late MockReorderAccounts reorderAccounts;
  late TxChangeNotifier txChanges;

  const a = Account(id: 1, name: 'A', type: AccountType.cash);
  const b = Account(id: 2, name: 'B', type: AccountType.cash);

  setUp(() {
    getAccounts = MockGetAccounts();
    deleteAccount = MockDeleteAccount();
    archiveAccount = MockArchiveAccount();
    reorderAccounts = MockReorderAccounts();
    txChanges = TxChangeNotifier();
  });

  tearDown(() => txChanges.dispose());

  AccountListCubit build() => AccountListCubit(
    getAccounts: getAccounts,
    deleteAccount: deleteAccount,
    archiveAccount: archiveAccount,
    reorderAccounts: reorderAccounts,
    txChangeNotifier: txChanges,
  );

  blocTest<AccountListCubit, AccountListState>(
    'load emits [loading, loaded]',
    setUp: () => when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Account>>([a, b])),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      AccountListState.loading(),
      AccountListState.loaded(items: [a, b]),
    ],
  );

  blocTest<AccountListCubit, AccountListState>(
    'load failure emits [loading, error]',
    setUp: () => when(() => getAccounts(any())).thenAnswer(
      (_) async => const Left<Failure, List<Account>>(CacheFailure()),
    ),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      AccountListState.loading(),
      AccountListState.error(CacheFailure()),
    ],
  );

  blocTest<AccountListCubit, AccountListState>(
    'toggleArchived flips the flag without reloading',
    build: build,
    seed: () => const AccountListState.loaded(items: [a]),
    act: (cubit) => cubit.toggleArchived(),
    expect: () => const [
      AccountListState.loaded(items: [a], showArchived: true),
    ],
  );

  blocTest<AccountListCubit, AccountListState>(
    'archive success archives then reloads',
    setUp: () {
      when(
        () => archiveAccount(any()),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
      when(
        () => getAccounts(any()),
      ).thenAnswer((_) async => const Right<Failure, List<Account>>([a]));
    },
    build: build,
    act: (cubit) => cubit.archive(2, archived: true),
    expect: () => const [
      AccountListState.loading(),
      AccountListState.loaded(items: [a]),
    ],
    verify: (_) => verify(() => archiveAccount(any())).called(1),
  );

  test('delete success returns DeleteOutcome.deleted and reloads', () async {
    when(
      () => deleteAccount(any()),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Account>>([a]));

    final cubit = build();
    final outcome = await cubit.delete(2);

    expect(outcome, DeleteOutcome.deleted);
    verifyNever(() => archiveAccount(any()));
    await cubit.close();
  });

  test(
    'delete blocked archives instead and returns DeleteOutcome.archivedFallback',
    () async {
      when(
        () => deleteAccount(any()),
      ).thenAnswer((_) async => const Left<Failure, Unit>(ConflictFailure()));
      when(
        () => archiveAccount(any()),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
      when(
        () => getAccounts(any()),
      ).thenAnswer((_) async => const Right<Failure, List<Account>>([a]));

      final cubit = build();
      final outcome = await cubit.delete(2);

      expect(outcome, DeleteOutcome.archivedFallback);
      verify(() => archiveAccount(any())).called(1);
      await cubit.close();
    },
  );

  test('a notifier ping triggers a reload (F1 live refresh)', () async {
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Account>>([a]));

    final cubit = build();
    await cubit.load();

    // A reconcile (or any tx write) pings; the list must refresh its balances.
    txChanges.ping();
    await pumpEventQueue();

    // Two loads: the explicit one + the ping-driven refresh.
    verify(() => getAccounts(any())).called(2);
    await cubit.close();
  });

  blocTest<AccountListCubit, AccountListState>(
    'reorder emits the optimistic order and persists the visible ids',
    setUp: () => when(
      () => reorderAccounts(any()),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit)),
    build: build,
    seed: () => const AccountListState.loaded(items: [a, b]),
    act: (cubit) => cubit.reorder(0, 1),
    expect: () => const [
      AccountListState.loaded(items: [b, a]),
    ],
    verify: (_) {
      final captured = verify(() => reorderAccounts(captureAny())).captured;
      expect(captured.single, [2, 1]);
    },
  );

  test('totalBalance sums non-archived balances; 0 for non-loaded states', () {
    const active = Account(
      id: 1,
      name: 'A',
      type: AccountType.cash,
      balance: 100000,
    );
    const archived = Account(
      id: 2,
      name: 'B',
      type: AccountType.cash,
      balance: 50000,
      archived: true,
    );
    const loaded = AccountListState.loaded(items: [active, archived]);

    // Only the active account's balance counts (the archived 50k is dropped).
    expect(loaded.totalBalance, 100000);
    // Non-loaded states fold to zero (no items to sum).
    expect(const AccountListState.initial().totalBalance, 0);
    expect(const AccountListState.loading().totalBalance, 0);
  });
}
