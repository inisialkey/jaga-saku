import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/pages/form/category_form_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockSaveCategory saveCategory;
  late MockGetCategories getCategories;

  setUp(() {
    saveCategory = MockSaveCategory();
    getCategories = MockGetCategories();
  });

  test('seeds fields from the initial category when editing', () {
    final cubit = CategoryFormCubit(
      saveCategory: saveCategory,
      getCategories: getCategories,
      initial: const Category(
        id: 1,
        name: 'Food',
        type: CategoryType.expense,
        icon: 'coffee',
      ),
    );

    expect(cubit.state.name, 'Food');
    expect(cubit.state.icon, 'coffee');
    expect(cubit.state.isEditing, isTrue);
  });

  // V5-W1: an id-less prefill is an INSERT. The seed hardcoded
  // `isEditing: true` for ANY non-null initial, so a prefilled create wore the
  // "Edit" title.
  test('an id-less prefill seeds the fields but is not an edit', () {
    final cubit = CategoryFormCubit(
      saveCategory: saveCategory,
      getCategories: getCategories,
      initial: const Category(
        name: 'Food',
        type: CategoryType.expense,
        icon: 'coffee',
      ),
    );

    expect(cubit.state.isEditing, isFalse);
    // The prefill still seeds — this is a filled create, not an empty one.
    expect(cubit.state.name, 'Food');
    expect(cubit.state.icon, 'coffee');
  });

  test(
    'loadParents keeps only top-level, same-type, non-archived, non-self',
    () async {
      final cubit = CategoryFormCubit(
        saveCategory: saveCategory,
        getCategories: getCategories,
        initial: const Category(
          id: 5,
          name: 'Self',
          type: CategoryType.expense,
        ),
      );
      when(() => getCategories(CategoryType.expense)).thenAnswer(
        (_) async => const Right<Failure, List<Category>>([
          Category(id: 1, name: 'Top', type: CategoryType.expense),
          Category(
            id: 2,
            name: 'Child',
            type: CategoryType.expense,
            parentId: 1,
          ),
          Category(
            id: 3,
            name: 'Archived',
            type: CategoryType.expense,
            archived: true,
          ),
          Category(id: 5, name: 'Self', type: CategoryType.expense),
        ]),
      );

      await cubit.loadParents();

      expect(cubit.state.parentOptions.map((c) => c.name), ['Top']);
    },
  );

  blocTest<CategoryFormCubit, CategoryFormState>(
    'submit success emits saving then success',
    setUp: () => when(
      () => saveCategory(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(1)),
    build: () => CategoryFormCubit(
      saveCategory: saveCategory,
      getCategories: getCategories,
    ),
    act: (cubit) {
      cubit.nameChanged('Food');
      cubit.submit();
    },
    expect: () => const [
      CategoryFormState(name: 'Food'),
      CategoryFormState(name: 'Food', status: CategoryFormStatus.saving),
      CategoryFormState(name: 'Food', status: CategoryFormStatus.success),
    ],
  );

  blocTest<CategoryFormCubit, CategoryFormState>(
    'submit with an empty name emits a failure state and never saves (D1)',
    build: () => CategoryFormCubit(
      saveCategory: saveCategory,
      getCategories: getCategories,
    ),
    act: (cubit) => cubit.submit(),
    expect: () => const [CategoryFormState(status: CategoryFormStatus.failure)],
    verify: (_) => verifyNever(() => saveCategory(any())),
  );

  test('hasEdits tracks edits from the create + edit seed (D2)', () {
    final create = CategoryFormCubit(
      saveCategory: saveCategory,
      getCategories: getCategories,
    );
    expect(create.hasEdits, isFalse);
    create.nameChanged('Food');
    expect(create.hasEdits, isTrue);

    final edit = CategoryFormCubit(
      saveCategory: saveCategory,
      getCategories: getCategories,
      initial: const Category(id: 1, name: 'Food', type: CategoryType.expense),
    );
    expect(edit.hasEdits, isFalse);
    edit.nameChanged('Groceries');
    expect(edit.hasEdits, isTrue);
  });

  blocTest<CategoryFormCubit, CategoryFormState>(
    'typeChanged switches type and clears the selected parent',
    setUp: () => when(
      () => getCategories(CategoryType.income),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([])),
    build: () => CategoryFormCubit(
      saveCategory: saveCategory,
      getCategories: getCategories,
    ),
    seed: () => const CategoryFormState(name: 'X', parentId: 3),
    act: (cubit) => cubit.typeChanged(CategoryType.income),
    expect: () => const [
      CategoryFormState(name: 'X', type: CategoryType.income),
    ],
  );

  blocTest<CategoryFormCubit, CategoryFormState>(
    'parentChanged(null) clears the parent selection',
    build: () => CategoryFormCubit(
      saveCategory: saveCategory,
      getCategories: getCategories,
    ),
    seed: () => const CategoryFormState(name: 'X', parentId: 3),
    act: (cubit) => cubit.parentChanged(null),
    expect: () => const [CategoryFormState(name: 'X')],
  );

  // W2: the failed-submit → switch-type path. Seeds a non-default status/error
  // so the copyWith resets are load-bearing (a stale failure would otherwise
  // survive the switch and re-fire the page's failure listener).
  blocTest<CategoryFormCubit, CategoryFormState>(
    'typeChanged clears a failed submit (status / error)',
    setUp: () => when(
      () => getCategories(CategoryType.income),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([])),
    build: () => CategoryFormCubit(
      saveCategory: saveCategory,
      getCategories: getCategories,
    ),
    seed: () => const CategoryFormState(
      name: 'X',
      parentId: 3,
      status: CategoryFormStatus.failure,
      error: CacheFailure(),
    ),
    act: (cubit) => cubit.typeChanged(CategoryType.income),
    expect: () => const [
      CategoryFormState(name: 'X', type: CategoryType.income),
    ],
  );

  // W2: same for the other reset-bearing site.
  blocTest<CategoryFormCubit, CategoryFormState>(
    'parentChanged clears a failed submit (status / error)',
    build: () => CategoryFormCubit(
      saveCategory: saveCategory,
      getCategories: getCategories,
    ),
    seed: () => const CategoryFormState(
      name: 'X',
      status: CategoryFormStatus.failure,
      error: CacheFailure(),
    ),
    act: (cubit) => cubit.parentChanged(3),
    expect: () => const [CategoryFormState(name: 'X', parentId: 3)],
  );
}
