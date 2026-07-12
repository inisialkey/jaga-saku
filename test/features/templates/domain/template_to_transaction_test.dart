import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/templates/domain/template_to_transaction.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// Pure-helper contract (rule 19): amount resolution + type-specific shaping,
/// mirroring `AddTransactionCubit._commit`. No Flutter / DB / clock.
void main() {
  const date = 1234567890;

  TxTemplate template({
    TransactionType type = TransactionType.expense,
    int? amount = 15000,
    int accountId = 1,
    int? toAccountId,
    int? categoryId = 5,
    PlannedStatus? plannedStatus = PlannedStatus.planned,
    SpendingType? spendingType = SpendingType.need,
    String? note = 'Kopi',
  }) => TxTemplate(
    label: 'Coffee',
    type: type,
    accountId: accountId,
    amount: amount,
    toAccountId: toAccountId,
    categoryId: categoryId,
    plannedStatus: plannedStatus,
    spendingType: spendingType,
    note: note,
  );

  test('amount override wins over the template amount', () {
    final tx = templateToTransaction(template(), date: date, amount: 99000);
    expect(tx.amount, 99000);
  });

  test('a null override falls back to the template amount', () {
    final tx = templateToTransaction(template(), date: date);
    expect(tx.amount, 15000);
  });

  test('both amounts null throws an assertion error', () {
    expect(
      () => templateToTransaction(template(amount: null), date: date),
      throwsA(isA<AssertionError>()),
    );
  });

  test('the passed date flows through', () {
    final tx = templateToTransaction(template(), date: date);
    expect(tx.date, date);
  });

  test('expense keeps planned/spending and drops the transfer destination', () {
    final tx = templateToTransaction(
      template(
        toAccountId: 2,
        plannedStatus: PlannedStatus.unplanned,
        spendingType: SpendingType.want,
      ),
      date: date,
    );
    expect(tx.type, TransactionType.expense);
    expect(tx.categoryId, 5);
    expect(tx.plannedStatus, PlannedStatus.unplanned);
    expect(tx.spendingType, SpendingType.want);
    expect(tx.toAccountId, isNull);
  });

  test('transfer keeps toAccountId and drops category/planned/spending', () {
    final tx = templateToTransaction(
      template(type: TransactionType.transfer, toAccountId: 2),
      date: date,
    );
    expect(tx.type, TransactionType.transfer);
    expect(tx.toAccountId, 2);
    expect(tx.categoryId, isNull);
    expect(tx.plannedStatus, isNull);
    expect(tx.spendingType, isNull);
  });

  test('income drops toAccountId, planned and spending', () {
    final tx = templateToTransaction(
      template(type: TransactionType.income, toAccountId: 2),
      date: date,
    );
    expect(tx.type, TransactionType.income);
    expect(tx.categoryId, 5);
    expect(tx.toAccountId, isNull);
    expect(tx.plannedStatus, isNull);
    expect(tx.spendingType, isNull);
  });
}
