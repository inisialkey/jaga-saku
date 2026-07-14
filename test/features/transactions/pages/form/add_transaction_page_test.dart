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
/// D8 amount-keypad autofocus (opens on a new tx, not an edit) and the catch #2
/// success-pop (a dirty form still leaves cleanly on save, no double-prompt).
void main() {
  setUpAll(registerFallbackValues);

  late MockSaveTransaction saveTransaction;
  late MockGetAccounts getAccounts;
  late MockGetCategories getCategories;
  late MockGetBudgetsForPeriod getBudgets;
  late MockTxChangeNotifier txChangeNotifier;
  late MockReceiptStorageService receiptStorage;
  late AppSettingsCubit appSettings;

  setUp(() {
    saveTransaction = MockSaveTransaction();
    getAccounts = MockGetAccounts();
    getCategories = MockGetCategories();
    getBudgets = MockGetBudgetsForPeriod();
    txChangeNotifier = MockTxChangeNotifier();
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
    txChangeNotifier: txChangeNotifier,
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

  testWidgets('D8: a new transaction auto-opens the amount keypad', (
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

    // The post-frame autofocus opened the calculator instead of focusing the
    // read-only field.
    expect(find.byType(CalculatorKeypadSheet), findsOneWidget);
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
