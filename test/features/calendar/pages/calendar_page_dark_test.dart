import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/calendar/pages/calendar_cubit.dart';
import 'package:jaga_saku/features/calendar/pages/calendar_page.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/pump_app.dart';

/// Dark render guard for F1 (V3-M6). The calendar day-number, weekday-header and
/// today-cell text styles are now theme-derived — the today cell was a hardcoded
/// dark-green `todayTextStyle` (#15803D ~1.6:1 on the dark cell) and the day
/// numbers inherited table_calendar's hardcoded light greys. This pumps the real
/// [CalendarPage] over a real [CalendarCubit] (mocked usecases, mirroring
/// `calendar_cubit_test.dart`) under [AppTheme.dark] with today seeded in the
/// focused month, so the today cell + weekday header actually render on dark and
/// build without exception.
void main() {
  setUpAll(registerFallbackValues);

  late MockGetTransactionsByMonth getByMonth;
  late MockGetTransactionsByDay getByDay;
  late MockDeleteTransaction deleteTransaction;
  late MockGetAccounts getAccounts;
  late MockGetCategories getCategories;
  late TxChangeNotifier txChanges;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  // A tx on today so the today cell also carries a marker dot (green on dark).
  final tx = Transaction(
    id: 1,
    type: TransactionType.expense,
    amount: 5000,
    accountId: 1,
    categoryId: 1,
    date: today.millisecondsSinceEpoch,
  );

  setUp(() {
    getByMonth = MockGetTransactionsByMonth();
    getByDay = MockGetTransactionsByDay();
    deleteTransaction = MockDeleteTransaction();
    getAccounts = MockGetAccounts();
    getCategories = MockGetCategories();
    txChanges = TxChangeNotifier();

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
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>([tx]));
    when(
      () => getByDay(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>([tx]));
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

  testWidgets('CalendarPage renders under AppTheme.dark (F1 guard)', (
    tester,
  ) async {
    final cubit = build()..load();
    addTearDown(cubit.close);

    await pumpApp(
      tester,
      BlocProvider<CalendarCubit>.value(
        value: cubit,
        child: const CalendarPage(),
      ),
      theme: AppTheme.dark,
      scaffold: false,
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(TableCalendar<Transaction>), findsOneWidget);
  });
}
