import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
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
    when(
      () => getCategories(CategoryType.expense),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([cat]));
  });

  tearDown(() => txChanges.dispose());

  BudgetListCubit build() => BudgetListCubit(
    getBudgetsForPeriod: getBudgets,
    deleteBudget: deleteBudget,
    getCategories: getCategories,
    txChangeNotifier: txChanges,
  );

  void stubBudgets(List<Budget> budgets) => when(
    () => getBudgets(any()),
  ).thenAnswer((_) async => Right<Failure, List<Budget>>(budgets));

  blocTest<BudgetListCubit, BudgetListState>(
    'load emits [loading, loaded] with the period budgets + category lookup',
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

  test('delete calls the usecase, pings the bus, and reloads', () async {
    when(
      () => deleteBudget(1),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
    var pings = 0;
    final sub = txChanges.changes.listen((_) => pings++);
    addTearDown(sub.cancel);

    stubBudgets([budget]);
    final cubit = build();
    await cubit.load();
    expect((cubit.state as BudgetListLoaded).budgets, [budget]);

    stubBudgets(const []); // the post-delete reload sees an empty list
    await cubit.delete(1);
    await pumpEventQueue();

    expect((cubit.state as BudgetListLoaded).budgets, isEmpty);
    verify(() => deleteBudget(1)).called(1);
    expect(pings, greaterThanOrEqualTo(1));
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

  test('nextMonth then previousMonth round-trips the viewed month', () async {
    stubBudgets(const []);
    final cubit = build();
    await cubit.load();
    final initial = (cubit.state as BudgetListLoaded).month;

    cubit.nextMonth();
    await pumpEventQueue();
    expect(
      (cubit.state as BudgetListLoaded).month,
      DateTime(initial.year, initial.month + 1),
    );

    cubit.previousMonth();
    await pumpEventQueue();
    expect((cubit.state as BudgetListLoaded).month, initial);
    await cubit.close();
  });
}
