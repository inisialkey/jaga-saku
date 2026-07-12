import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/recurrence_schedule.dart';
import 'package:jaga_saku/features/recurring/domain/repositories/recurring_repository.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/confirm_occurrence.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/get_due_occurrences.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// A minimal stateful [RecurringRepository] for the project → confirm →
/// re-project idempotency loop: `advanceCursor` mutates the stored rule's
/// `next_due` in place, so a subsequent `getRules` reflects the moved cursor.
class _FakeRecurringRepository implements RecurringRepository {
  _FakeRecurringRepository(this._rules);

  List<RecurringRule> _rules;

  @override
  Future<Either<Failure, List<RecurringRule>>> getRules() async =>
      Right(_rules);

  @override
  Future<Either<Failure, Unit>> advanceCursor(int ruleId, int nextDue) async {
    _rules = _rules
        .map((r) => r.id == ruleId ? r.copyWith(nextDue: nextDue) : r)
        .toList();
    return const Right(unit);
  }

  @override
  Future<Either<Failure, int>> insertRuleWithTemplate(
    TxTemplate template,
    RecurringRule rule,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, Unit>> updateRule(
    TxTemplate template,
    RecurringRule rule,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, Unit>> deleteRule(int templateId) =>
      throw UnimplementedError();
}

void main() {
  setUpAll(registerFallbackValues);

  late MockSaveTransaction saveTransaction;
  late MockRecurringRepository repository;

  const template = TxTemplate(
    label: 'Rent',
    type: TransactionType.expense,
    accountId: 1,
    amount: 50000,
  );

  final start = DateTime(2025, 1, 31).millisecondsSinceEpoch;
  final rule = RecurringRule(
    id: 7,
    templateId: 3,
    freq: RecurrenceFreq.monthly,
    startDate: start,
    nextDue: start,
    template: template,
  );

  PendingOccurrence occ(int dueDate) =>
      PendingOccurrence(rule: rule, template: template, dueDate: dueDate);

  setUp(() {
    saveTransaction = MockSaveTransaction();
    repository = MockRecurringRepository();
  });

  test(
    'confirm writes a tx at the due date and advances to the next occurrence',
    () async {
      when(
        () => saveTransaction(any()),
      ).thenAnswer((_) async => const Right<Failure, int>(1));
      when(
        () => repository.advanceCursor(any(), any()),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final result = await ConfirmOccurrence(saveTransaction, repository)(
        occ(start),
      );

      expect(result.isRight(), isTrue);
      // The written transaction lands at the TRUE due date.
      final tx =
          verify(() => saveTransaction(captureAny())).captured.single
              as Transaction;
      expect(tx.date, start);
      // The cursor advances to nextOccurrence(dueDate), NOT today (C1).
      final expectedNext = RecurrenceSchedule.nextOccurrence(
        start,
        RecurrenceFreq.monthly,
        1,
        startDate: start,
      );
      verify(() => repository.advanceCursor(7, expectedNext)).called(1);
    },
  );

  test('a failed save does NOT advance the cursor', () async {
    when(
      () => saveTransaction(any()),
    ).thenAnswer((_) async => const Left<Failure, int>(CacheFailure()));

    final result = await ConfirmOccurrence(saveTransaction, repository)(
      occ(start),
    );

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
    verifyNever(() => repository.advanceCursor(any(), any()));
  });

  test(
    'idempotency (C1): a 3-overdue rule leaves the rest after one confirm',
    () async {
      when(
        () => saveTransaction(any()),
      ).thenAnswer((_) async => const Right<Failure, int>(1));

      // A monthly rule anchored well in the past → several overdue occurrences.
      final fake = _FakeRecurringRepository([rule]);
      final getDue = GetDueOccurrences(fake);
      final confirm = ConfirmOccurrence(saveTransaction, fake);

      final first = (await getDue(NoParams())).getRight().toNullable()!;
      // Re-projecting WITHOUT confirming re-surfaces the identical set.
      final firstAgain = (await getDue(NoParams())).getRight().toNullable()!;
      expect(firstAgain.map((o) => o.dueDate), first.map((o) => o.dueDate));
      expect(first.length, greaterThanOrEqualTo(3));

      // Confirm the earliest overdue occurrence.
      await confirm(first.first);

      final after = (await getDue(NoParams())).getRight().toNullable()!;
      // Exactly one fewer, and the cursor advanced to the SECOND occurrence.
      expect(after.length, first.length - 1);
      expect(after.first.dueDate, first[1].dueDate);
    },
  );
}
