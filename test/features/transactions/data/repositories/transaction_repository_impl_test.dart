import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/transactions/data/models/transaction_model.dart';
import 'package:jaga_saku/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';
// sqflite_ffi re-exports sqflite's `Transaction`; hide it to avoid clashing with
// the domain entity.
import 'package:sqflite_common_ffi/sqflite_ffi.dart' hide Transaction;

import '../../../../helpers/mocks.dart';

/// Repository maps datasource outcomes to `Either<Failure, T>` and never throws.
/// A real sqflite [DatabaseException] (a NOT NULL violation) is captured once so
/// the generic → [CacheFailure] mapping is tested against a genuine exception.
void main() {
  late DatabaseException genericError;

  setUpAll(() async {
    registerFallbackValues();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: Migrations.latestVersion,
        onCreate: (db, _) => Migrations.onCreate(db),
      ),
    );
    try {
      // `amount` is NOT NULL — omitting it is a generic constraint violation.
      await db.insert('transactions', {
        'type': 'expense',
        'account_id': 1,
        'date': 0,
        'created_at': 0,
      });
    } on DatabaseException catch (e) {
      genericError = e;
    }
    await db.close();
  });

  late MockTransactionLocalDatasource datasource;
  late MockReceiptStorageService receiptStorage;
  late TransactionRepositoryImpl repository;

  const transaction = Transaction(
    type: TransactionType.expense,
    amount: 1000,
    accountId: 1,
  );

  setUp(() {
    datasource = MockTransactionLocalDatasource();
    receiptStorage = MockReceiptStorageService();
    repository = TransactionRepositoryImpl(datasource, receiptStorage);
  });

  test(
    'getTransactionsByMonth success maps models to Right(entities)',
    () async {
      when(() => datasource.getByMonth(any())).thenAnswer(
        (_) async => [
          const TransactionModel(
            id: 1,
            type: TransactionType.expense,
            amount: 1000,
            accountId: 1,
          ),
        ],
      );

      final result = await repository.getTransactionsByMonth(DateTime(2026, 7));

      expect(result.isRight(), isTrue);
      expect(result.getRight().toNullable()?.single.amount, 1000);
    },
  );

  test('saveTransaction insert returns Right(new id)', () async {
    when(() => datasource.insert(any())).thenAnswer((_) async => 42);

    final result = await repository.saveTransaction(transaction);

    expect(result.getRight().toNullable(), 42);
  });

  test('generic DatabaseException → Left(CacheFailure)', () async {
    when(() => datasource.insert(any())).thenThrow(genericError);

    final result = await repository.saveTransaction(transaction);

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });

  test('unexpected (non-DB) error → Left(CacheFailure)', () async {
    when(() => datasource.getReceiptPath(1)).thenAnswer((_) async => null);
    when(() => datasource.delete(1)).thenThrow(Exception('boom'));

    final result = await repository.deleteTransaction(1);

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });

  test(
    'deleteTransaction success without a receipt removes only the row',
    () async {
      when(() => datasource.getReceiptPath(1)).thenAnswer((_) async => null);
      when(() => datasource.delete(1)).thenAnswer((_) async => 1);
      when(() => receiptStorage.delete(any())).thenAnswer((_) async {});

      final result = await repository.deleteTransaction(1);

      expect(result.isRight(), isTrue);
      // No receipt on the row → no file delete attempted.
      verifyNever(() => receiptStorage.delete(any()));
    },
  );

  test(
    'deleteTransaction with a receipt deletes the file once and removes the row',
    () async {
      when(
        () => datasource.getReceiptPath(1),
      ).thenAnswer((_) async => 'receipts/x.jpg');
      when(() => datasource.delete(1)).thenAnswer((_) async => 1);
      when(
        () => receiptStorage.delete('receipts/x.jpg'),
      ).thenAnswer((_) async {});

      final result = await repository.deleteTransaction(1);

      expect(result.isRight(), isTrue);
      verify(() => datasource.delete(1)).called(1);
      verify(() => receiptStorage.delete('receipts/x.jpg')).called(1);
    },
  );
}
