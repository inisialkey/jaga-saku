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
    'submit with an empty name does nothing',
    build: () => CategoryFormCubit(
      saveCategory: saveCategory,
      getCategories: getCategories,
    ),
    act: (cubit) => cubit.submit(),
    expect: () => const <CategoryFormState>[],
    verify: (_) => verifyNever(() => saveCategory(any())),
  );

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
}
