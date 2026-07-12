import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/get_due_occurrences.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// The catch-up projection: reads rules, projects due occurrences, sorts them,
/// and writes NOTHING. Anchored to the real "today" the usecase computes.
void main() {
  setUpAll(registerFallbackValues);

  late MockRecurringRepository repository;

  final now = DateTime.now();
  int day(int offset) =>
      DateTime(now.year, now.month, now.day + offset).millisecondsSinceEpoch;

  const template = TxTemplate(
    label: 'Rent',
    type: TransactionType.expense,
    accountId: 1,
    amount: 50000,
  );

  RecurringRule dailyRule({required int id, required int startOffset}) =>
      RecurringRule(
        id: id,
        templateId: id,
        freq: RecurrenceFreq.daily,
        startDate: day(startOffset),
        nextDue: day(startOffset),
        template: template,
      );

  setUp(() => repository = MockRecurringRepository());

  test('projects sorted pending across rules and writes nothing', () async {
    when(() => repository.getRules()).thenAnswer(
      (_) async => Right<Failure, List<RecurringRule>>([
        dailyRule(id: 1, startOffset: -2), // [d-2, d-1, d0] → 3
        dailyRule(id: 2, startOffset: -1), // [d-1, d0]      → 2
      ]),
    );

    final result = await GetDueOccurrences(repository)(NoParams());
    final pending = result.getRight().toNullable()!;

    expect(pending, hasLength(5));
    // Globally ascending by dueDate.
    for (var i = 1; i < pending.length; i++) {
      expect(pending[i].dueDate >= pending[i - 1].dueDate, isTrue);
    }
    // A pure projection — no cursor advance, no write.
    verifyNever(() => repository.advanceCursor(any(), any()));
  });

  test(
    're-projecting without confirming re-surfaces the identical set',
    () async {
      when(() => repository.getRules()).thenAnswer(
        (_) async => Right<Failure, List<RecurringRule>>([
          dailyRule(id: 1, startOffset: -2),
        ]),
      );

      final first = (await GetDueOccurrences(repository)(
        NoParams(),
      )).getRight().toNullable()!;
      final again = (await GetDueOccurrences(repository)(
        NoParams(),
      )).getRight().toNullable()!;

      expect(again.map((o) => o.dueDate), first.map((o) => o.dueDate));
    },
  );

  test('a future-start rule yields no pending', () async {
    when(() => repository.getRules()).thenAnswer(
      (_) async => Right<Failure, List<RecurringRule>>([
        dailyRule(id: 1, startOffset: 5), // cursor > today
      ]),
    );

    final result = await GetDueOccurrences(repository)(NoParams());

    expect(result.getRight().toNullable(), isEmpty);
  });

  test('a getRules failure propagates as Left', () async {
    when(() => repository.getRules()).thenAnswer(
      (_) async => const Left<Failure, List<RecurringRule>>(CacheFailure()),
    );

    final result = await GetDueOccurrences(repository)(NoParams());

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });
}
