import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/pages/list/category_list_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockGetCategories getCategories;
  late MockDeleteCategory deleteCategory;
  late MockArchiveCategory archiveCategory;
  late MockReorderCategories reorderCategories;

  const food = Category(id: 1, name: 'Food', type: CategoryType.expense);
  const salary = Category(id: 2, name: 'Salary', type: CategoryType.income);
  const adjustment = Category(
    id: 8,
    name: 'Penyesuaian',
    type: CategoryType.expense,
    systemKey: 'adjustment_out',
  );

  setUp(() {
    getCategories = MockGetCategories();
    deleteCategory = MockDeleteCategory();
    archiveCategory = MockArchiveCategory();
    reorderCategories = MockReorderCategories();
  });

  CategoryListCubit build() => CategoryListCubit(
    getCategories: getCategories,
    deleteCategory: deleteCategory,
    archiveCategory: archiveCategory,
    reorderCategories: reorderCategories,
  );

  blocTest<CategoryListCubit, CategoryListState>(
    'load emits [loading, loaded] for the default (expense) type',
    setUp: () => when(
      () => getCategories(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([food])),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      CategoryListState.loading(),
      CategoryListState.loaded(items: [food], type: CategoryType.expense),
    ],
  );

  blocTest<CategoryListCubit, CategoryListState>(
    'load hides reserved system categories (not editable/deletable)',
    setUp: () => when(() => getCategories(any())).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([food, adjustment]),
    ),
    build: build,
    act: (cubit) => cubit.load(),
    // The reserved "Penyesuaian" cat is filtered out at the consumer, so it
    // never renders in the manage list.
    expect: () => const [
      CategoryListState.loading(),
      CategoryListState.loaded(items: [food], type: CategoryType.expense),
    ],
  );

  blocTest<CategoryListCubit, CategoryListState>(
    'load failure emits [loading, error]',
    setUp: () => when(() => getCategories(any())).thenAnswer(
      (_) async => const Left<Failure, List<Category>>(CacheFailure()),
    ),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      CategoryListState.loading(),
      CategoryListState.error(failure: CacheFailure()),
    ],
  );

  blocTest<CategoryListCubit, CategoryListState>(
    'selectType loads the requested type',
    setUp: () => when(
      () => getCategories(CategoryType.income),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([salary])),
    build: build,
    seed: () => const CategoryListState.loaded(
      items: [food],
      type: CategoryType.expense,
    ),
    act: (cubit) => cubit.selectType(CategoryType.income),
    expect: () => const [
      CategoryListState.loading(type: CategoryType.income),
      CategoryListState.loaded(items: [salary], type: CategoryType.income),
    ],
  );

  test('delete success returns DeleteOutcome.deleted and reloads', () async {
    when(
      () => deleteCategory(any()),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
    when(
      () => getCategories(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([food]));

    final cubit = build();
    final outcome = await cubit.delete(1);

    expect(outcome, DeleteOutcome.deleted);
    verifyNever(() => archiveCategory(any()));
    await cubit.close();
  });

  test(
    'delete blocked archives instead and returns DeleteOutcome.archivedFallback',
    () async {
      when(
        () => deleteCategory(any()),
      ).thenAnswer((_) async => const Left<Failure, Unit>(ConflictFailure()));
      when(
        () => archiveCategory(any()),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
      when(
        () => getCategories(any()),
      ).thenAnswer((_) async => const Right<Failure, List<Category>>([food]));

      final cubit = build();
      final outcome = await cubit.delete(1);

      expect(outcome, DeleteOutcome.archivedFallback);
      verify(() => archiveCategory(any())).called(1);
      await cubit.close();
    },
  );

  blocTest<CategoryListCubit, CategoryListState>(
    'toggleArchived flips the flag without reloading',
    build: build,
    seed: () => const CategoryListState.loaded(
      items: [food],
      type: CategoryType.expense,
    ),
    act: (cubit) => cubit.toggleArchived(),
    expect: () => const [
      CategoryListState.loaded(
        items: [food],
        type: CategoryType.expense,
        showArchived: true,
      ),
    ],
  );
}
