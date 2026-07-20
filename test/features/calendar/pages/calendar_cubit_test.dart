import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/calendar/pages/calendar_cubit.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/ledger_fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockGetTransactionsByMonth getByMonth;
  late MockGetTransactionsByDay getByDay;
  late MockDeleteTransaction deleteTransaction;
  late MockGetAccounts getAccounts;
  late MockGetCategories getCategories;
  // Real notifier (a trivial dart:async wrapper) so the subscription wiring is
  // exercised end-to-end.
  late TxChangeNotifier txChanges;

  final tx = Transaction(
    id: 1,
    type: TransactionType.expense,
    amount: 5000,
    accountId: 1,
    categoryId: 1,
    date: DateTime(2026, 7, 8).millisecondsSinceEpoch,
  );

  setUp(() {
    getByMonth = MockGetTransactionsByMonth();
    getByDay = MockGetTransactionsByDay();
    deleteTransaction = MockDeleteTransaction();
    getAccounts = MockGetAccounts();
    getCategories = MockGetCategories();
    txChanges = TxChangeNotifier();
  });

  tearDown(() => txChanges.dispose());

  CalendarCubit build() => CalendarCubit(
    getTransactionsByMonth: getByMonth,
    getTransactionsByDay: getByDay,
    deleteTransaction: deleteTransaction,
    getAccounts: getAccounts,
    getCategories: getCategories,
    txChangeNotifier: txChanges,
  );

  void stubLookups() {
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
    when(
      () => getCategories(CategoryType.income),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([]));
  }

  test('load fills lookups, month dots and the selected-day list', () async {
    stubLookups();
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>([tx]));
    when(
      () => getByDay(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>([tx]));

    final cubit = build();
    await cubit.load();

    expect(cubit.state.status, CalendarStatus.ready);
    expect(cubit.state.monthTransactions, [tx]);
    expect(cubit.state.selectedDayTransactions, [tx]);
    expect(cubit.state.accountsById[1]?.name, 'Cash');
    expect(cubit.state.categoriesById[1]?.name, 'Makan');
    // The tx's day carries a dot.
    expect(cubit.state.transactionsOn(DateTime(2026, 7, 8)), isNotEmpty);
    await cubit.close();
  });

  test('selectDay reloads that day’s transactions', () async {
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getByDay(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>([tx]));

    final cubit = build();
    await cubit.selectDay(DateTime(2026, 7, 10));

    expect(cubit.state.selectedDay, DateTime(2026, 7, 10));
    expect(cubit.state.selectedDayTransactions, [tx]);
    await cubit.close();
  });

  test('deleteTransaction delegates to the usecase', () async {
    when(
      () => deleteTransaction(1),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getByDay(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));

    final cubit = build();
    await cubit.deleteTransaction(1);

    // The transaction repo pings on the delete (V4-M1); this cubit just
    // delegates. The subscription-driven reload is covered by the ping test.
    verify(() => deleteTransaction(1)).called(1);
    await cubit.close();
  });

  test('a notifier ping refreshes the calendar (subscription wired)', () async {
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getByDay(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));

    final cubit = build();
    txChanges.ping();
    await pumpEventQueue();

    // The ping-driven refresh fetched the month + day.
    verify(() => getByMonth(any())).called(1);
    expect(cubit.state.status, CalendarStatus.ready);
    await cubit.close();
  });

  test('a load failure surfaces an error state', () async {
    stubLookups();
    when(() => getByMonth(any())).thenAnswer(
      (_) async => const Left<Failure, List<Transaction>>(CacheFailure()),
    );
    when(
      () => getByDay(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));

    final cubit = build();
    await cubit.load();

    expect(cubit.state.status, CalendarStatus.error);
    expect(cubit.state.failure, isA<CacheFailure>());
    await cubit.close();
  });

  group('day summary money math', () {
    Transaction txOf({
      required TransactionType type,
      required int amount,
      int? toAccountId,
      int? categoryId,
    }) => Transaction(
      type: type,
      amount: amount,
      accountId: 1,
      toAccountId: toAccountId,
      categoryId: categoryId,
      date: DateTime(2026, 7, 8).millisecondsSinceEpoch,
    );

    CalendarState stateWith(List<Transaction> onDay) => CalendarState(
      focusedMonth: DateTime(2026, 7),
      selectedDay: DateTime(2026, 7, 8),
      selectedDayTransactions: onDay,
    );

    test('sums income and expense; the transfer is excluded', () {
      final state = stateWith([
        txOf(type: TransactionType.income, amount: 5000000),
        txOf(type: TransactionType.income, amount: 250000),
        txOf(type: TransactionType.expense, amount: 35000),
        txOf(type: TransactionType.expense, amount: 15000),
        // Internal move — must not leak into income, expense or balance.
        txOf(type: TransactionType.transfer, amount: 1000000, toAccountId: 2),
      ]);

      expect(state.dayIncome, 5250000); // 5_000_000 + 250_000, no transfer
      expect(state.dayExpense, 50000); // 35_000 + 15_000, no transfer
      expect(state.dayBalance, 5200000); // income − expense (transfer nets 0)
    });

    test('a transfer-only day nets to zero across all three', () {
      final state = stateWith([
        txOf(type: TransactionType.transfer, amount: 1000000, toAccountId: 2),
      ]);

      expect(state.dayIncome, 0);
      expect(state.dayExpense, 0);
      expect(state.dayBalance, 0);
    });

    test(
      'a reconcile adjustment on the day is excluded from expense + balance',
      () {
        final state = CalendarState(
          focusedMonth: DateTime(2026, 7),
          selectedDay: DateTime(2026, 7, 8),
          selectedDayTransactions: [
            txOf(type: TransactionType.expense, amount: 35000, categoryId: 1),
            // A reconcile correction tagged the reserved adjustment_out category.
            txOf(type: TransactionType.expense, amount: 20000, categoryId: 8),
          ],
          categoriesById: const {8: penyesuaianOut},
        );

        // V4-M0 fix: the 20k adjustment drops out — only the real 35k expense
        // counts, so the day summary aligns with every other report surface.
        expect(state.dayExpense, 35000);
        expect(state.dayBalance, -35000);
        expect(state.dayIncome, 0);
      },
    );

    // V5-W1: the grid's event dots read `transactionsOn`, the summary reads
    // `dayIncome`/`dayExpense`. They must apply the SAME exclusion or the grid
    // advertises money the day panel then reports as 0 / 0 / 0.
    test('an adjustment-only day carries no dot and a zero summary', () {
      final adjustment = txOf(
        type: TransactionType.expense,
        amount: 20000,
        categoryId: 8,
      );
      final state = CalendarState(
        focusedMonth: DateTime(2026, 7),
        selectedDay: DateTime(2026, 7, 8),
        monthTransactions: [adjustment],
        selectedDayTransactions: [adjustment],
        categoriesById: const {8: penyesuaianOut},
      );

      expect(state.transactionsOn(DateTime(2026, 7, 8)), isEmpty);
      // The summary the dot claims to preview — the two now agree.
      expect(state.dayIncome, 0);
      expect(state.dayExpense, 0);
    });

    test(
      'a real transaction still dots a day that also holds an adjustment',
      () {
        final real = txOf(
          type: TransactionType.expense,
          amount: 35000,
          categoryId: 1,
        );
        final adjustment = txOf(
          type: TransactionType.expense,
          amount: 20000,
          categoryId: 8,
        );
        final state = CalendarState(
          focusedMonth: DateTime(2026, 7),
          selectedDay: DateTime(2026, 7, 8),
          monthTransactions: [real, adjustment],
          categoriesById: const {8: penyesuaianOut},
        );

        // Scoped exclusion, not a blanket one.
        expect(state.transactionsOn(DateTime(2026, 7, 8)), [real]);
      },
    );
  });
}
