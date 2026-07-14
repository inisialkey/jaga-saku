import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/home/pages/home_cubit.dart';
import 'package:jaga_saku/features/home/pages/home_page.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/pump_app.dart';

/// End-to-end render of the whole [HomePage] over a real [HomeCubit] backed by
/// mocked usecases — proves every section composes and the state machine
/// resolves (loaded + empty). Strings resolve in EN (pumpApp default).
void main() {
  setUpAll(registerFallbackValues);

  late MockGetAccounts getAccounts;
  late MockGetTransactionsByMonth getByMonth;
  late MockGetRecentTransactions getRecent;
  late MockGetCategories getCategories;
  late MockGetBudgetsForPeriod getBudgets;
  late MockGetFavorites getFavorites;
  late MockGetDueOccurrences getDueOccurrences;
  late MockSaveTransaction saveTransaction;
  late MockDeleteTransaction deleteTransaction;
  late MockSettingsService settings;
  late AppSettingsCubit appSettings;
  late TxChangeNotifier txChanges;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  setUp(() {
    getAccounts = MockGetAccounts();
    getByMonth = MockGetTransactionsByMonth();
    getRecent = MockGetRecentTransactions();
    getCategories = MockGetCategories();
    getBudgets = MockGetBudgetsForPeriod();
    getFavorites = MockGetFavorites();
    getDueOccurrences = MockGetDueOccurrences();
    saveTransaction = MockSaveTransaction();
    deleteTransaction = MockDeleteTransaction();
    // The greeting name now flows from the app-global AppSettingsCubit (M6),
    // backed by a mocked SettingsService.
    settings = MockSettingsService();
    txChanges = TxChangeNotifier();
    appSettings = AppSettingsCubit(settings, txChanges);
    when(() => settings.getString(any())).thenAnswer((_) async => null);
    when(() => settings.setString(any(), any())).thenAnswer((_) async {});
    when(
      () => getBudgets(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Budget>>([]));
    when(
      () => getFavorites(any()),
    ).thenAnswer((_) async => const Right<Failure, List<TxTemplate>>([]));
    when(() => getDueOccurrences(any())).thenAnswer(
      (_) async => const Right<Failure, List<PendingOccurrence>>([]),
    );
  });

  tearDown(() async {
    await appSettings.close();
    txChanges.dispose();
  });

  HomeCubit build() => HomeCubit(
    getAccounts: getAccounts,
    getTransactionsByMonth: getByMonth,
    getRecentTransactions: getRecent,
    getCategories: getCategories,
    getBudgetsForPeriod: getBudgets,
    getFavorites: getFavorites,
    getDueOccurrences: getDueOccurrences,
    saveTransaction: saveTransaction,
    deleteTransaction: deleteTransaction,
    txChangeNotifier: txChanges,
    appSettings: appSettings,
  );

  // A tall surface so the whole ListView lays out (its lazy children below the
  // default 600px fold — the Recent section — would otherwise never build).
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pumpLoaded(
    WidgetTester tester,
    HomeCubit cubit, {
    TextScaler textScaler = TextScaler.noScaling,
  }) async {
    // Seed the app-global settings (greeting name) from the mocked store first.
    await appSettings.load();
    await pumpApp(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cubit),
          BlocProvider.value(value: appSettings),
        ],
        child: const HomePage(),
      ),
      scaffold: false,
      textScaler: textScaler,
    );
    await cubit.load();
    await tester.pumpAndSettle();
  }

  testWidgets('renders every dashboard section for a loaded state', (
    tester,
  ) async {
    useTallSurface(tester);
    final expense = Transaction(
      type: TransactionType.expense,
      amount: 35000,
      accountId: 1,
      categoryId: 1,
      plannedStatus: PlannedStatus.unplanned,
      date: today.millisecondsSinceEpoch,
    );
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Right<Failure, List<Account>>([
        Account(id: 1, name: 'Cash', type: AccountType.cash, balance: 5000000),
      ]),
    );
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>([expense]));
    when(
      () => getRecent(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>([expense]));
    when(() => getCategories(CategoryType.expense)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 1, name: 'Makan', type: CategoryType.expense),
      ]),
    );
    when(
      () => getCategories(CategoryType.income),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([]));
    when(() => settings.getString(any())).thenAnswer((_) async => 'Oki');

    final cubit = build();
    await pumpLoaded(tester, cubit);

    expect(find.text('Hi, Oki 👋'), findsOneWidget);
    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.text('Budget Guard'), findsOneWidget);
    expect(find.text('No budget yet'), findsOneWidget);
    expect(find.text('Daily Review'), findsOneWidget);
    expect(find.text('Recent Transactions'), findsOneWidget);
    expect(find.text('See All'), findsOneWidget);
    expect(find.text('Rp 5.000.000'), findsWidgets);
    // Recent tile resolved its category name from the lookup map.
    expect(find.text('Makan'), findsWidgets);

    await cubit.close();
  });

  testWidgets('renders the favorites strip when favorites are present', (
    tester,
  ) async {
    useTallSurface(tester);
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Account>>([]));
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getRecent(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getCategories(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([]));
    when(() => getFavorites(any())).thenAnswer(
      (_) async => const Right<Failure, List<TxTemplate>>([
        TxTemplate(
          id: 1,
          label: 'Coffee',
          type: TransactionType.expense,
          accountId: 1,
          amount: 15000,
          categoryId: 1,
        ),
      ]),
    );
    when(() => settings.getString(any())).thenAnswer((_) async => null);

    final cubit = build();
    await pumpLoaded(tester, cubit);

    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Coffee'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders the dense dashboard at 1.3× Dynamic Type without '
      'overflow', (tester) async {
    useTallSurface(tester);
    // The densest possible Home: summary card + populated favorites strip +
    // recent tx rows, all re-flowed at the 1.3× clamp ceiling.
    final expense = Transaction(
      type: TransactionType.expense,
      amount: 35000,
      accountId: 1,
      categoryId: 1,
      plannedStatus: PlannedStatus.unplanned,
      date: today.millisecondsSinceEpoch,
    );
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Right<Failure, List<Account>>([
        Account(id: 1, name: 'Cash', type: AccountType.cash, balance: 5000000),
      ]),
    );
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>([expense]));
    when(
      () => getRecent(any()),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>([expense]));
    when(() => getCategories(any())).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 1, name: 'Makan', type: CategoryType.expense),
      ]),
    );
    when(() => getFavorites(any())).thenAnswer(
      (_) async => const Right<Failure, List<TxTemplate>>([
        TxTemplate(
          id: 1,
          label: 'Coffee',
          type: TransactionType.expense,
          accountId: 1,
          amount: 15000,
          categoryId: 1,
        ),
      ]),
    );
    when(() => settings.getString(any())).thenAnswer((_) async => 'Oki');

    final cubit = build();
    await pumpLoaded(tester, cubit, textScaler: const TextScaler.linear(1.3));

    expect(tester.takeException(), isNull);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Coffee'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('empty first run shows the recent empty-state CTA', (
    tester,
  ) async {
    useTallSurface(tester);
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Account>>([]));
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getRecent(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getCategories(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([]));
    when(() => settings.getString(any())).thenAnswer((_) async => null);

    final cubit = build();
    await pumpLoaded(tester, cubit);

    // Guest greeting (no name), daily-review zero-state, and the Add CTA.
    expect(find.text('Hi 👋'), findsOneWidget);
    expect(find.text('No spending today'), findsOneWidget);
    expect(find.text('Add Transaction'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('a usecase failure renders the error state with retry', (
    tester,
  ) async {
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Left<Failure, List<Account>>(CacheFailure()),
    );
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getRecent(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getCategories(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([]));
    when(() => settings.getString(any())).thenAnswer((_) async => null);

    final cubit = build();
    await pumpLoaded(tester, cubit);

    expect(find.text('Retry'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('editing the name in settings updates the Home greeting live', (
    tester,
  ) async {
    useTallSurface(tester);
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Account>>([]));
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getRecent(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getCategories(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([]));

    final cubit = build();
    await pumpLoaded(tester, cubit);

    // Starts as guest, then the app-global name change flows into the header.
    expect(find.text('Hi 👋'), findsOneWidget);
    await appSettings.setUserName('Budi');
    expect(appSettings.state.userName, 'Budi');
    await tester.pumpAndSettle();

    expect(find.text('Hi, Budi 👋'), findsOneWidget);
    expect(find.text('Hi 👋'), findsNothing);

    await cubit.close();
  });
}
