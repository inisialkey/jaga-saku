import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/accounts/data/models/account_model.dart';
import 'package:jaga_saku/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../helpers/mocks.dart';

/// Repository maps datasource outcomes to `Either<Failure, T>` and never throws.
/// Real sqflite [DatabaseException]s are captured once (a primary-key clash for
/// a unique violation, a NOT NULL clash for a generic one) so the mapping is
/// tested against genuine exceptions rather than fakes.
void main() {
  late DatabaseException uniqueError;
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
    await db.insert('accounts', {
      'id': 1,
      'name': 'A',
      'type': 'cash',
      'created_at': 0,
    });
    try {
      await db.insert('accounts', {
        'id': 1,
        'name': 'B',
        'type': 'cash',
        'created_at': 0,
      });
    } on DatabaseException catch (e) {
      uniqueError = e;
    }
    try {
      // `name` is NOT NULL — a non-unique constraint violation.
      await db.insert('accounts', {'type': 'cash', 'created_at': 0});
    } on DatabaseException catch (e) {
      genericError = e;
    }
    await db.close();
  });

  late MockAccountLocalDatasource datasource;
  late MockTxChangeNotifier notifier;
  late AccountRepositoryImpl repository;

  const account = Account(name: 'Cash', type: AccountType.cash);

  setUp(() {
    datasource = MockAccountLocalDatasource();
    notifier = MockTxChangeNotifier();
    repository = AccountRepositoryImpl(datasource, notifier);
  });

  test('getAccounts success maps models to Right(entities)', () async {
    when(() => datasource.getAccounts(includeArchived: true)).thenAnswer(
      (_) async => [const AccountModel(name: 'Cash', type: AccountType.cash)],
    );

    final result = await repository.getAccounts(includeArchived: true);

    expect(result.isRight(), isTrue);
    expect(result.getRight().toNullable()?.single.name, 'Cash');
    // A read routes through `_guard`, never `_guardWrite` — so it never pings.
    verifyNever(() => notifier.ping());
  });

  test('saveAccount insert returns Right(new id)', () async {
    when(() => datasource.insert(any())).thenAnswer((_) async => 42);

    final result = await repository.saveAccount(account);

    expect(result.getRight().toNullable(), 42);
    // A successful write broadcasts via `_guardWrite` (V4-M1).
    verify(() => notifier.ping()).called(1);
  });

  test('saveAccount unique violation → Left(ConflictFailure)', () async {
    when(() => datasource.insert(any())).thenThrow(uniqueError);

    final result = await repository.saveAccount(account);

    expect(result.getLeft().toNullable(), isA<ConflictFailure>());
    // A Left write never pings — `_guardWrite` gates on `isRight()`.
    verifyNever(() => notifier.ping());
  });

  test('generic DatabaseException → Left(CacheFailure)', () async {
    when(() => datasource.insert(any())).thenThrow(genericError);

    final result = await repository.saveAccount(account);

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });

  test('unexpected (non-DB) error → Left(CacheFailure)', () async {
    when(() => datasource.delete(1)).thenThrow(Exception('boom'));

    final result = await repository.deleteAccount(1);

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });

  test('deleteAccount success → Right(unit)', () async {
    when(() => datasource.delete(1)).thenAnswer((_) async => 1);

    final result = await repository.deleteAccount(1);

    expect(result.isRight(), isTrue);
    verify(() => notifier.ping()).called(1);
  });

  test('archiveAccount success → Right(unit) and pings', () async {
    when(
      () => datasource.setArchived(1, archived: true),
    ).thenAnswer((_) async {});

    final result = await repository.archiveAccount(1, archived: true);

    expect(result.isRight(), isTrue);
    verify(() => notifier.ping()).called(1);
  });

  test('reorderAccounts success → Right(unit) and pings', () async {
    when(() => datasource.reorder(any())).thenAnswer((_) async {});

    final result = await repository.reorderAccounts([3, 1, 2]);

    expect(result.isRight(), isTrue);
    verify(() => datasource.reorder([3, 1, 2])).called(1);
    verify(() => notifier.ping()).called(1);
  });
}
