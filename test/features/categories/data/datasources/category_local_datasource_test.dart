import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/categories/data/datasources/category_local_datasource.dart';
import 'package:jaga_saku/features/categories/data/models/category_model.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../helpers/mocks.dart';

/// Exercises [CategoryLocalDatasource] against a real in-memory sqflite (ffi)
/// database, with `PRAGMA foreign_keys = ON` so the self-ref cascade delete is
/// genuinely tested.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late CategoryLocalDatasource datasource;

  CategoryModel model(
    String name, {
    CategoryType type = CategoryType.expense,
    int? parentId,
    int sortOrder = 0,
    bool archived = false,
  }) => CategoryModel(
    name: name,
    type: type,
    parentId: parentId,
    sortOrder: sortOrder,
    archived: archived,
    createdAt: 1,
  );

  setUp(() async {
    db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: Migrations.latestVersion,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, _) => Migrations.onCreate(db),
      ),
    );
    final appDatabase = MockAppDatabase();
    when(() => appDatabase.db).thenReturn(db);
    datasource = CategoryLocalDatasource(appDatabase);
  });

  tearDown(() => db.close());

  test('insert then getCategories returns it for the matching type', () async {
    final id = await datasource.insert(model('Food'));
    final rows = await datasource.getCategories(type: CategoryType.expense);

    expect(rows, hasLength(1));
    expect(rows.first.id, id);
    expect(rows.first.name, 'Food');
  });

  test('getCategories filters by type', () async {
    await datasource.insert(model('Food'));
    await datasource.insert(model('Salary', type: CategoryType.income));

    expect(
      (await datasource.getCategories(
        type: CategoryType.expense,
      )).map((r) => r.name),
      ['Food'],
    );
    expect(
      (await datasource.getCategories(
        type: CategoryType.income,
      )).map((r) => r.name),
      ['Salary'],
    );
  });

  test('deleting a parent cascades to its children', () async {
    final parentId = await datasource.insert(model('Food'));
    await datasource.insert(model('Lunch', parentId: parentId));
    await datasource.insert(model('Dinner', parentId: parentId));

    await datasource.delete(parentId);

    final rows = await datasource.getCategories(
      type: CategoryType.expense,
      includeArchived: true,
    );
    expect(rows, isEmpty);
  });

  test('update persists changed fields', () async {
    final id = await datasource.insert(model('Food'));
    await datasource.update(model('Groceries').copyWith(id: id));

    final rows = await datasource.getCategories(type: CategoryType.expense);
    expect(rows.first.name, 'Groceries');
  });

  test('reorder rewrites sort_order to match the given id order', () async {
    final a = await datasource.insert(model('A'));
    final b = await datasource.insert(model('B', sortOrder: 1));
    final c = await datasource.insert(model('C', sortOrder: 2));

    await datasource.reorder([c, a, b]);

    final rows = await datasource.getCategories(type: CategoryType.expense);
    expect(rows.map((r) => r.name), ['C', 'A', 'B']);
  });

  test('insert appends within type: sort_order = max(type) + 1', () async {
    // A high sort_order in the *other* type must not affect expense numbering.
    await db.insert(
      'categories',
      model('Salary', type: CategoryType.income, sortOrder: 9).toMap(),
    );
    await db.insert('categories', model('Food', sortOrder: 3).toMap());

    final id = await datasource.insert(model('Transport'));
    final rows = await datasource.getCategories(type: CategoryType.expense);

    final inserted = rows.firstWhere((r) => r.id == id);
    // max expense sort_order (3) + 1 — income's 9 is ignored.
    expect(inserted.sortOrder, 4);
    expect(rows.map((r) => r.name).last, 'Transport');
  });

  test('getCategories hides archived rows unless includeArchived', () async {
    await datasource.insert(model('Active'));
    final archivedId = await datasource.insert(model('Archived'));
    await datasource.setArchived(archivedId, archived: true);

    expect(
      (await datasource.getCategories(
        type: CategoryType.expense,
      )).map((r) => r.name),
      ['Active'],
    );
    expect(
      (await datasource.getCategories(
        type: CategoryType.expense,
        includeArchived: true,
      )).map((r) => r.name),
      containsAll(<String>['Active', 'Archived']),
    );
  });
}
