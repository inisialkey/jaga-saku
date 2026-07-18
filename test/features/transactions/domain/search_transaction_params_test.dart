import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction_source.dart';

/// Pure unit tests for the shared search params value object (V3-M3): the
/// [TransactionSource] derivation and the three derived getters that drive the
/// UI (`hasQuery`, `isAmountRangeValid`, `activeFilterCount`). No Flutter / DB.
void main() {
  group('TransactionSource.fromSystemKey', () {
    test('null → manual', () {
      expect(TransactionSource.fromSystemKey(null), TransactionSource.manual);
    });

    test('a normal category key → manual', () {
      expect(
        TransactionSource.fromSystemKey('groceries'),
        TransactionSource.manual,
      );
    });

    test('adjustment_in → reconciliation', () {
      expect(
        TransactionSource.fromSystemKey('adjustment_in'),
        TransactionSource.reconciliation,
      );
    });

    test('adjustment_out → reconciliation', () {
      expect(
        TransactionSource.fromSystemKey('adjustment_out'),
        TransactionSource.reconciliation,
      );
    });

    test('adjustmentSystemKeys is exactly the reserved pair', () {
      expect(TransactionSource.adjustmentSystemKeys, {
        'adjustment_in',
        'adjustment_out',
      });
    });
  });

  group('hasQuery', () {
    test('defaults to false', () {
      expect(const SearchTransactionParams().hasQuery, isFalse);
    });

    test('a non-empty keyword → true', () {
      expect(const SearchTransactionParams(keyword: 'bca').hasQuery, isTrue);
    });

    test('a whitespace-only keyword → false', () {
      expect(const SearchTransactionParams(keyword: '   ').hasQuery, isFalse);
    });

    test('sort-only → false (sort is not a facet)', () {
      expect(
        const SearchTransactionParams(sort: SortOption.highest).hasQuery,
        isFalse,
      );
    });

    test('any single facet → true', () {
      expect(const SearchTransactionParams(accountId: 1).hasQuery, isTrue);
    });

    test('hasReceipt:false still counts as an active facet → true', () {
      expect(const SearchTransactionParams(hasReceipt: false).hasQuery, isTrue);
    });
  });

  group('isAmountRangeValid', () {
    test('both null → true', () {
      expect(const SearchTransactionParams().isAmountRangeValid, isTrue);
    });

    test('min only → true', () {
      expect(
        const SearchTransactionParams(minAmount: 100).isAmountRangeValid,
        isTrue,
      );
    });

    test('max only → true', () {
      expect(
        const SearchTransactionParams(maxAmount: 100).isAmountRangeValid,
        isTrue,
      );
    });

    test('min < max → true', () {
      expect(
        const SearchTransactionParams(
          minAmount: 100,
          maxAmount: 200,
        ).isAmountRangeValid,
        isTrue,
      );
    });

    test('min == max → true', () {
      expect(
        const SearchTransactionParams(
          minAmount: 100,
          maxAmount: 100,
        ).isAmountRangeValid,
        isTrue,
      );
    });

    test('min > max → false', () {
      expect(
        const SearchTransactionParams(
          minAmount: 300,
          maxAmount: 200,
        ).isAmountRangeValid,
        isFalse,
      );
    });
  });

  group('activeFilterCount', () {
    test('defaults to 0', () {
      expect(const SearchTransactionParams().activeFilterCount, 0);
    });

    test('ignores the keyword and sort', () {
      expect(
        const SearchTransactionParams(
          keyword: 'x',
          sort: SortOption.oldest,
        ).activeFilterCount,
        0,
      );
    });

    test('the date range counts once (start only)', () {
      expect(const SearchTransactionParams(startDate: 1).activeFilterCount, 1);
    });

    test('the date range counts once (both bounds)', () {
      expect(
        const SearchTransactionParams(
          startDate: 1,
          endDate: 2,
        ).activeFilterCount,
        1,
      );
    });

    test('min and max amount count separately', () {
      expect(
        const SearchTransactionParams(
          minAmount: 1,
          maxAmount: 2,
        ).activeFilterCount,
        2,
      );
    });

    test('three distinct facets → 3', () {
      expect(
        const SearchTransactionParams(
          accountId: 1,
          type: TransactionType.income,
          hasReceipt: true,
        ).activeFilterCount,
        3,
      );
    });

    test('every facet set → 10 (date counts once)', () {
      const p = SearchTransactionParams(
        startDate: 1,
        endDate: 2,
        accountId: 3,
        categoryId: 4,
        type: TransactionType.expense,
        source: TransactionSource.manual,
        minAmount: 5,
        maxAmount: 6,
        plannedStatus: PlannedStatus.planned,
        spendingType: SpendingType.need,
        hasReceipt: true,
      );
      expect(p.activeFilterCount, 10);
    });
  });
}
