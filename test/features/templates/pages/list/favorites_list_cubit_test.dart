import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/templates/pages/list/favorites_list_cubit.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockGetFavorites getFavorites;
  late MockDeleteTxTemplate deleteTemplate;
  late MockReorderTemplates reorderTemplates;

  const a = TxTemplate(
    id: 1,
    label: 'Coffee',
    type: TransactionType.expense,
    accountId: 1,
  );
  const b = TxTemplate(
    id: 2,
    label: 'Transport',
    type: TransactionType.expense,
    accountId: 1,
  );

  setUp(() {
    getFavorites = MockGetFavorites();
    deleteTemplate = MockDeleteTxTemplate();
    reorderTemplates = MockReorderTemplates();
  });

  FavoritesListCubit build() => FavoritesListCubit(
    getFavorites: getFavorites,
    deleteTemplate: deleteTemplate,
    reorderTemplates: reorderTemplates,
  );

  blocTest<FavoritesListCubit, FavoritesListState>(
    'load emits [loading, loaded]',
    setUp: () => when(
      () => getFavorites(any()),
    ).thenAnswer((_) async => const Right<Failure, List<TxTemplate>>([a, b])),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      FavoritesListState.loading(),
      FavoritesListState.loaded(items: [a, b]),
    ],
  );

  blocTest<FavoritesListCubit, FavoritesListState>(
    'load failure emits [loading, error]',
    setUp: () => when(() => getFavorites(any())).thenAnswer(
      (_) async => const Left<Failure, List<TxTemplate>>(CacheFailure()),
    ),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      FavoritesListState.loading(),
      FavoritesListState.error(CacheFailure()),
    ],
  );

  blocTest<FavoritesListCubit, FavoritesListState>(
    'delete success hard-deletes then reloads',
    setUp: () {
      when(
        () => deleteTemplate(any()),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
      when(
        () => getFavorites(any()),
      ).thenAnswer((_) async => const Right<Failure, List<TxTemplate>>([a]));
    },
    build: build,
    act: (cubit) => cubit.delete(2),
    expect: () => const [
      FavoritesListState.loading(),
      FavoritesListState.loaded(items: [a]),
    ],
    verify: (_) => verify(() => deleteTemplate(2)).called(1),
  );

  blocTest<FavoritesListCubit, FavoritesListState>(
    'delete failure emits an error state',
    setUp: () => when(
      () => deleteTemplate(any()),
    ).thenAnswer((_) async => const Left<Failure, Unit>(CacheFailure())),
    build: build,
    act: (cubit) => cubit.delete(2),
    expect: () => const [FavoritesListState.error(CacheFailure())],
    verify: (_) => verifyNever(() => getFavorites(any())),
  );

  blocTest<FavoritesListCubit, FavoritesListState>(
    'reorder emits the optimistic order and persists the ids',
    setUp: () => when(
      () => reorderTemplates(any()),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit)),
    build: build,
    seed: () => const FavoritesListState.loaded(items: [a, b]),
    act: (cubit) => cubit.reorder(0, 1),
    expect: () => const [
      FavoritesListState.loaded(items: [b, a]),
    ],
    verify: (_) {
      final captured = verify(() => reorderTemplates(captureAny())).captured;
      expect(captured.single, [2, 1]);
    },
  );
}
