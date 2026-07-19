import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/form/form_validation.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/save_recurring_rule.dart';
import 'package:jaga_saku/features/recurring/pages/form/recurring_form_cubit.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockSaveRecurringRule saveRule;
  late MockGetAccounts getAccounts;
  late MockGetCategories getCategories;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
  final pastStart = DateTime(2020).millisecondsSinceEpoch;
  final futureStart = DateTime(now.year + 1, 6, 15).millisecondsSinceEpoch;

  setUp(() {
    saveRule = MockSaveRecurringRule();
    getAccounts = MockGetAccounts();
    getCategories = MockGetCategories();
  });

  RecurringFormCubit build({RecurringRule? initial}) => RecurringFormCubit(
    saveRule: saveRule,
    getAccounts: getAccounts,
    getCategories: getCategories,
    initial: initial,
  );

  void stubLoad() {
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Right<Failure, List<Account>>([
        Account(id: 1, name: 'Cash', type: AccountType.cash),
      ]),
    );
    when(() => getCategories(CategoryType.expense)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 1, name: 'Bills', type: CategoryType.expense),
      ]),
    );
    when(
      () => getCategories(CategoryType.income),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([]));
  }

  SaveRecurringRuleParams captured() =>
      verify(() => saveRule(captureAny())).captured.single
          as SaveRecurringRuleParams;

  test('seeds fields from an existing rule (schedule + isEditing)', () {
    final cubit = build(
      initial: RecurringRule(
        id: 5,
        templateId: 3,
        freq: RecurrenceFreq.weekly,
        interval: 2,
        startDate: pastStart,
        nextDue: pastStart,
        endDate: futureStart,
        template: const TxTemplate(
          label: 'Rent',
          type: TransactionType.expense,
          accountId: 1,
          amount: 50000,
          categoryId: 1,
        ),
      ),
    );

    expect(cubit.state.label, 'Rent');
    expect(cubit.state.amount, 50000);
    expect(cubit.state.freq, RecurrenceFreq.weekly);
    expect(cubit.state.interval, 2);
    expect(cubit.state.startDate, pastStart);
    expect(cubit.state.endDate, futureStart);
    expect(cubit.state.isEditing, isTrue);
  });

  test('load populates accounts + both category sets', () async {
    stubLoad();

    final cubit = build();
    await cubit.load();

    expect(cubit.state.accounts.map((a) => a.id), [1]);
    expect(cubit.state.categoriesForType.map((c) => c.id), [1]);
    await cubit.close();
  });

  test('categoriesForType hides reserved system categories', () async {
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Account>>([]));
    when(() => getCategories(CategoryType.expense)).thenAnswer(
      (_) async => const Right<Failure, List<Category>>([
        Category(id: 1, name: 'Bills', type: CategoryType.expense),
        Category(
          id: 8,
          name: 'Penyesuaian',
          type: CategoryType.expense,
          systemKey: 'adjustment_out',
        ),
      ]),
    );
    when(
      () => getCategories(CategoryType.income),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([]));

    final cubit = build();
    await cubit.load();

    // V4-M3: kept in state (selectedCategory still resolves an edited
    // adjustment's label) but hidden from the picker source — a recurring rule
    // must not be able to target the reserved reconcile pair.
    expect(cubit.state.categories.map((c) => c.id), [1, 8]);
    expect(cubit.state.categoriesForType.map((c) => c.id), [1]);
    await cubit.close();
  });

  blocTest<RecurringFormCubit, RecurringFormState>(
    'endDateChanged(null) clears the end date',
    build: build,
    seed: () => RecurringFormState(
      label: 'Rent',
      amount: 50000,
      accountId: 1,
      categoryId: 1,
      startDate: futureStart,
      endDate: futureStart,
    ),
    act: (cubit) => cubit.endDateChanged(null),
    expect: () => [
      RecurringFormState(
        label: 'Rent',
        amount: 50000,
        accountId: 1,
        categoryId: 1,
        startDate: futureStart,
      ),
    ],
  );

  blocTest<RecurringFormCubit, RecurringFormState>(
    'a zero amount emits failure and never saves (amount required, D1)',
    build: build,
    seed: () => RecurringFormState(
      label: 'Rent',
      accountId: 1,
      categoryId: 1,
      startDate: futureStart,
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      RecurringFormState(
        label: 'Rent',
        accountId: 1,
        categoryId: 1,
        startDate: futureStart,
        status: RecurringFormStatus.failure,
      ),
    ],
    verify: (_) => verifyNever(() => saveRule(any())),
  );

  blocTest<RecurringFormCubit, RecurringFormState>(
    'an end date before the start emits failure and never saves (D1)',
    build: build,
    seed: () => RecurringFormState(
      label: 'Rent',
      amount: 50000,
      accountId: 1,
      categoryId: 1,
      startDate: futureStart,
      endDate: pastStart, // before start
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      RecurringFormState(
        label: 'Rent',
        amount: 50000,
        accountId: 1,
        categoryId: 1,
        startDate: futureStart,
        endDate: pastStart,
        status: RecurringFormStatus.failure,
      ),
    ],
    verify: (_) => verifyNever(() => saveRule(any())),
  );

  test('firstError reports the first failing field (D1)', () {
    expect(
      const RecurringFormState(
        label: 'Rent',
        amount: 50000,
        accountId: 1,
        categoryId: 1,
      ).firstError,
      FormValidationError.startDateRequired,
    );
    expect(
      RecurringFormState(
        label: 'Rent',
        amount: 50000,
        accountId: 1,
        categoryId: 1,
        startDate: futureStart,
        endDate: pastStart,
      ).firstError,
      FormValidationError.endDateBeforeStart,
    );
  });

  test('hasEdits is false on the create + edit seed, true after edit (D2)', () {
    final create = build();
    expect(create.hasEdits, isFalse);
    create.amountChanged(50000);
    expect(create.hasEdits, isTrue);

    final edit = build(
      initial: RecurringRule(
        id: 5,
        templateId: 3,
        freq: RecurrenceFreq.monthly,
        startDate: pastStart,
        nextDue: pastStart,
        template: const TxTemplate(
          label: 'Rent',
          type: TransactionType.expense,
          accountId: 1,
          amount: 50000,
          categoryId: 1,
        ),
      ),
    );
    expect(edit.hasEdits, isFalse);
    edit.amountChanged(99000);
    expect(edit.hasEdits, isTrue);
  });

  blocTest<RecurringFormCubit, RecurringFormState>(
    'submit insert builds an owned template (is_favorite 0) with next_due = start',
    setUp: () => when(
      () => saveRule(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(1)),
    build: build,
    seed: () => RecurringFormState(
      label: 'Rent',
      amount: 50000,
      accountId: 1,
      categoryId: 1,
      startDate: futureStart,
    ),
    act: (cubit) => cubit.submit(),
    verify: (_) {
      final params = captured();
      expect(params.template.isFavorite, isFalse);
      expect(params.template.amount, 50000);
      expect(params.rule.id, isNull);
      // Insert: the cursor seeds to the start (intended backfill from there).
      expect(params.rule.nextDue, futureStart);
    },
  );

  blocTest<RecurringFormCubit, RecurringFormState>(
    'a schedule edit resets next_due to >= today (no past backfill, C5)',
    setUp: () => when(
      () => saveRule(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(5)),
    build: () => build(
      initial: RecurringRule(
        id: 5,
        templateId: 3,
        freq: RecurrenceFreq.monthly,
        startDate: pastStart,
        nextDue: pastStart,
        template: const TxTemplate(
          label: 'Rent',
          type: TransactionType.expense,
          accountId: 1,
          amount: 50000,
          categoryId: 1,
        ),
      ),
    ),
    // Same past start, but the FREQ changed (monthly → weekly) ⇒ schedule edit.
    seed: () => RecurringFormState(
      label: 'Rent',
      amount: 50000,
      accountId: 1,
      categoryId: 1,
      freq: RecurrenceFreq.weekly,
      startDate: pastStart,
      isEditing: true,
    ),
    act: (cubit) => cubit.submit(),
    verify: (_) {
      final params = captured();
      expect(params.rule.id, 5);
      expect(params.rule.templateId, 3);
      // The cursor jumped forward to on/after today — never backfills the past.
      expect(params.rule.nextDue >= today, isTrue);
      expect(params.rule.nextDue, isNot(pastStart));
    },
  );

  blocTest<RecurringFormCubit, RecurringFormState>(
    'a shape-only edit preserves the existing next_due cursor',
    setUp: () => when(
      () => saveRule(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(5)),
    build: () => build(
      initial: RecurringRule(
        id: 5,
        templateId: 3,
        freq: RecurrenceFreq.monthly,
        startDate: pastStart,
        nextDue: futureStart, // an already-advanced cursor
        template: const TxTemplate(
          label: 'Rent',
          type: TransactionType.expense,
          accountId: 1,
          amount: 50000,
          categoryId: 1,
        ),
      ),
    ),
    // Same schedule (freq / interval / start), only the amount changed. freq
    // defaults to monthly, matching the initial rule ⇒ a shape-only edit.
    seed: () => RecurringFormState(
      label: 'Rent',
      amount: 99000,
      accountId: 1,
      categoryId: 1,
      startDate: pastStart,
      isEditing: true,
    ),
    act: (cubit) => cubit.submit(),
    verify: (_) {
      final params = captured();
      expect(params.template.amount, 99000);
      // Cursor untouched by a shape-only edit.
      expect(params.rule.nextDue, futureStart);
    },
  );

  blocTest<RecurringFormCubit, RecurringFormState>(
    'typeChanged to transfer clears category / planned / spending',
    build: build,
    seed: () => const RecurringFormState(
      label: 'X',
      amount: 1000,
      accountId: 1,
      categoryId: 1,
      plannedStatus: PlannedStatus.planned,
      spendingType: SpendingType.need,
    ),
    act: (cubit) => cubit.typeChanged(TransactionType.transfer),
    expect: () => const [
      RecurringFormState(
        label: 'X',
        type: TransactionType.transfer,
        amount: 1000,
        accountId: 1,
      ),
    ],
  );

  // W2: the failed-submit → switch-type path. Seeds a non-default status/error
  // so the copyWith resets are load-bearing (a stale failure would otherwise
  // survive the switch and re-fire the page's failure listener).
  blocTest<RecurringFormCubit, RecurringFormState>(
    'typeChanged clears a failed submit (status / error)',
    build: build,
    seed: () => const RecurringFormState(
      label: 'X',
      amount: 1000,
      accountId: 1,
      categoryId: 1,
      status: RecurringFormStatus.failure,
      error: CacheFailure(),
    ),
    act: (cubit) => cubit.typeChanged(TransactionType.transfer),
    expect: () => const [
      RecurringFormState(
        label: 'X',
        type: TransactionType.transfer,
        amount: 1000,
        accountId: 1,
      ),
    ],
  );
}
