import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/pages/review/recurring_review_cubit.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockGetDueOccurrences getDueOccurrences;
  late MockConfirmOccurrence confirmOccurrence;
  late MockSkipOccurrence skipOccurrence;
  late TxChangeNotifier txChanges;

  const template = TxTemplate(
    label: 'Rent',
    type: TransactionType.expense,
    accountId: 1,
    amount: 50000,
  );
  const rule = RecurringRule(
    id: 1,
    templateId: 1,
    freq: RecurrenceFreq.monthly,
    startDate: 0,
    nextDue: 0,
  );
  PendingOccurrence occ(int dueDate) =>
      PendingOccurrence(rule: rule, template: template, dueDate: dueDate);

  setUp(() {
    getDueOccurrences = MockGetDueOccurrences();
    confirmOccurrence = MockConfirmOccurrence();
    skipOccurrence = MockSkipOccurrence();
    txChanges = TxChangeNotifier();
  });

  tearDown(() => txChanges.dispose());

  RecurringReviewCubit build() => RecurringReviewCubit(
    getDueOccurrences: getDueOccurrences,
    confirmOccurrence: confirmOccurrence,
    skipOccurrence: skipOccurrence,
    txChangeNotifier: txChanges,
  );

  test('load emits loaded with the pending occurrences', () async {
    when(() => getDueOccurrences(any())).thenAnswer(
      (_) async => Right<Failure, List<PendingOccurrence>>([occ(1), occ(2)]),
    );

    final cubit = build();
    await cubit.load();

    final state = cubit.state;
    expect(state, isA<RecurringReviewLoaded>());
    expect((state as RecurringReviewLoaded).pending, hasLength(2));
    await cubit.close();
  });

  test('load emits empty when there is nothing to confirm', () async {
    when(() => getDueOccurrences(any())).thenAnswer(
      (_) async => const Right<Failure, List<PendingOccurrence>>([]),
    );

    final cubit = build();
    await cubit.load();

    expect(cubit.state, isA<RecurringReviewEmpty>());
    await cubit.close();
  });

  test('load emits error on a Left', () async {
    when(() => getDueOccurrences(any())).thenAnswer(
      (_) async => const Left<Failure, List<PendingOccurrence>>(CacheFailure()),
    );

    final cubit = build();
    await cubit.load();

    expect(cubit.state, isA<RecurringReviewError>());
    await cubit.close();
  });

  test('confirm one re-projects (leaves the rest) and pings', () async {
    var loadCall = 0;
    when(() => getDueOccurrences(any())).thenAnswer((_) async {
      loadCall++;
      // First projection has both; after one confirm the cursor moved, so the
      // re-projection returns only the second.
      return Right<Failure, List<PendingOccurrence>>(
        loadCall == 1 ? [occ(1), occ(2)] : [occ(2)],
      );
    });
    when(
      () => confirmOccurrence(any()),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

    var pinged = 0;
    final sub = txChanges.changes.listen((_) => pinged++);

    final cubit = build();
    await cubit.load();
    await cubit.confirm(occ(1));

    final state = cubit.state;
    expect((state as RecurringReviewLoaded).pending, [occ(2)]);
    verify(() => confirmOccurrence(occ(1))).called(1);
    await pumpEventQueue();
    expect(pinged, 1);

    await sub.cancel();
    await cubit.close();
  });

  test('confirmAll confirms every occurrence then clears the list', () async {
    var loadCall = 0;
    when(() => getDueOccurrences(any())).thenAnswer((_) async {
      loadCall++;
      return Right<Failure, List<PendingOccurrence>>(
        loadCall == 1 ? [occ(1), occ(2)] : const [],
      );
    });
    when(
      () => confirmOccurrence(any()),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

    final cubit = build();
    await cubit.load();
    await cubit.confirmAll();

    expect(cubit.state, isA<RecurringReviewEmpty>());
    verify(() => confirmOccurrence(any())).called(2);
    await cubit.close();
  });

  test(
    'skip advances the cursor (drops the item) without confirming',
    () async {
      var loadCall = 0;
      when(() => getDueOccurrences(any())).thenAnswer((_) async {
        loadCall++;
        return Right<Failure, List<PendingOccurrence>>(
          loadCall == 1 ? [occ(1)] : const [],
        );
      });
      when(
        () => skipOccurrence(any()),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final cubit = build();
      await cubit.load();
      await cubit.skip(occ(1));

      expect(cubit.state, isA<RecurringReviewEmpty>());
      verify(() => skipOccurrence(occ(1))).called(1);
      verifyNever(() => confirmOccurrence(any()));
      await cubit.close();
    },
  );

  test('a confirm failure surfaces an error state', () async {
    when(() => getDueOccurrences(any())).thenAnswer(
      (_) async => Right<Failure, List<PendingOccurrence>>([occ(1)]),
    );
    when(
      () => confirmOccurrence(any()),
    ).thenAnswer((_) async => const Left<Failure, Unit>(CacheFailure()));

    final cubit = build();
    await cubit.load();
    await cubit.confirm(occ(1));

    expect(cubit.state, isA<RecurringReviewError>());
    await cubit.close();
  });
}
