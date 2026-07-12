import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/recurrence_schedule.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/skip_occurrence.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// Skip advances the cursor to the next occurrence WITHOUT writing a tx.
void main() {
  setUpAll(registerFallbackValues);

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

  setUp(() => repository = MockRecurringRepository());

  test('skip advances the cursor to the next occurrence, no tx', () async {
    when(
      () => repository.advanceCursor(any(), any()),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

    final result = await SkipOccurrence(repository)(
      PendingOccurrence(rule: rule, template: template, dueDate: start),
    );

    expect(result.isRight(), isTrue);
    final expectedNext = RecurrenceSchedule.nextOccurrence(
      start,
      RecurrenceFreq.monthly,
      1,
      startDate: start,
    );
    verify(() => repository.advanceCursor(7, expectedNext)).called(1);
  });
}
