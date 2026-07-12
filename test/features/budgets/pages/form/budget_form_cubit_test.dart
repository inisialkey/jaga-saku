import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/pages/form/budget_form_cubit.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockSaveBudget saveBudget;
  late MockGetCategories getCategories;
  late MockGetBudgetsForPeriod getBudgets;
  late MockTxChangeNotifier txChanges;

  const cat = Category(id: 1, name: 'Makan', type: CategoryType.expense);

  setUp(() {
    saveBudget = MockSaveBudget();
    getCategories = MockGetCategories();
    getBudgets = MockGetBudgetsForPeriod();
    txChanges = MockTxChangeNotifier();
    when(
      () => getCategories(CategoryType.expense),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([cat]));
    when(
      () => getBudgets(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Budget>>([]));
  });

  BudgetFormCubit build({Budget? initial, DateTime? month}) => BudgetFormCubit(
    saveBudget: saveBudget,
    getCategories: getCategories,
    getBudgetsForPeriod: getBudgets,
    txChangeNotifier: txChanges,
    initial: initial,
    month: month,
  );

  test('create seeds the given month with empty fields', () {
    final cubit = build(month: DateTime(2026, 3));
    expect(cubit.state.month, DateTime(2026, 3));
    expect(cubit.state.categoryId, isNull);
    expect(cubit.state.limitAmount, 0);
    expect(cubit.state.isEditing, isFalse);
  });

  test('edit seeds fields (incl. the month) from the initial budget', () {
    final cubit = build(
      initial: const Budget(
        id: 5,
        categoryId: 1,
        period: '2026-02',
        limitAmount: 300000,
      ),
    );
    expect(cubit.state.month, DateTime(2026, 2));
    expect(cubit.state.categoryId, 1);
    expect(cubit.state.limitAmount, 300000);
    expect(cubit.state.isEditing, isTrue);
  });

  test('load populates the expense categories', () async {
    final cubit = build(month: DateTime(2026, 5));
    await cubit.load();
    expect(cubit.state.categories, [cat]);
    await cubit.close();
  });

  test('load hides reserved system categories from the picker', () async {
    const adjustment = Category(
      id: 8,
      name: 'Penyesuaian',
      type: CategoryType.expense,
      systemKey: 'adjustment_out',
    );
    when(() => getCategories(CategoryType.expense)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([cat, adjustment]),
    );
    final cubit = build(month: DateTime(2026, 5));
    await cubit.load();
    // Can't budget "Penyesuaian" — it's filtered from the picker.
    expect(cubit.state.categories, [cat]);
    await cubit.close();
  });

  blocTest<BudgetFormCubit, BudgetFormState>(
    'invalid submit (no positive limit) never saves',
    build: () => build(month: DateTime(2026, 5)),
    seed: () => BudgetFormState(month: DateTime(2026, 5), categoryId: 1),
    act: (cubit) => cubit.submit(),
    expect: () => const <BudgetFormState>[],
    verify: (_) => verifyNever(() => saveBudget(any())),
  );

  blocTest<BudgetFormCubit, BudgetFormState>(
    'create with no existing budget inserts (id null) and pings',
    setUp: () => when(
      () => saveBudget(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(9)),
    build: () => build(month: DateTime(2026, 5)),
    seed: () => BudgetFormState(
      month: DateTime(2026, 5),
      categoryId: 1,
      limitAmount: 200000,
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      isA<BudgetFormState>().having(
        (s) => s.status,
        'status',
        BudgetFormStatus.saving,
      ),
      isA<BudgetFormState>().having(
        (s) => s.status,
        'status',
        BudgetFormStatus.success,
      ),
    ],
    verify: (_) {
      final saved = verify(() => saveBudget(captureAny())).captured.single;
      expect(saved, isA<Budget>());
      final budget = saved as Budget;
      expect(budget.id, isNull); // insert
      expect(budget.categoryId, 1);
      expect(budget.period, '2026-05');
      expect(budget.limitAmount, 200000);
      verify(() => txChanges.ping()).called(1);
    },
  );

  blocTest<BudgetFormCubit, BudgetFormState>(
    'create where a budget already exists for that category+period updates it',
    setUp: () {
      when(() => getBudgets('2026-05')).thenAnswer(
        (_) async => const Right<Failure, List<Budget>>([
          Budget(
            id: 42,
            categoryId: 1,
            period: '2026-05',
            limitAmount: 100000,
            createdAt: 111,
          ),
        ]),
      );
      when(
        () => saveBudget(any()),
      ).thenAnswer((_) async => const Right<Failure, int>(42));
    },
    build: () => build(month: DateTime(2026, 5)),
    seed: () => BudgetFormState(
      month: DateTime(2026, 5),
      categoryId: 1,
      limitAmount: 250000,
    ),
    act: (cubit) => cubit.submit(),
    verify: (_) {
      final saved =
          verify(() => saveBudget(captureAny())).captured.single as Budget;
      expect(saved.id, 42); // resolved to an update, not a conflicting insert
      expect(saved.limitAmount, 250000);
      // I3: the update carries the original created_at (not a fresh "now"), so
      // the row keeps its place in the created_at-ordered budget list.
      expect(saved.createdAt, 111);
    },
  );

  blocTest<BudgetFormCubit, BudgetFormState>(
    'edit updates by its own id without an existing-budget lookup',
    setUp: () => when(
      () => saveBudget(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(5)),
    build: () => build(
      initial: const Budget(
        id: 5,
        categoryId: 1,
        period: '2026-02',
        limitAmount: 100000,
      ),
    ),
    seed: () => BudgetFormState(
      month: DateTime(2026, 2),
      categoryId: 1,
      limitAmount: 400000,
      isEditing: true,
    ),
    act: (cubit) => cubit.submit(),
    verify: (_) {
      verifyNever(() => getBudgets(any()));
      final saved =
          verify(() => saveBudget(captureAny())).captured.single as Budget;
      expect(saved.id, 5);
      expect(saved.limitAmount, 400000);
    },
  );

  blocTest<BudgetFormCubit, BudgetFormState>(
    'save failure emits failure with the error and does not ping',
    setUp: () => when(
      () => saveBudget(any()),
    ).thenAnswer((_) async => const Left<Failure, int>(ConflictFailure())),
    build: () => build(month: DateTime(2026, 5)),
    seed: () => BudgetFormState(
      month: DateTime(2026, 5),
      categoryId: 1,
      limitAmount: 200000,
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      isA<BudgetFormState>().having(
        (s) => s.status,
        'status',
        BudgetFormStatus.saving,
      ),
      isA<BudgetFormState>()
          .having((s) => s.status, 'status', BudgetFormStatus.failure)
          .having((s) => s.error, 'error', isA<ConflictFailure>()),
    ],
    verify: (_) => verifyNever(() => txChanges.ping()),
  );
}
