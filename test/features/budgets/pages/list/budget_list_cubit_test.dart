import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_cycle.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/pages/list/budget_list_cubit.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockGetBudgetsForPeriod getBudgets;
  late MockDeleteBudget deleteBudget;
  late MockGetCategories getCategories;
  late TxChangeNotifier txChanges;
  late MockSettingsService settings;
  late AppSettingsCubit appSettings;

  const cat = Category(id: 1, name: 'Makan', type: CategoryType.expense);
  final budget = Budget(
    id: 1,
    categoryId: 1,
    period: periodKey(DateTime.now()),
    limitAmount: 100000,
    spent: 50000,
  );

  setUp(() {
    getBudgets = MockGetBudgetsForPeriod();
    deleteBudget = MockDeleteBudget();
    getCategories = MockGetCategories();
    txChanges = TxChangeNotifier();
    settings = MockSettingsService();
    when(() => settings.getString(any())).thenAnswer((_) async => null);
    when(() => settings.setString(any(), any())).thenAnswer((_) async {});
    // A real AppSettingsCubit (default start-day 1) sharing the SAME notifier,
    // so a start-day change pings the list cubit's subscription (plan §5).
    appSettings = AppSettingsCubit(settings, txChanges);
    when(
      () => getCategories(CategoryType.expense),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([cat]));
  });

  tearDown(() async {
    await appSettings.close();
    txChanges.dispose();
  });

  BudgetListCubit build() => BudgetListCubit(
    getBudgetsForPeriod: getBudgets,
    deleteBudget: deleteBudget,
    getCategories: getCategories,
    txChangeNotifier: txChanges,
    appSettings: appSettings,
  );

  void stubBudgets(List<Budget> budgets) => when(
    () => getBudgets(any()),
  ).thenAnswer((_) async => Right<Failure, List<Budget>>(budgets));

  blocTest<BudgetListCubit, BudgetListState>(
    'load emits [loading, loaded] with the cycle budgets + category lookup',
    setUp: () => stubBudgets([budget]),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<BudgetListLoading>(),
      isA<BudgetListLoaded>()
          .having((s) => s.budgets, 'budgets', [budget])
          .having((s) => s.categoriesById[1]?.name, 'category name', 'Makan'),
    ],
  );

  blocTest<BudgetListCubit, BudgetListState>(
    'load failure emits [loading, error]',
    setUp: () => when(() => getBudgets(any())).thenAnswer(
      (_) async => const Left<Failure, List<Budget>>(CacheFailure()),
    ),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [isA<BudgetListLoading>(), isA<BudgetListError>()],
  );

  test('delete calls the usecase and reloads', () async {
    when(
      () => deleteBudget(1),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

    stubBudgets([budget]);
    final cubit = build();
    await cubit.load();
    expect((cubit.state as BudgetListLoaded).budgets, [budget]);

    stubBudgets(const []); // the post-delete reload sees an empty list
    await cubit.delete(1);
    await pumpEventQueue();

    expect((cubit.state as BudgetListLoaded).budgets, isEmpty);
    verify(() => deleteBudget(1)).called(1);
    await cubit.close();
  });

  test('a notifier ping reloads the list', () async {
    stubBudgets([budget]);
    final cubit = build();
    await cubit.load();
    clearInteractions(getBudgets);

    txChanges.ping();
    await pumpEventQueue();

    verify(() => getBudgets(any())).called(1);
    await cubit.close();
  });

  test('nextCycle then previousCycle round-trips the viewed cycle', () async {
    stubBudgets(const []);
    final cubit = build();
    await cubit.load();
    final initialStart = (cubit.state as BudgetListLoaded).cycleStart;
    final initialEnd = (cubit.state as BudgetListLoaded).cycleEnd;

    cubit.nextCycle();
    await pumpEventQueue();
    // At start-day 1 cycles are contiguous months: next.start == this.end.
    expect((cubit.state as BudgetListLoaded).cycleStart, initialEnd);

    cubit.previousCycle();
    await pumpEventQueue();
    expect((cubit.state as BudgetListLoaded).cycleStart, initialStart);
    expect((cubit.state as BudgetListLoaded).cycleEnd, initialEnd);
    await cubit.close();
  });

  test('a custom start-day loads the payday cycle window + label', () async {
    await appSettings.setBudgetCycleStartDay(25);
    stubBudgets(const []);
    final cubit = build();
    await cubit.load();

    final expected = BudgetCycle.range(startDay: 25, reference: DateTime.now());
    final state = cubit.state as BudgetListLoaded;
    expect(state.cycleStart, expected.start);
    expect(state.cycleEnd, expected.end);
    // The lookup label is the cycle-START month (not necessarily today's month).
    verify(
      () => getBudgets(
        periodKey(DateTime.fromMillisecondsSinceEpoch(expected.start)),
      ),
    ).called(1);
    await cubit.close();
  });

  test('changing the start-day pings and reloads with the new cycle', () async {
    stubBudgets(const []);
    final cubit = build();
    await cubit.load();
    clearInteractions(getBudgets);

    await appSettings.setBudgetCycleStartDay(25); // pings the shared notifier
    await pumpEventQueue();

    verify(() => getBudgets(any())).called(1); // the reload re-read the new day
    final expected = BudgetCycle.range(startDay: 25, reference: DateTime.now());
    expect((cubit.state as BudgetListLoaded).cycleStart, expected.start);
    await cubit.close();
  });
}
