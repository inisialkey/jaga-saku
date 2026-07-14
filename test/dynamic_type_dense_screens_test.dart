import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/pages/list/budget_list_cubit.dart';
import 'package:jaga_saku/features/budgets/pages/list/budget_list_page.dart';
import 'package:jaga_saku/features/calendar/pages/calendar_cubit.dart';
import 'package:jaga_saku/features/calendar/pages/calendar_page.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/insight/pages/insight_cubit.dart';
import 'package:jaga_saku/features/insight/pages/insight_page.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/mocks.dart';
import 'helpers/pump_app.dart';

/// Dynamic Type smoke tests for the dense, multi-column money screens (Insight /
/// Calendar / Budgets) — the switch's highest horizontal-overflow risk (a height
/// audit can't rule out a wide amount row). Each renders over a real cubit with
/// representative loaded data at the 1.3× clamp ceiling, on a **real phone width
/// (375)** so a RenderFlex horizontal overflow actually throws; the height is
/// tall so the whole vertical list lays out. Asserting `takeException()` isNull
/// locks in "no overflow at max Dynamic Type".
void main() {
  setUpAll(registerFallbackValues);

  const scaler = TextScaler.linear(1.3);
  final now = DateTime.now();
  final thisMonth = DateTime(now.year, now.month);

  // Real phone WIDTH (375, the design width) so 1.3× can trigger a horizontal
  // overflow, but tall enough that the whole vertical list lays out.
  void useDenseSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('Insight recap renders at 1.3× without overflow', (tester) async {
    useDenseSurface(tester);
    final getByMonth = MockGetTransactionsByMonth();
    final getCategories = MockGetCategories();
    final getBudgets = MockGetBudgetsForPeriod();
    final txChanges = TxChangeNotifier();
    addTearDown(txChanges.dispose);

    const expenseCats = [
      Category(
        id: 1,
        name: 'Makanan & Minuman',
        type: CategoryType.expense,
        color: 0xFFEF4444,
      ),
      Category(id: 2, name: 'Transportasi Harian', type: CategoryType.expense),
    ];
    const incomeCats = [
      Category(id: 3, name: 'Gaji Bulanan', type: CategoryType.income),
    ];
    Transaction tx({
      required int amount,
      required int categoryId,
      TransactionType type = TransactionType.expense,
    }) => Transaction(
      type: type,
      amount: amount,
      accountId: 1,
      categoryId: categoryId,
      date: thisMonth.millisecondsSinceEpoch,
    );

    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(() => getByMonth(thisMonth)).thenAnswer(
      (_) async => Right<Failure, List<Transaction>>([
        tx(amount: 12345678, categoryId: 3, type: TransactionType.income),
        tx(amount: 9876543, categoryId: 1),
        tx(amount: 1234567, categoryId: 2),
      ]),
    );
    when(() => getCategories(CategoryType.expense)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>(expenseCats),
    );
    when(
      () => getCategories(CategoryType.income),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>(incomeCats));
    when(
      () => getBudgets(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Budget>>([]));

    final cubit = InsightCubit(
      getTransactionsByMonth: getByMonth,
      getCategories: getCategories,
      getBudgetsForPeriod: getBudgets,
      txChangeNotifier: txChanges,
    );
    addTearDown(cubit.close);
    await pumpApp(
      tester,
      BlocProvider.value(value: cubit, child: const InsightPage()),
      scaffold: false,
      textScaler: scaler,
    );
    await cubit.load(thisMonth);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('Calendar day list renders at 1.3× without overflow', (
    tester,
  ) async {
    useDenseSurface(tester);
    final getByMonth = MockGetTransactionsByMonth();
    final getByDay = MockGetTransactionsByDay();
    final deleteTransaction = MockDeleteTransaction();
    final getAccounts = MockGetAccounts();
    final getCategories = MockGetCategories();
    final txChanges = TxChangeNotifier();
    addTearDown(txChanges.dispose);

    final today = DateTime(now.year, now.month, now.day);
    final tx = Transaction(
      id: 1,
      type: TransactionType.expense,
      amount: 12345678,
      accountId: 1,
      categoryId: 1,
      date: today.millisecondsSinceEpoch,
    );

    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Right<Failure, List<Account>>([
        Account(id: 1, name: 'Rekening Utama', type: AccountType.cash),
      ]),
    );
    when(() => getCategories(CategoryType.expense)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 1, name: 'Makanan & Minuman', type: CategoryType.expense),
      ]),
    );
    when(
      () => getCategories(CategoryType.income),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([]));
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>([tx]));
    when(
      () => getByDay(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>([tx]));

    final cubit = CalendarCubit(
      getTransactionsByMonth: getByMonth,
      getTransactionsByDay: getByDay,
      deleteTransaction: deleteTransaction,
      getAccounts: getAccounts,
      getCategories: getCategories,
      txChangeNotifier: txChanges,
    );
    addTearDown(cubit.close);
    await pumpApp(
      tester,
      BlocProvider.value(value: cubit, child: const CalendarPage()),
      scaffold: false,
      textScaler: scaler,
    );
    await cubit.load();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('Budget list renders at 1.3× without overflow', (tester) async {
    useDenseSurface(tester);
    final getBudgets = MockGetBudgetsForPeriod();
    final deleteBudget = MockDeleteBudget();
    final getCategories = MockGetCategories();
    final txChanges = TxChangeNotifier();
    final settings = MockSettingsService();
    when(() => settings.getString(any())).thenAnswer((_) async => null);
    when(() => settings.setString(any(), any())).thenAnswer((_) async {});
    final appSettings = AppSettingsCubit(settings, txChanges);
    addTearDown(() async {
      await appSettings.close();
      txChanges.dispose();
    });

    const budget = Budget(
      id: 1,
      categoryId: 1,
      period: '2026-07',
      limitAmount: 12345678,
      spent: 9876543,
    );
    when(() => getCategories(CategoryType.expense)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 1, name: 'Makanan & Minuman', type: CategoryType.expense),
      ]),
    );
    when(
      () => getBudgets(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Budget>>([budget]));

    final cubit = BudgetListCubit(
      getBudgetsForPeriod: getBudgets,
      deleteBudget: deleteBudget,
      getCategories: getCategories,
      txChangeNotifier: txChanges,
      appSettings: appSettings,
    );
    addTearDown(cubit.close);
    await pumpApp(
      tester,
      BlocProvider.value(value: cubit, child: const BudgetListPage()),
      scaffold: false,
      textScaler: scaler,
    );
    await cubit.load();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
