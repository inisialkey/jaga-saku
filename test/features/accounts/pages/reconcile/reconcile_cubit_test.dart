import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/accounts/pages/reconcile/reconcile_cubit.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockGetSystemCategory getSystemCategory;
  late MockSaveTransaction saveTransaction;
  late MockTxChangeNotifier txChanges;

  const adjIn = Category(
    id: 9,
    name: 'Penyesuaian',
    type: CategoryType.income,
    systemKey: 'adjustment_in',
  );
  const adjOut = Category(
    id: 8,
    name: 'Penyesuaian',
    type: CategoryType.expense,
    systemKey: 'adjustment_out',
  );

  final now = DateTime.now();
  final todayMillis = DateTime(
    now.year,
    now.month,
    now.day,
  ).millisecondsSinceEpoch;

  setUp(() {
    getSystemCategory = MockGetSystemCategory();
    saveTransaction = MockSaveTransaction();
    txChanges = MockTxChangeNotifier();
  });

  void stubPair({Category? inCat = adjIn, Category? outCat = adjOut}) {
    when(
      () => getSystemCategory('adjustment_in'),
    ).thenAnswer((_) async => Right<Failure, Category?>(inCat));
    when(
      () => getSystemCategory('adjustment_out'),
    ).thenAnswer((_) async => Right<Failure, Category?>(outCat));
  }

  ReconcileCubit build({required int currentBalance}) => ReconcileCubit(
    getSystemCategory: getSystemCategory,
    saveTransaction: saveTransaction,
    txChangeNotifier: txChanges,
    accountId: 1,
    currentBalance: currentBalance,
  );

  test('load resolves the pair → systemReady true', () async {
    stubPair();
    final cubit = build(currentBalance: 480000);
    await cubit.load();
    expect(cubit.state.systemReady, isTrue);
    await cubit.close();
  });

  test(
    'load with a missing id → systemReady false, confirm is a no-op (C5)',
    () async {
      stubPair(outCat: null); // adjustment_out absent (botched migration)
      when(
        () => saveTransaction(any()),
      ).thenAnswer((_) async => const Right<Failure, int>(1));

      final cubit = build(currentBalance: 100000);
      await cubit.load();
      expect(cubit.state.systemReady, isFalse);

      cubit.countedChanged(90000); // a real delta, but confirm must not write
      await cubit.confirm('Penyesuaian saldo');

      verifyNever(() => saveTransaction(any()));
      verifyNever(() => txChanges.ping());
      await cubit.close();
    },
  );

  test('load with a Left → systemReady false (C5)', () async {
    when(
      () => getSystemCategory('adjustment_in'),
    ).thenAnswer((_) async => const Left<Failure, Category?>(CacheFailure()));
    when(
      () => getSystemCategory('adjustment_out'),
    ).thenAnswer((_) async => const Right<Failure, Category?>(adjOut));

    final cubit = build(currentBalance: 480000);
    await cubit.load();
    expect(cubit.state.systemReady, isFalse);
    await cubit.close();
  });

  test('countedChanged recomputes delta', () async {
    stubPair();
    final cubit = build(currentBalance: 480000);
    await cubit.load();
    cubit.countedChanged(450000);
    expect(cubit.state.delta, -30000);
    cubit.countedChanged(500000);
    expect(cubit.state.delta, 20000);
    await cubit.close();
  });

  test(
    'confirm with counted > current writes an income adjustment_in + pings',
    () async {
      stubPair();
      when(
        () => saveTransaction(any()),
      ).thenAnswer((_) async => const Right<Failure, int>(1));

      final cubit = build(currentBalance: 450000);
      await cubit.load();
      cubit.countedChanged(480000); // delta +30000
      await cubit.confirm('Penyesuaian saldo');

      final tx =
          verify(() => saveTransaction(captureAny())).captured.single
              as Transaction;
      expect(tx.type, TransactionType.income);
      expect(tx.amount, 30000);
      expect(tx.categoryId, 9); // adjustment_in
      expect(tx.accountId, 1);
      expect(tx.date, todayMillis);
      expect(tx.note, 'Penyesuaian saldo');
      verify(() => txChanges.ping()).called(1);
      expect(cubit.state.status, ReconcileStatus.success);
      await cubit.close();
    },
  );

  test(
    'confirm with counted < current writes an expense adjustment_out (canonical)',
    () async {
      stubPair();
      when(
        () => saveTransaction(any()),
      ).thenAnswer((_) async => const Right<Failure, int>(1));

      // Counted 450k, derived 480k → delta −30k → expense 30k → balance 450k.
      final cubit = build(currentBalance: 480000);
      await cubit.load();
      cubit.countedChanged(450000);
      await cubit.confirm('Penyesuaian saldo');

      final tx =
          verify(() => saveTransaction(captureAny())).captured.single
              as Transaction;
      expect(tx.type, TransactionType.expense);
      expect(tx.amount, 30000); // positive magnitude; sign implied by type
      expect(tx.categoryId, 8); // adjustment_out
      verify(() => txChanges.ping()).called(1);
      expect(cubit.state.status, ReconcileStatus.success);
      await cubit.close();
    },
  );

  test(
    'confirm with counted == current is a no-op (noChange, no ping)',
    () async {
      stubPair();
      final cubit = build(currentBalance: 480000);
      await cubit.load();
      cubit.countedChanged(480000); // delta 0
      await cubit.confirm('Penyesuaian saldo');

      verifyNever(() => saveTransaction(any()));
      verifyNever(() => txChanges.ping());
      expect(cubit.state.status, ReconcileStatus.noChange);
      await cubit.close();
    },
  );

  test('a save Left → failure status, no ping', () async {
    stubPair();
    when(
      () => saveTransaction(any()),
    ).thenAnswer((_) async => const Left<Failure, int>(CacheFailure()));

    final cubit = build(currentBalance: 480000);
    await cubit.load();
    cubit.countedChanged(450000);
    await cubit.confirm('Penyesuaian saldo');

    expect(cubit.state.status, ReconcileStatus.failure);
    expect(cubit.state.error, isA<CacheFailure>());
    verifyNever(() => txChanges.ping());
    await cubit.close();
  });
}
