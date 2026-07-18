import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/search/search_transaction_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// State-machine tests for [SearchTransactionCubit]: the debounce coalescing,
/// results / empty / failure folds, the back-to-defaults short-circuit, the
/// clear/reset/chip-removal semantics and the live refresh on a
/// [TxChangeNotifier] ping. A real `TxChangeNotifier` is used (it is trivially
/// constructible and disposable — no mock needed).
void main() {
  setUpAll(registerFallbackValues);

  late MockSearchTransactions searchTransactions;
  late MockGetAccounts getAccounts;
  late MockGetCategories getCategories;
  late TxChangeNotifier txChanges;

  const tx = Transaction(
    id: 1,
    type: TransactionType.expense,
    amount: 1000,
    accountId: 1,
  );

  SearchTransactionCubit build() => SearchTransactionCubit(
    searchTransactions: searchTransactions,
    getAccounts: getAccounts,
    getCategories: getCategories,
    txChangeNotifier: txChanges,
  );

  setUp(() {
    searchTransactions = MockSearchTransactions();
    getAccounts = MockGetAccounts();
    getCategories = MockGetCategories();
    txChanges = TxChangeNotifier();
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Account>>([]));
    when(
      () => getCategories(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([]));
    when(
      () => searchTransactions(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([tx]));
  });

  tearDown(() => txChanges.dispose());

  blocTest<SearchTransactionCubit, SearchTransactionState>(
    'setKeyword debounces a burst into ONE query → [loading, results]',
    build: build,
    act: (cubit) => cubit
      ..setKeyword('b')
      ..setKeyword('bc')
      ..setKeyword('bca'),
    wait: const Duration(milliseconds: 350),
    expect: () => [
      isA<SearchLoading>().having((s) => s.params.keyword, 'keyword', 'bca'),
      isA<SearchResults>().having((s) => s.items, 'items', [tx]),
    ],
    verify: (_) => verify(() => searchTransactions(any())).called(1),
  );

  blocTest<SearchTransactionCubit, SearchTransactionState>(
    'a filter with zero matches → [loading, empty]',
    setUp: () => when(
      () => searchTransactions(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Transaction>>([])),
    build: build,
    act: (cubit) =>
        cubit.updateFilters(const SearchTransactionParams(accountId: 1)),
    expect: () => [
      isA<SearchLoading>(),
      isA<SearchEmpty>().having((s) => s.params.accountId, 'accountId', 1),
    ],
  );

  blocTest<SearchTransactionCubit, SearchTransactionState>(
    'a repository failure → [loading, failure]',
    setUp: () => when(() => searchTransactions(any())).thenAnswer(
      (_) async => const Left<Failure, List<Transaction>>(CacheFailure()),
    ),
    build: build,
    act: (cubit) => cubit.updateFilters(
      const SearchTransactionParams(type: TransactionType.income),
    ),
    expect: () => [
      isA<SearchLoading>(),
      isA<SearchFailure>().having(
        (s) => s.failure,
        'failure',
        const CacheFailure(),
      ),
    ],
  );

  blocTest<SearchTransactionCubit, SearchTransactionState>(
    'updateFilters back to default params → [initial], never queries',
    build: build,
    act: (cubit) => cubit.updateFilters(const SearchTransactionParams()),
    expect: () => [isA<SearchInitial>()],
    verify: (_) => verifyNever(() => searchTransactions(any())),
  );

  blocTest<SearchTransactionCubit, SearchTransactionState>(
    'clearFilters drops facets but keeps the keyword',
    build: build,
    act: (cubit) async {
      await cubit.updateFilters(
        const SearchTransactionParams(keyword: 'bca', accountId: 1),
      );
      await cubit.clearFilters();
    },
    skip: 2, // [loading, results] from the first updateFilters
    expect: () => [
      isA<SearchLoading>()
          .having((s) => s.params.keyword, 'keyword', 'bca')
          .having((s) => s.params.accountId, 'accountId', null),
      isA<SearchResults>().having((s) => s.params.keyword, 'keyword', 'bca'),
    ],
  );

  blocTest<SearchTransactionCubit, SearchTransactionState>(
    'reset → initial with default params',
    build: build,
    act: (cubit) async {
      await cubit.updateFilters(const SearchTransactionParams(accountId: 1));
      cubit.reset();
    },
    skip: 2,
    expect: () => [
      isA<SearchInitial>().having(
        (s) => s.params,
        'params',
        const SearchTransactionParams(),
      ),
    ],
  );

  blocTest<SearchTransactionCubit, SearchTransactionState>(
    'chip removal drops one facet and retains the siblings',
    build: build,
    act: (cubit) async {
      await cubit.updateFilters(
        const SearchTransactionParams(accountId: 1, categoryId: 2),
      );
      await cubit.updateFilters(
        const SearchTransactionParams(
          accountId: 1,
          categoryId: 2,
        ).copyWith(categoryId: null),
      );
    },
    skip: 2,
    expect: () => [
      isA<SearchLoading>()
          .having((s) => s.params.accountId, 'accountId', 1)
          .having((s) => s.params.categoryId, 'categoryId', null),
      isA<SearchResults>().having((s) => s.params.accountId, 'accountId', 1),
    ],
  );

  blocTest<SearchTransactionCubit, SearchTransactionState>(
    'a TxChangeNotifier ping re-runs the current search',
    build: build,
    act: (cubit) async {
      await cubit.updateFilters(const SearchTransactionParams(accountId: 1));
      txChanges.ping();
    },
    skip: 2,
    wait: const Duration(milliseconds: 100),
    expect: () => [isA<SearchLoading>(), isA<SearchResults>()],
    verify: (_) => verify(() => searchTransactions(any())).called(2),
  );

  blocTest<SearchTransactionCubit, SearchTransactionState>(
    'a ping while on the prompt (no active query) is ignored',
    build: build,
    act: (cubit) => txChanges.ping(),
    wait: const Duration(milliseconds: 50),
    expect: () => <SearchTransactionState>[],
    verify: (_) => verifyNever(() => searchTransactions(any())),
  );

  test('loadOptions folds a Left to empty option lists', () async {
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Left<Failure, List<Account>>(CacheFailure()),
    );
    final cubit = build();
    await cubit.loadOptions();
    expect(cubit.accountOptions, isEmpty);
    expect(cubit.categoryOptions, isEmpty);
    await cubit.close();
  });

  test(
    'loadOptions exposes accounts + non-archived non-system categories',
    () async {
      when(() => getAccounts(any())).thenAnswer(
        (_) async => const Right<Failure, List<Account>>([
          Account(id: 1, name: 'Cash', type: AccountType.cash),
          Account(id: 2, name: 'Old', type: AccountType.bank, archived: true),
        ]),
      );
      when(() => getCategories(CategoryType.expense)).thenAnswer(
        (_) async => const Right<Failure, List<Category>>([
          Category(id: 1, name: 'Makan', type: CategoryType.expense),
          Category(
            id: 8,
            name: 'Penyesuaian',
            type: CategoryType.expense,
            systemKey: 'adjustment_out',
          ),
        ]),
      );
      when(() => getCategories(CategoryType.income)).thenAnswer(
        (_) async => const Right<Failure, List<Category>>([
          Category(id: 7, name: 'Gaji', type: CategoryType.income),
        ]),
      );

      final cubit = build();
      await cubit.loadOptions();

      // All accounts (incl. archived) are offered for historical search.
      expect(cubit.accountOptions.map((a) => a.id), [1, 2]);
      // System category (id 8) is excluded from the picker options…
      expect(cubit.categoryOptions.map((c) => c.id), [1, 7]);
      // …but still resolves a name for a result row (id-based lookup).
      expect(cubit.categoryName(8), 'Penyesuaian');
      expect(cubit.accountName(2), 'Old');
      await cubit.close();
    },
  );
}
