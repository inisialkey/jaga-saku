import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/pages/list/recurring_list_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockGetRecurringRules getRules;
  late MockDeleteRecurringRule deleteRule;

  const a = RecurringRule(
    id: 1,
    templateId: 1,
    freq: RecurrenceFreq.monthly,
    startDate: 0,
    nextDue: 0,
  );
  const b = RecurringRule(
    id: 2,
    templateId: 2,
    freq: RecurrenceFreq.weekly,
    startDate: 0,
    nextDue: 0,
  );

  setUp(() {
    getRules = MockGetRecurringRules();
    deleteRule = MockDeleteRecurringRule();
  });

  RecurringListCubit build() =>
      RecurringListCubit(getRules: getRules, deleteRule: deleteRule);

  blocTest<RecurringListCubit, RecurringListState>(
    'load emits [loading, loaded]',
    setUp: () => when(() => getRules(any())).thenAnswer(
      (_) async => const Right<Failure, List<RecurringRule>>([a, b]),
    ),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      RecurringListState.loading(),
      RecurringListState.loaded(rules: [a, b]),
    ],
  );

  blocTest<RecurringListCubit, RecurringListState>(
    'load failure emits [loading, error]',
    setUp: () => when(() => getRules(any())).thenAnswer(
      (_) async => const Left<Failure, List<RecurringRule>>(CacheFailure()),
    ),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      RecurringListState.loading(),
      RecurringListState.error(CacheFailure()),
    ],
  );

  blocTest<RecurringListCubit, RecurringListState>(
    'delete success deletes then reloads',
    setUp: () {
      when(
        () => deleteRule(any()),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
      when(
        () => getRules(any()),
      ).thenAnswer((_) async => const Right<Failure, List<RecurringRule>>([a]));
    },
    build: build,
    act: (cubit) => cubit.delete(b),
    expect: () => const [
      RecurringListState.loading(),
      RecurringListState.loaded(rules: [a]),
    ],
    verify: (_) => verify(() => deleteRule(b)).called(1),
  );

  blocTest<RecurringListCubit, RecurringListState>(
    'delete failure emits error',
    setUp: () => when(
      () => deleteRule(any()),
    ).thenAnswer((_) async => const Left<Failure, Unit>(CacheFailure())),
    build: build,
    act: (cubit) => cubit.delete(a),
    expect: () => const [RecurringListState.error(CacheFailure())],
    verify: (_) => verifyNever(() => getRules(any())),
  );
}
