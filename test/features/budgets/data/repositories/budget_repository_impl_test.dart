import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/budgets/data/models/budget_model.dart';
import 'package:jaga_saku/features/budgets/data/repositories/budget_repository_impl.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../helpers/mocks.dart';

/// Repository maps datasource outcomes to `Either<Failure, T>` and never throws.
/// Real sqflite [DatabaseException]s are captured once (a UNIQUE(category,
/// period) clash for the conflict path, a NOT NULL clash for the generic one) so
/// the mapping is tested against genuine exceptions rather than fakes.
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
    await db.insert('budgets', {
      'category_id': 1,
      'period': '2026-01',
      'limit_amount': 1000,
      'created_at': 0,
    });
    try {
      // Same (category_id, period) → UNIQUE(category_id, period) violation.
      await db.insert('budgets', {
        'category_id': 1,
        'period': '2026-01',
        'limit_amount': 2000,
        'created_at': 0,
      });
    } on DatabaseException catch (e) {
      uniqueError = e;
    }
    try {
      // `limit_amount` is NOT NULL — a non-unique constraint violation.
      await db.insert('budgets', {
        'category_id': 1,
        'period': '2026-02',
        'created_at': 0,
      });
    } on DatabaseException catch (e) {
      genericError = e;
    }
    await db.close();
  });

  late MockBudgetLocalDatasource datasource;
  late BudgetRepositoryImpl repository;

  const budget = Budget(categoryId: 1, period: '2026-01', limitAmount: 1000);

  setUp(() {
    datasource = MockBudgetLocalDatasource();
    repository = BudgetRepositoryImpl(datasource);
  });

  test('getBudgetsForPeriod success maps models to Right(entities)', () async {
    when(() => datasource.getBudgetsForPeriod('2026-01')).thenAnswer(
      (_) async => [
        const BudgetModel(
          categoryId: 1,
          period: '2026-01',
          limitAmount: 1000,
          spent: 250,
        ),
      ],
    );

    final result = await repository.getBudgetsForPeriod('2026-01');

    expect(result.isRight(), isTrue);
    final b = result.getRight().toNullable()!.single;
    expect(b.limitAmount, 1000);
    expect(b.spent, 250);
  });

  test('saveBudget insert returns Right(new id)', () async {
    when(() => datasource.insert(any())).thenAnswer((_) async => 7);

    final result = await repository.saveBudget(budget);

    expect(result.getRight().toNullable(), 7);
  });

  test('saveBudget update returns Right(existing id)', () async {
    when(() => datasource.update(any())).thenAnswer((_) async {});

    final result = await repository.saveBudget(budget.copyWith(id: 3));

    expect(result.getRight().toNullable(), 3);
    verify(() => datasource.update(any())).called(1);
  });

  test('UNIQUE(category, period) violation → Left(ConflictFailure)', () async {
    when(() => datasource.insert(any())).thenThrow(uniqueError);

    final result = await repository.saveBudget(budget);

    expect(result.getLeft().toNullable(), isA<ConflictFailure>());
  });

  test('generic DatabaseException → Left(CacheFailure)', () async {
    when(() => datasource.insert(any())).thenThrow(genericError);

    final result = await repository.saveBudget(budget);

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });

  test('unexpected (non-DB) error → Left(CacheFailure)', () async {
    when(() => datasource.delete(1)).thenThrow(Exception('boom'));

    final result = await repository.deleteBudget(1);

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });

  test('deleteBudget success → Right(unit)', () async {
    when(() => datasource.delete(1)).thenAnswer((_) async => 1);

    final result = await repository.deleteBudget(1);

    expect(result.isRight(), isTrue);
  });
}
