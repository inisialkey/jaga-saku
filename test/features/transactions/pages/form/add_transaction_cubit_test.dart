import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockSaveTransaction saveTransaction;
  late MockGetAccounts getAccounts;
  late MockGetCategories getCategories;
  late MockGetBudgetsForPeriod getBudgets;
  late MockTxChangeNotifier txChangeNotifier;

  // A current-month date so the budget guard runs (period matches "now").
  final now = DateTime.now();
  final todayMillis = DateTime(
    now.year,
    now.month,
    now.day,
  ).millisecondsSinceEpoch;
  final currentPeriod = periodKey(now);

  setUp(() {
    saveTransaction = MockSaveTransaction();
    getAccounts = MockGetAccounts();
    getCategories = MockGetCategories();
    getBudgets = MockGetBudgetsForPeriod();
    txChangeNotifier = MockTxChangeNotifier();
    // No budget by default → expenses save straight through.
    when(
      () => getBudgets(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Budget>>([]));
  });

  AddTransactionCubit build() => AddTransactionCubit(
    saveTransaction: saveTransaction,
    getAccounts: getAccounts,
    getCategories: getCategories,
    getBudgetsForPeriod: getBudgets,
    txChangeNotifier: txChangeNotifier,
  );

  test('seeds fields from the initial transaction when editing', () {
    final cubit = AddTransactionCubit(
      saveTransaction: saveTransaction,
      getAccounts: getAccounts,
      getCategories: getCategories,
      getBudgetsForPeriod: getBudgets,
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

  test('seeds a NEW tx from a prefill favorite (isEditing false, today)', () {
    final cubit = AddTransactionCubit(
      saveTransaction: saveTransaction,
      getAccounts: getAccounts,
      getCategories: getCategories,
      getBudgetsForPeriod: getBudgets,
      txChangeNotifier: txChangeNotifier,
      prefill: const TxTemplate(
        label: 'Coffee',
        type: TransactionType.expense,
        accountId: 3,
        amount: 15000,
        categoryId: 2,
        plannedStatus: PlannedStatus.planned,
        spendingType: SpendingType.need,
        note: 'Kopi',
      ),
    );

    // A prefill is a brand-new tx, not an edit — the #1 behavior-break guard.
    expect(cubit.state.isEditing, isFalse);
    expect(cubit.state.type, TransactionType.expense);
    expect(cubit.state.amount, 15000);
    expect(cubit.state.accountId, 3);
    expect(cubit.state.categoryId, 2);
    expect(cubit.state.plannedStatus, PlannedStatus.planned);
    expect(cubit.state.spendingType, SpendingType.need);
    expect(cubit.state.note, 'Kopi');
    expect(cubit.state.date, todayMillis);
  });

  test('an amount-less prefill seeds amount 0', () {
    final cubit = AddTransactionCubit(
      saveTransaction: saveTransaction,
      getAccounts: getAccounts,
      getCategories: getCategories,
      getBudgetsForPeriod: getBudgets,
      txChangeNotifier: txChangeNotifier,
      prefill: const TxTemplate(
        label: 'Ask each time',
        type: TransactionType.expense,
        accountId: 1,
        categoryId: 1,
      ),
    );

    expect(cubit.state.amount, 0);
    expect(cubit.state.isEditing, isFalse);
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

  // ── Budget-guard retrofit (plan §5) ─────────────────────────────────────────

  blocTest<AddTransactionCubit, AddTransactionState>(
    'expense over the category safe-daily pauses with needsBudgetConfirm (no save)',
    setUp: () => when(() => getBudgets(any())).thenAnswer(
      // Current-month budget, full 100k limit unspent → any daily allowance is
      // <= 100k, so a 200k expense always breaches it.
      (_) async => Right<Failure, List<Budget>>([
        Budget(categoryId: 1, period: currentPeriod, limitAmount: 100000),
      ]),
    ),
    build: build,
    seed: () => AddTransactionState(
      amount: 200000,
      accountId: 1,
      categoryId: 1,
      date: todayMillis,
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      isA<AddTransactionState>().having(
        (s) => s.status,
        'status',
        AddTxStatus.needsBudgetConfirm,
      ),
    ],
    verify: (_) => verifyNever(() => saveTransaction(any())),
  );

  blocTest<AddTransactionCubit, AddTransactionState>(
    'confirmSave commits the paused expense and pings',
    setUp: () => when(
      () => saveTransaction(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(1)),
    build: build,
    seed: () => const AddTransactionState(
      amount: 200000,
      accountId: 1,
      categoryId: 1,
      status: AddTxStatus.needsBudgetConfirm,
      safeDaily: 3000,
    ),
    act: (cubit) => cubit.confirmSave(),
    expect: () => [
      isA<AddTransactionState>().having(
        (s) => s.status,
        'status',
        AddTxStatus.saving,
      ),
      isA<AddTransactionState>().having(
        (s) => s.status,
        'status',
        AddTxStatus.success,
      ),
    ],
    verify: (_) {
      verify(() => saveTransaction(any())).called(1);
      verify(() => txChangeNotifier.ping()).called(1);
    },
  );

  blocTest<AddTransactionCubit, AddTransactionState>(
    'dismissBudgetConfirm re-arms to editing and never saves',
    build: build,
    seed: () => const AddTransactionState(
      amount: 200000,
      accountId: 1,
      categoryId: 1,
      status: AddTxStatus.needsBudgetConfirm,
      safeDaily: 3000,
    ),
    act: (cubit) => cubit.dismissBudgetConfirm(),
    expect: () => [
      isA<AddTransactionState>().having(
        (s) => s.status,
        'status',
        AddTxStatus.editing,
      ),
    ],
    // "Ubah Nominal" only clears the pause — the expense is not committed.
    verify: (_) => verifyNever(() => saveTransaction(any())),
  );

  blocTest<AddTransactionCubit, AddTransactionState>(
    'expense with no budget for its category saves straight through',
    setUp: () => when(
      () => saveTransaction(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(1)),
    build: build,
    seed: () => AddTransactionState(
      amount: 5000,
      accountId: 1,
      categoryId: 1,
      date: todayMillis,
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      isA<AddTransactionState>().having(
        (s) => s.status,
        'status',
        AddTxStatus.saving,
      ),
      isA<AddTransactionState>().having(
        (s) => s.status,
        'status',
        AddTxStatus.success,
      ),
    ],
    verify: (_) {
      // The guard checked the budget (found none) then saved.
      verify(() => getBudgets(any())).called(1);
      verify(() => saveTransaction(any())).called(1);
    },
  );

  blocTest<AddTransactionCubit, AddTransactionState>(
    'income never warns even with a budget on that category',
    setUp: () {
      when(() => getBudgets(any())).thenAnswer(
        (_) async => Right<Failure, List<Budget>>([
          Budget(categoryId: 1, period: currentPeriod, limitAmount: 1),
        ]),
      );
      when(
        () => saveTransaction(any()),
      ).thenAnswer((_) async => const Right<Failure, int>(1));
    },
    build: build,
    seed: () => AddTransactionState(
      type: TransactionType.income,
      amount: 200000,
      accountId: 1,
      categoryId: 1,
      date: todayMillis,
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      isA<AddTransactionState>().having(
        (s) => s.status,
        'status',
        AddTxStatus.saving,
      ),
      isA<AddTransactionState>().having(
        (s) => s.status,
        'status',
        AddTxStatus.success,
      ),
    ],
    verify: (_) {
      // Non-expense skips the budget read entirely.
      verifyNever(() => getBudgets(any()));
      verify(() => saveTransaction(any())).called(1);
    },
  );
}
