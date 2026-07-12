import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/transaction_aggregator.dart';

/// The W2 pure aggregation helper (blueprint §6): no Flutter, no DB. Mirrors the
/// `budget_status_test` style — a local [tx] builder + grouped numeric asserts.
/// Locks the income/expense fold (transfers excluded) and the
/// expense-by-category sum (non-expense + null-category rows skipped) that Home
/// and Insight both delegate here, so the cubits' behavior is proven at the
/// helper boundary too.
void main() {
  Transaction tx({
    required TransactionType type,
    required int amount,
    int? categoryId,
  }) => Transaction(
    type: type,
    amount: amount,
    accountId: 1,
    categoryId: categoryId,
  );

  group('incomeExpense', () {
    test('sums income and expense, excluding a transfer', () {
      final result = TransactionAggregator.incomeExpense([
        tx(type: TransactionType.income, amount: 7000000),
        tx(type: TransactionType.expense, amount: 35000),
        tx(type: TransactionType.expense, amount: 45000),
        // A transfer is an internal move — excluded from both sides.
        tx(type: TransactionType.transfer, amount: 999999),
      ]);
      expect(result.income, 7000000);
      expect(result.expense, 80000);
    });

    test('a transfer-only list totals zero on both sides', () {
      final result = TransactionAggregator.incomeExpense([
        tx(type: TransactionType.transfer, amount: 500000),
        tx(type: TransactionType.transfer, amount: 250000),
      ]);
      expect(result.income, 0);
      expect(result.expense, 0);
    });

    test('an empty list totals zero on both sides', () {
      final result = TransactionAggregator.incomeExpense(const []);
      expect(result.income, 0);
      expect(result.expense, 0);
    });

    test('excludeCategoryIds drops adjustment rows from both sides', () {
      final result = TransactionAggregator.incomeExpense(
        [
          tx(type: TransactionType.income, amount: 100, categoryId: 1),
          tx(type: TransactionType.expense, amount: 40, categoryId: 2),
          // Reserved adjustments — excluded from the report totals.
          tx(type: TransactionType.income, amount: 30, categoryId: 9),
          tx(type: TransactionType.expense, amount: 20, categoryId: 8),
        ],
        excludeCategoryIds: {8, 9},
      );
      expect(result.income, 100);
      expect(result.expense, 40);
    });
  });

  group('expenseByCategory', () {
    test('sums expense amounts per category id', () {
      final byCategory = TransactionAggregator.expenseByCategory([
        tx(type: TransactionType.expense, amount: 35000, categoryId: 1),
        tx(type: TransactionType.expense, amount: 45000, categoryId: 1),
        tx(type: TransactionType.expense, amount: 18000, categoryId: 2),
      ]);
      expect(byCategory, {1: 80000, 2: 18000});
    });

    test('skips an expense with a null category id', () {
      final byCategory = TransactionAggregator.expenseByCategory([
        tx(type: TransactionType.expense, amount: 35000, categoryId: 1),
        tx(type: TransactionType.expense, amount: 12000),
      ]);
      expect(byCategory, {1: 35000});
    });

    test('excludes non-expense rows (income + transfer with a category)', () {
      final byCategory = TransactionAggregator.expenseByCategory([
        tx(type: TransactionType.income, amount: 7000000, categoryId: 3),
        tx(type: TransactionType.transfer, amount: 999999, categoryId: 1),
        tx(type: TransactionType.expense, amount: 20000, categoryId: 1),
      ]);
      expect(byCategory, {1: 20000});
    });

    test('an empty list yields an empty map', () {
      expect(TransactionAggregator.expenseByCategory(const []), isEmpty);
    });

    test('excludeCategoryIds omits a reserved (adjustment) slice', () {
      final byCategory = TransactionAggregator.expenseByCategory(
        [
          tx(type: TransactionType.expense, amount: 40, categoryId: 2),
          tx(type: TransactionType.expense, amount: 20, categoryId: 8),
        ],
        excludeCategoryIds: {8},
      );
      expect(byCategory, {2: 40});
    });
  });
}
