import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockSaveTransaction saveTransaction;
  late MockGetAccounts getAccounts;
  late MockGetCategories getCategories;
  late MockTxChangeNotifier txChangeNotifier;

  setUp(() {
    saveTransaction = MockSaveTransaction();
    getAccounts = MockGetAccounts();
    getCategories = MockGetCategories();
    txChangeNotifier = MockTxChangeNotifier();
  });

  AddTransactionCubit build() => AddTransactionCubit(
    saveTransaction: saveTransaction,
    getAccounts: getAccounts,
    getCategories: getCategories,
    txChangeNotifier: txChangeNotifier,
  );

  test('seeds fields from the initial transaction when editing', () {
    final cubit = AddTransactionCubit(
      saveTransaction: saveTransaction,
      getAccounts: getAccounts,
      getCategories: getCategories,
      txChangeNotifier: txChangeNotifier,
      initial: const Transaction(
        id: 9,
        type: TransactionType.income,
        amount: 5000,
        accountId: 2,
        categoryId: 7,
        note: 'Salary',
      ),
    );

    expect(cubit.state.type, TransactionType.income);
    expect(cubit.state.amount, 5000);
    expect(cubit.state.accountId, 2);
    expect(cubit.state.categoryId, 7);
    expect(cubit.state.note, 'Salary');
    expect(cubit.state.isEditing, isTrue);
  });

  test('load populates accounts + both category sets', () async {
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Right<Failure, List<Account>>([
        Account(id: 1, name: 'Cash', type: AccountType.cash),
      ]),
    );
    when(() => getCategories(CategoryType.expense)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 1, name: 'Makan', type: CategoryType.expense),
      ]),
    );
    when(() => getCategories(CategoryType.income)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 7, name: 'Gaji', type: CategoryType.income),
      ]),
    );

    final cubit = build();
    await cubit.load();

    expect(cubit.state.accounts.map((a) => a.id), [1]);
    expect(cubit.state.categories.map((c) => c.id), [1, 7]);
    // categoriesForType filters to the active type (expense by default).
    expect(cubit.state.categoriesForType.map((c) => c.id), [1]);
    await cubit.close();
  });

  blocTest<AddTransactionCubit, AddTransactionState>(
    'typeChanged to transfer clears category / planned / spending',
    build: build,
    seed: () => const AddTransactionState(
      amount: 1000,
      accountId: 1,
      categoryId: 1,
      plannedStatus: PlannedStatus.planned,
      spendingType: SpendingType.need,
    ),
    act: (cubit) => cubit.typeChanged(TransactionType.transfer),
    expect: () => const [
      AddTransactionState(
        type: TransactionType.transfer,
        amount: 1000,
        accountId: 1,
      ),
    ],
  );

  blocTest<AddTransactionCubit, AddTransactionState>(
    'submit with amount 0 rejects with amountRequired and never saves',
    build: build,
    // Seed a deterministic state (the unseeded initial carries today's date).
    seed: () => const AddTransactionState(),
    act: (cubit) => cubit.submit(),
    expect: () => const [
      AddTransactionState(
        status: AddTxStatus.failure,
        validation: AddTxValidation.amountRequired,
      ),
    ],
    verify: (_) => verifyNever(() => saveTransaction(any())),
  );

  blocTest<AddTransactionCubit, AddTransactionState>(
    'submit without an account rejects with accountRequired',
    build: build,
    seed: () => const AddTransactionState(amount: 1000),
    act: (cubit) => cubit.submit(),
    expect: () => const [
      AddTransactionState(
        amount: 1000,
        status: AddTxStatus.failure,
        validation: AddTxValidation.accountRequired,
      ),
    ],
    verify: (_) => verifyNever(() => saveTransaction(any())),
  );

  blocTest<AddTransactionCubit, AddTransactionState>(
    'transfer to the same account rejects with transferSameAccount',
    build: build,
    seed: () => const AddTransactionState(
      type: TransactionType.transfer,
      amount: 1000,
      accountId: 1,
      toAccountId: 1,
    ),
    act: (cubit) => cubit.submit(),
    expect: () => const [
      AddTransactionState(
        type: TransactionType.transfer,
        amount: 1000,
        accountId: 1,
        toAccountId: 1,
        status: AddTxStatus.failure,
        validation: AddTxValidation.transferSameAccount,
      ),
    ],
    verify: (_) => verifyNever(() => saveTransaction(any())),
  );

  blocTest<AddTransactionCubit, AddTransactionState>(
    'valid submit emits saving then success',
    setUp: () => when(
      () => saveTransaction(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(1)),
    build: build,
    seed: () =>
        const AddTransactionState(amount: 1000, accountId: 1, categoryId: 1),
    act: (cubit) => cubit.submit(),
    expect: () => const [
      AddTransactionState(
        amount: 1000,
        accountId: 1,
        categoryId: 1,
        status: AddTxStatus.saving,
      ),
      AddTransactionState(
        amount: 1000,
        accountId: 1,
        categoryId: 1,
        status: AddTxStatus.success,
      ),
    ],
    verify: (_) {
      verify(() => saveTransaction(any())).called(1);
      // W2: a successful save pings the shared notifier (Home + Calendar refresh).
      verify(() => txChangeNotifier.ping()).called(1);
    },
  );
}
