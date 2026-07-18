import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/transaction_aggregator.dart';

import '../../../helpers/ledger_fixtures.dart';

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
    PlannedStatus? plannedStatus,
    SpendingType? spendingType,
  }) => Transaction(
    type: type,
    amount: amount,
    accountId: 1,
    categoryId: categoryId,
    plannedStatus: plannedStatus,
    spendingType: spendingType,
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

  group('systemCategoryIds', () {
    test('resolves the isSystem ids from a mixed category list', () {
      const normal = Category(id: 1, name: 'Makan', type: CategoryType.expense);
      expect(
        TransactionAggregator.systemCategoryIds([
          normal,
          penyesuaianOut,
          penyesuaianIn,
        ]),
        {8, 9},
      );
    });

    test('skips a system category with a null id', () {
      const unsavedSystem = Category(
        name: 'Penyesuaian',
        type: CategoryType.expense,
        systemKey: 'adjustment_out',
      );
      expect(TransactionAggregator.systemCategoryIds([unsavedSystem]), isEmpty);
    });

    test('a list with no system categories resolves empty', () {
      const normal = Category(id: 1, name: 'Makan', type: CategoryType.expense);
      expect(TransactionAggregator.systemCategoryIds([normal]), isEmpty);
    });

    test('an empty list resolves empty', () {
      expect(
        TransactionAggregator.systemCategoryIds(const <Category>[]),
        isEmpty,
      );
    });
  });

  group('spentAndUnplanned', () {
    test('sums expense as spent and the unplanned subset', () {
      final result = TransactionAggregator.spentAndUnplanned([
        tx(
          type: TransactionType.expense,
          amount: 50000,
          plannedStatus: PlannedStatus.planned,
        ),
        tx(
          type: TransactionType.expense,
          amount: 30000,
          plannedStatus: PlannedStatus.unplanned,
        ),
        // A null-status expense still counts toward spent (not an adjustment).
        tx(type: TransactionType.expense, amount: 18000),
      ]);
      expect(result.spent, 98000);
      expect(result.unplanned, 30000);
    });

    test('a null-category expense counts toward spent', () {
      final result = TransactionAggregator.spentAndUnplanned([
        tx(type: TransactionType.expense, amount: 12000),
      ]);
      expect(result.spent, 12000);
      expect(result.unplanned, 0);
    });

    test('income and transfers are skipped', () {
      final result = TransactionAggregator.spentAndUnplanned([
        tx(type: TransactionType.income, amount: 7000000, categoryId: 3),
        tx(type: TransactionType.transfer, amount: 999999),
        tx(type: TransactionType.expense, amount: 20000, categoryId: 1),
      ]);
      expect(result.spent, 20000);
      expect(result.unplanned, 0);
    });

    test('excludeCategoryIds drops an adjustment from spent', () {
      final result = TransactionAggregator.spentAndUnplanned(
        [
          tx(type: TransactionType.expense, amount: 40, categoryId: 1),
          tx(
            type: TransactionType.expense,
            amount: 30,
            categoryId: 8,
            plannedStatus: PlannedStatus.unplanned,
          ),
        ],
        excludeCategoryIds: {8},
      );
      expect(result.spent, 40);
      expect(result.unplanned, 0);
    });

    test('an empty list totals zero', () {
      final result = TransactionAggregator.spentAndUnplanned(const []);
      expect(result.spent, 0);
      expect(result.unplanned, 0);
    });
  });

  group('plannedSplit', () {
    test('sums planned and unplanned over the typed subset', () {
      final result = TransactionAggregator.plannedSplit([
        tx(
          type: TransactionType.expense,
          amount: 1600000,
          plannedStatus: PlannedStatus.planned,
        ),
        tx(
          type: TransactionType.expense,
          amount: 400000,
          plannedStatus: PlannedStatus.unplanned,
        ),
      ]);
      expect(result.planned, 1600000);
      expect(result.unplanned, 400000);
    });

    test('null-status expenses are excluded from the split', () {
      final result = TransactionAggregator.plannedSplit([
        tx(
          type: TransactionType.expense,
          amount: 500000,
          plannedStatus: PlannedStatus.planned,
        ),
        tx(type: TransactionType.expense, amount: 250000),
      ]);
      expect(result.planned, 500000);
      expect(result.unplanned, 0);
    });

    test('excludeCategoryIds drops an adjustment', () {
      final result = TransactionAggregator.plannedSplit(
        [
          tx(
            type: TransactionType.expense,
            amount: 100,
            categoryId: 1,
            plannedStatus: PlannedStatus.planned,
          ),
          tx(
            type: TransactionType.expense,
            amount: 30,
            categoryId: 8,
            plannedStatus: PlannedStatus.planned,
          ),
        ],
        excludeCategoryIds: {8},
      );
      expect(result.planned, 100);
      expect(result.unplanned, 0);
    });

    test('an empty list totals zero', () {
      final result = TransactionAggregator.plannedSplit(const []);
      expect(result.planned, 0);
      expect(result.unplanned, 0);
    });
  });

  group('needVsWant', () {
    test('groups typed expense by spending type', () {
      final byType = TransactionAggregator.needVsWant([
        tx(
          type: TransactionType.expense,
          amount: 1000000,
          spendingType: SpendingType.need,
        ),
        tx(
          type: TransactionType.expense,
          amount: 600000,
          spendingType: SpendingType.need,
        ),
        tx(
          type: TransactionType.expense,
          amount: 400000,
          spendingType: SpendingType.want,
        ),
      ]);
      expect(byType, {SpendingType.need: 1600000, SpendingType.want: 400000});
    });

    test('null-type expenses are excluded', () {
      final byType = TransactionAggregator.needVsWant([
        tx(
          type: TransactionType.expense,
          amount: 500000,
          spendingType: SpendingType.need,
        ),
        tx(type: TransactionType.expense, amount: 250000),
      ]);
      expect(byType, {SpendingType.need: 500000});
    });

    test('excludeCategoryIds drops an adjustment', () {
      final byType = TransactionAggregator.needVsWant(
        [
          tx(
            type: TransactionType.expense,
            amount: 100,
            categoryId: 1,
            spendingType: SpendingType.need,
          ),
          tx(
            type: TransactionType.expense,
            amount: 30,
            categoryId: 8,
            spendingType: SpendingType.need,
          ),
        ],
        excludeCategoryIds: {8},
      );
      expect(byType, {SpendingType.need: 100});
    });

    test('an empty list yields an empty map', () {
      expect(TransactionAggregator.needVsWant(const []), isEmpty);
    });
  });

  group('biggestExpense', () {
    test('returns the largest expense', () {
      final biggest = TransactionAggregator.biggestExpense([
        tx(type: TransactionType.expense, amount: 100000, categoryId: 1),
        tx(type: TransactionType.expense, amount: 1000000, categoryId: 2),
        tx(type: TransactionType.expense, amount: 50000, categoryId: 3),
      ]);
      expect(biggest?.amount, 1000000);
      expect(biggest?.categoryId, 2);
    });

    test('the first row wins a tie on equal amount', () {
      final biggest = TransactionAggregator.biggestExpense([
        tx(type: TransactionType.expense, amount: 500000, categoryId: 1),
        tx(type: TransactionType.expense, amount: 500000, categoryId: 2),
      ]);
      expect(biggest?.categoryId, 1);
    });

    test('excludeCategoryIds skips a bigger adjustment', () {
      final biggest = TransactionAggregator.biggestExpense(
        [
          tx(type: TransactionType.expense, amount: 100000, categoryId: 1),
          tx(type: TransactionType.expense, amount: 300000, categoryId: 8),
        ],
        excludeCategoryIds: {8},
      );
      expect(biggest?.amount, 100000);
      expect(biggest?.categoryId, 1);
    });

    test('income and transfers are ignored', () {
      final biggest = TransactionAggregator.biggestExpense([
        tx(type: TransactionType.income, amount: 9000000, categoryId: 3),
        tx(type: TransactionType.transfer, amount: 8000000),
        tx(type: TransactionType.expense, amount: 20000, categoryId: 1),
      ]);
      expect(biggest?.amount, 20000);
    });

    test('a list with no expense returns null', () {
      final biggest = TransactionAggregator.biggestExpense([
        tx(type: TransactionType.income, amount: 100, categoryId: 3),
      ]);
      expect(biggest, isNull);
    });
  });
}
