import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/templates/data/models/tx_template_model.dart';
import 'package:jaga_saku/features/templates/data/repositories/tx_template_repository_impl.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
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
    await db.insert('tx_templates', {
      'id': 1,
      'label': 'Coffee',
      'type': 'expense',
      'account_id': 1,
      'created_at': 0,
    });
    try {
      await db.insert('tx_templates', {
        'id': 1,
        'label': 'Dup',
        'type': 'expense',
        'account_id': 1,
        'created_at': 0,
      });
    } on DatabaseException catch (e) {
      uniqueError = e;
    }
    try {
      // `label` is NOT NULL — a non-unique constraint violation.
      await db.insert('tx_templates', {
        'type': 'expense',
        'account_id': 1,
        'created_at': 0,
      });
    } on DatabaseException catch (e) {
      genericError = e;
    }
    await db.close();
  });

  late MockTxTemplateLocalDatasource datasource;
  late TxTemplateRepositoryImpl repository;

  const template = TxTemplate(
    label: 'Coffee',
    type: TransactionType.expense,
    accountId: 1,
  );

  setUp(() {
    datasource = MockTxTemplateLocalDatasource();
    repository = TxTemplateRepositoryImpl(datasource);
  });

  test('getFavorites success maps models to Right(entities)', () async {
    when(() => datasource.getFavorites()).thenAnswer(
      (_) async => [
        const TxTemplateModel(
          label: 'Coffee',
          type: TransactionType.expense,
          accountId: 1,
        ),
      ],
    );

    final result = await repository.getFavorites();

    expect(result.isRight(), isTrue);
    expect(result.getRight().toNullable()?.single.label, 'Coffee');
  });

  test('saveTemplate insert returns Right(new id)', () async {
    when(() => datasource.insert(any())).thenAnswer((_) async => 42);

    final result = await repository.saveTemplate(template);

    expect(result.getRight().toNullable(), 42);
    verify(() => datasource.insert(any())).called(1);
    verifyNever(() => datasource.update(any()));
  });

  test('saveTemplate update returns Right(existing id)', () async {
    when(() => datasource.update(any())).thenAnswer((_) async {});

    final result = await repository.saveTemplate(template.copyWith(id: 7));

    expect(result.getRight().toNullable(), 7);
    verify(() => datasource.update(any())).called(1);
    verifyNever(() => datasource.insert(any()));
  });

  test('saveTemplate unique violation → Left(ConflictFailure)', () async {
    when(() => datasource.insert(any())).thenThrow(uniqueError);

    final result = await repository.saveTemplate(template);

    expect(result.getLeft().toNullable(), isA<ConflictFailure>());
  });

  test('generic DatabaseException → Left(CacheFailure)', () async {
    when(() => datasource.insert(any())).thenThrow(genericError);

    final result = await repository.saveTemplate(template);

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });

  test('unexpected (non-DB) error → Left(CacheFailure)', () async {
    when(() => datasource.delete(1)).thenThrow(Exception('boom'));

    final result = await repository.deleteTemplate(1);

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });

  test('deleteTemplate success → Right(unit)', () async {
    when(() => datasource.delete(1)).thenAnswer((_) async => 1);

    final result = await repository.deleteTemplate(1);

    expect(result.isRight(), isTrue);
  });

  test('reorderTemplates success → Right(unit)', () async {
    when(() => datasource.reorder(any())).thenAnswer((_) async {});

    final result = await repository.reorderTemplates([3, 1, 2]);

    expect(result.isRight(), isTrue);
    verify(() => datasource.reorder([3, 1, 2])).called(1);
  });
}
