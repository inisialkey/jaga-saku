import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/insight/pages/money_story_cubit.dart';
import 'package:jaga_saku/features/insight/pages/money_story_page.dart';
import 'package:jaga_saku/features/insight/pages/widgets/asset_trend_chart.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/pump_app.dart';

/// End-to-end render of [MoneyStoryPage] over a real [MoneyStoryCubit] backed by
/// mocked usecases (mirrors `home_page_test.dart`). Proves the loaded recap
/// composes the hero, the trend chart and the selector, and that an empty month
/// shows the empty state with no chart. Strings resolve in EN (pumpApp default).
void main() {
  setUpAll(registerFallbackValues);

  late MockGetTransactionsByMonth getByMonth;
  late MockGetCategories getCategories;
  late MockGetAccounts getAccounts;
  late MockGetAssetTrend getAssetTrend;
  late TxChangeNotifier txChanges;

  final now = DateTime.now();
  final thisMonth = DateTime(now.year, now.month);

  setUp(() {
    getByMonth = MockGetTransactionsByMonth();
    getCategories = MockGetCategories();
    getAccounts = MockGetAccounts();
    getAssetTrend = MockGetAssetTrend();
    txChanges = TxChangeNotifier();
  });

  tearDown(() => txChanges.dispose());

  MoneyStoryCubit build() => MoneyStoryCubit(
    getTransactionsByMonth: getByMonth,
    getCategories: getCategories,
    getAccounts: getAccounts,
    getAssetTrend: getAssetTrend,
    txChangeNotifier: txChanges,
  );

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

  void stub({
    List<Transaction> current = const [],
    List<TrendPoint> trend = const [],
  }) {
    when(
      () => getByMonth(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));
    when(
      () => getByMonth(thisMonth),
    ).thenAnswer((_) async => Right<Failure, List<Transaction>>(current));
    when(() => getCategories(CategoryType.expense)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 1, name: 'Makan', type: CategoryType.expense),
      ]),
    );
    when(() => getCategories(CategoryType.income)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 3, name: 'Gaji', type: CategoryType.income),
      ]),
    );
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Right<Failure, List<Account>>([
        Account(
          id: 1,
          name: 'Cash',
          type: AccountType.cash,
          openingBalance: 150000,
        ),
      ]),
    );
    when(
      () => getAssetTrend(any()),
    ).thenAnswer((_) async => Right<Failure, List<TrendPoint>>(trend));
  }

  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 3600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pumpPage(WidgetTester tester, MoneyStoryCubit cubit) async {
    await pumpApp(
      tester,
      BlocProvider.value(value: cubit, child: const MoneyStoryPage()),
      scaffold: false,
    );
    await cubit.load(thisMonth);
    await tester.pumpAndSettle();
  }

  testWidgets('renders the hero, trend chart and month selector when loaded', (
    tester,
  ) async {
    useTallSurface(tester);
    stub(
      current: [
        tx(amount: 5000000, categoryId: 3, type: TransactionType.income),
        tx(amount: 2000000, categoryId: 1),
      ],
      trend: [
        TrendPoint(
          monthMillis: thisMonth.millisecondsSinceEpoch,
          netWorth: 3000000,
        ),
        TrendPoint(
          monthMillis: DateTime(now.year, now.month + 1).millisecondsSinceEpoch,
          netWorth: 5000000,
        ),
      ],
    );

    final cubit = build();
    await pumpPage(tester, cubit);

    expect(find.byType(MonthSelector), findsOneWidget);
    expect(find.byType(AssetTrendChart), findsOneWidget);
    expect(find.text('Your Money Story'), findsOneWidget); // app bar title
    expect(find.text('Net worth'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('shows the empty state and no chart for an empty month', (
    tester,
  ) async {
    useTallSurface(tester);
    stub();

    final cubit = build();
    await pumpPage(tester, cubit);

    expect(find.byType(EmptyStateView), findsOneWidget);
    expect(find.byType(AssetTrendChart), findsNothing);
    await cubit.close();
  });
}
