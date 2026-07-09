import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/categories/data/models/category_model.dart';
import 'package:jaga_saku/features/categories/data/repositories/category_repository_impl.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../helpers/mocks.dart';

/// Repository maps datasource outcomes to `Either<Failure, T>` and never throws.
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
    await db.insert('categories', {
      'id': 1,
      'name': 'A',
      'type': 'expense',
      'created_at': 0,
    });
    try {
      await db.insert('categories', {
        'id': 1,
        'name': 'B',
        'type': 'expense',
        'created_at': 0,
      });
    } on DatabaseException catch (e) {
      uniqueError = e;
    }
    try {
      await db.insert('categories', {'type': 'expense', 'created_at': 0});
    } on DatabaseException catch (e) {
      genericError = e;
    }
    await db.close();
  });

  late MockCategoryLocalDatasource datasource;
  late CategoryRepositoryImpl repository;

  const category = Category(name: 'Food', type: CategoryType.expense);

  setUp(() {
    datasource = MockCategoryLocalDatasource();
    repository = CategoryRepositoryImpl(datasource);
  });

  test('getCategories success maps models to Right(entities)', () async {
    when(
      () => datasource.getCategories(
        type: CategoryType.expense,
        includeArchived: true,
      ),
    ).thenAnswer(
      (_) async => [
        const CategoryModel(name: 'Food', type: CategoryType.expense),
      ],
    );

    final result = await repository.getCategories(
      type: CategoryType.expense,
      includeArchived: true,
    );

    expect(result.getRight().toNullable()?.single.name, 'Food');
  });

  test('saveCategory insert returns Right(new id)', () async {
    when(() => datasource.insert(any())).thenAnswer((_) async => 7);

    final result = await repository.saveCategory(category);

    expect(result.getRight().toNullable(), 7);
  });

  test('saveCategory unique violation → Left(ConflictFailure)', () async {
    when(() => datasource.insert(any())).thenThrow(uniqueError);

    final result = await repository.saveCategory(category);

    expect(result.getLeft().toNullable(), isA<ConflictFailure>());
  });

  test('generic DatabaseException → Left(CacheFailure)', () async {
    when(() => datasource.insert(any())).thenThrow(genericError);

    final result = await repository.saveCategory(category);

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });

  test('deleteCategory success → Right(unit)', () async {
    when(() => datasource.delete(1)).thenAnswer((_) async => 1);

    final result = await repository.deleteCategory(1);

    expect(result.isRight(), isTrue);
  });
}
