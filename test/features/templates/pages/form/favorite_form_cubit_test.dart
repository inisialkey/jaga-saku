import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/form/form_validation.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/templates/pages/form/favorite_form_cubit.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockSaveTxTemplate saveTemplate;
  late MockGetAccounts getAccounts;
  late MockGetCategories getCategories;

  setUp(() {
    saveTemplate = MockSaveTxTemplate();
    getAccounts = MockGetAccounts();
    getCategories = MockGetCategories();
  });

  FavoriteFormCubit build({TxTemplate? initial}) => FavoriteFormCubit(
    saveTemplate: saveTemplate,
    getAccounts: getAccounts,
    getCategories: getCategories,
    initial: initial,
  );

  void stubLoad() {
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Right<Failure, List<Account>>([
        Account(id: 1, name: 'Cash', type: AccountType.cash),
        Account(id: 2, name: 'BCA', type: AccountType.bank),
      ]),
    );
    when(() => getCategories(CategoryType.expense)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 1, name: 'Makan', type: CategoryType.expense),
      ]),
    );
    when(() => getCategories(CategoryType.income)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 7, name: 'Gaji', type: CategoryType.income),
      ]),
    );
  }

  test('seeds fields from an existing favorite (isEditing true)', () {
    final cubit = build(
      initial: const TxTemplate(
        id: 5,
        label: 'Coffee',
        type: TransactionType.expense,
        accountId: 2,
        amount: 15000,
        categoryId: 1,
        note: 'Kopi',
      ),
    );

    expect(cubit.state.label, 'Coffee');
    expect(cubit.state.amount, 15000);
    expect(cubit.state.accountId, 2);
    expect(cubit.state.categoryId, 1);
    expect(cubit.state.note, 'Kopi');
    expect(cubit.state.isEditing, isTrue);
  });

  test('a save-as-favorite seed (id null) is not editing', () {
    final cubit = build(
      initial: const TxTemplate(
        label: '',
        type: TransactionType.expense,
        accountId: 1,
        amount: 15000,
        categoryId: 1,
      ),
    );

    expect(cubit.state.isEditing, isFalse);
    expect(cubit.state.label, '');
    expect(cubit.state.accountId, 1);
  });

  test('load populates accounts + both category sets', () async {
    stubLoad();

    final cubit = build();
    await cubit.load();

    expect(cubit.state.accounts.map((a) => a.id), [1, 2]);
    expect(cubit.state.categories.map((c) => c.id), [1, 7]);
    expect(cubit.state.categoriesForType.map((c) => c.id), [1]);
    await cubit.close();
  });

  blocTest<FavoriteFormCubit, FavoriteFormState>(
    'submit insert emits [saving, success]',
    setUp: () => when(
      () => saveTemplate(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(1)),
    build: build,
    seed: () => const FavoriteFormState(
      label: 'Coffee',
      amount: 15000,
      accountId: 1,
      categoryId: 1,
    ),
    act: (cubit) => cubit.submit(),
    expect: () => const [
      FavoriteFormState(
        label: 'Coffee',
        amount: 15000,
        accountId: 1,
        categoryId: 1,
        status: FavoriteFormStatus.saving,
      ),
      FavoriteFormState(
        label: 'Coffee',
        amount: 15000,
        accountId: 1,
        categoryId: 1,
        status: FavoriteFormStatus.success,
      ),
    ],
    verify: (_) {
      final captured =
          verify(() => saveTemplate(captureAny())).captured.single
              as TxTemplate;
      expect(captured.id, isNull);
      expect(captured.label, 'Coffee');
      expect(captured.amount, 15000);
      expect(captured.isFavorite, isTrue);
    },
  );

  blocTest<FavoriteFormCubit, FavoriteFormState>(
    'submit on an existing favorite updates (id preserved)',
    setUp: () => when(
      () => saveTemplate(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(5)),
    build: () => build(
      initial: const TxTemplate(
        id: 5,
        label: 'Coffee',
        type: TransactionType.expense,
        accountId: 1,
        amount: 15000,
        categoryId: 1,
        sortOrder: 3,
      ),
    ),
    act: (cubit) => cubit.submit(),
    verify: (_) {
      final captured =
          verify(() => saveTemplate(captureAny())).captured.single
              as TxTemplate;
      expect(captured.id, 5);
      expect(captured.sortOrder, 3);
    },
  );

  blocTest<FavoriteFormCubit, FavoriteFormState>(
    'an amount-less favorite is still valid and saves with a null amount',
    setUp: () => when(
      () => saveTemplate(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(1)),
    build: build,
    seed: () => const FavoriteFormState(
      label: 'Ask each time',
      accountId: 1,
      categoryId: 1,
    ),
    act: (cubit) => cubit.submit(),
    expect: () => const [
      FavoriteFormState(
        label: 'Ask each time',
        accountId: 1,
        categoryId: 1,
        status: FavoriteFormStatus.saving,
      ),
      FavoriteFormState(
        label: 'Ask each time',
        accountId: 1,
        categoryId: 1,
        status: FavoriteFormStatus.success,
      ),
    ],
    verify: (_) {
      final captured =
          verify(() => saveTemplate(captureAny())).captured.single
              as TxTemplate;
      expect(captured.amount, isNull);
    },
  );

  blocTest<FavoriteFormCubit, FavoriteFormState>(
    'submit with an empty label emits failure and never saves (D1)',
    build: build,
    seed: () => const FavoriteFormState(accountId: 1, categoryId: 1),
    act: (cubit) => cubit.submit(),
    expect: () => const [
      FavoriteFormState(
        accountId: 1,
        categoryId: 1,
        status: FavoriteFormStatus.failure,
      ),
    ],
    verify: (_) => verifyNever(() => saveTemplate(any())),
  );

  blocTest<FavoriteFormCubit, FavoriteFormState>(
    'a transfer to the same account emits failure and never saves (D1)',
    build: build,
    seed: () => const FavoriteFormState(
      label: 'Move',
      type: TransactionType.transfer,
      accountId: 1,
      toAccountId: 1,
    ),
    act: (cubit) => cubit.submit(),
    expect: () => const [
      FavoriteFormState(
        label: 'Move',
        type: TransactionType.transfer,
        accountId: 1,
        toAccountId: 1,
        status: FavoriteFormStatus.failure,
      ),
    ],
    verify: (_) => verifyNever(() => saveTemplate(any())),
  );

  test('firstError reports the first failing field (D1)', () {
    expect(
      const FavoriteFormState().firstError,
      FormValidationError.labelRequired,
    );
    expect(
      const FavoriteFormState(
        label: 'Move',
        type: TransactionType.transfer,
        accountId: 1,
        toAccountId: 1,
      ).firstError,
      FormValidationError.transferSameAccount,
    );
  });

  test('hasEdits is false on the create + edit seed, true after edit (D2)', () {
    final create = build();
    expect(create.hasEdits, isFalse);
    create.labelChanged('Coffee');
    expect(create.hasEdits, isTrue);

    final edit = build(
      initial: const TxTemplate(
        id: 5,
        label: 'Coffee',
        type: TransactionType.expense,
        accountId: 1,
        amount: 15000,
        categoryId: 1,
      ),
    );
    expect(edit.hasEdits, isFalse);
    edit.amountChanged(20000);
    expect(edit.hasEdits, isTrue);
  });

  blocTest<FavoriteFormCubit, FavoriteFormState>(
    'typeChanged to transfer clears category / planned / spending',
    build: build,
    seed: () => const FavoriteFormState(
      label: 'X',
      amount: 1000,
      accountId: 1,
      categoryId: 1,
      plannedStatus: PlannedStatus.planned,
      spendingType: SpendingType.need,
    ),
    act: (cubit) => cubit.typeChanged(TransactionType.transfer),
    expect: () => const [
      FavoriteFormState(
        label: 'X',
        type: TransactionType.transfer,
        amount: 1000,
        accountId: 1,
      ),
    ],
  );
}
