import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_cubit.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

/// [AddTransactionPage] over a real [AddTransactionCubit] (mocked usecases): the
/// amount keypad opens on tap (never auto-opens on load) and the catch #2
/// success-pop (a dirty form still leaves cleanly on save, no double-prompt).
void main() {
  setUpAll(registerFallbackValues);

  late MockSaveTransaction saveTransaction;
  late MockGetAccounts getAccounts;
  late MockGetCategories getCategories;
  late MockGetBudgetsForPeriod getBudgets;
  late MockReceiptStorageService receiptStorage;
  late AppSettingsCubit appSettings;

  setUp(() {
    saveTransaction = MockSaveTransaction();
    getAccounts = MockGetAccounts();
    getCategories = MockGetCategories();
    getBudgets = MockGetBudgetsForPeriod();
    receiptStorage = MockReceiptStorageService();
    appSettings = AppSettingsCubit(
      MockSettingsService(),
      MockTxChangeNotifier(),
    );
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Account>>([]));
    when(
      () => getCategories(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([]));
    when(
      () => getBudgets(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Budget>>([]));
    when(() => receiptStorage.delete(any())).thenAnswer((_) async {});
  });

  tearDown(() => appSettings.close());

  AddTransactionCubit build({Transaction? initial}) => AddTransactionCubit(
    saveTransaction: saveTransaction,
    getAccounts: getAccounts,
    getCategories: getCategories,
    getBudgetsForPeriod: getBudgets,
    receiptStorage: receiptStorage,
    appSettings: appSettings,
    initial: initial,
  );

  final editTx = Transaction(
    id: 1,
    type: TransactionType.expense,
    amount: 25000,
    accountId: 1,
    categoryId: 1,
    date: DateTime(2026, 7).millisecondsSinceEpoch,
  );

  testWidgets('a new transaction opens the amount keypad only on tap', (
    tester,
  ) async {
    final cubit = build();
    addTearDown(cubit.close);
    await pumpApp(
      tester,
      BlocProvider.value(value: cubit, child: const AddTransactionPage()),
      scaffold: false,
    );
    await tester.pumpAndSettle();

    // No auto-open on load — the form lands on an inert amount pill, not the
    // calculator.
    expect(find.byType(CalculatorKeypadSheet), findsNothing);

    // Tapping the amount field is what opens the keypad.
    await tester.tap(find.byType(AmountInputField));
    await tester.pumpAndSettle();
    expect(find.byType(CalculatorKeypadSheet), findsOneWidget);
  });

  testWidgets('renders the whole form at 1.3× Dynamic Type without overflow', (
    tester,
  ) async {
    // Amount field + type segmented + account/category selectors + category
    // chips, all re-flowed at the 1.3× clamp ceiling. Edit mode so the keypad
    // does not auto-open and cover the form.
    when(() => getCategories(any())).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 1, name: 'Makan', type: CategoryType.expense),
        Category(id: 2, name: 'Transportasi', type: CategoryType.expense),
      ]),
    );
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Right<Failure, List<Account>>([
        Account(id: 1, name: 'Cash', type: AccountType.cash, balance: 5000000),
      ]),
    );
    final cubit = build(initial: editTx);
    addTearDown(cubit.close);
    await pumpApp(
      tester,
      BlocProvider.value(value: cubit, child: const AddTransactionPage()),
      scaffold: false,
      textScaler: const TextScaler.linear(1.3),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(AmountInputField), findsOneWidget);
  });

  testWidgets('D8: editing an existing transaction does NOT auto-open the '
      'keypad', (tester) async {
    final cubit = build(initial: editTx);
    addTearDown(cubit.close);
    await pumpApp(
      tester,
      BlocProvider.value(value: cubit, child: const AddTransactionPage()),
      scaffold: false,
    );
    await tester.pumpAndSettle();

    expect(find.byType(CalculatorKeypadSheet), findsNothing);
  });

  testWidgets('Catch #2: saving a dirty edit pops with no confirm sheet', (
    tester,
  ) async {
    when(
      () => saveTransaction(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(1));
    final cubit = build(initial: editTx);
    addTearDown(cubit.close);
    await pumpFormRouter(
      tester,
      formChild: BlocProvider.value(
        value: cubit,
        child: const AddTransactionPage(),
      ),
    );

    // Dirty the form so the guard WOULD prompt on a plain back — proving the
    // success pop bypasses it. (Driven through the cubit: the note field sits
    // below the fold and isn't laid out in a default-height surface.)
    cubit.noteChanged('updated');
    await tester.pump();
    expect(cubit.hasEdits, isTrue);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    verify(() => saveTransaction(any())).called(1);
    expect(find.text('Discard changes?'), findsNothing);
    expect(find.byKey(pumpFormHomeKey), findsOneWidget);
  });
}
