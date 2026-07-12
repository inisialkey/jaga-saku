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
        onCreate: (db, _) async {
          await Migrations.onCreate(db);
          // V2-M6: _v6 seeds the reserved "Penyesuaian" pair. The user-CRUD
          // tests below assume a clean slate; drop the pair here and re-seed it
          // only inside the dedicated getBySystemKey group.
          await db.delete('categories', where: 'system_key IS NOT NULL');
        },
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

  test('a user category round-trips with a null system_key', () async {
    final id = await datasource.insert(model('Food'));
    final rows = await datasource.getCategories(type: CategoryType.expense);

    final food = rows.firstWhere((r) => r.id == id);
    expect(food.systemKey, isNull);
    expect(food.toEntity().isSystem, isFalse);
  });

  // ── System categories (V2-M6) ───────────────────────────────────────────────
  group('getBySystemKey', () {
    // Re-seed the reserved pair the shared setUp dropped, so these tests read a
    // realistic post-_v6 schema.
    setUp(() => Migrations.seedSystemCategories(db));

    test('resolves adjustment_in to the seeded income category', () async {
      final adjIn = await datasource.getBySystemKey('adjustment_in');
      expect(adjIn, isNotNull);
      expect(adjIn!.type, CategoryType.income);
      expect(adjIn.systemKey, 'adjustment_in');
      expect(adjIn.toEntity().isSystem, isTrue);
    });

    test('resolves adjustment_out to the seeded expense category', () async {
      final adjOut = await datasource.getBySystemKey('adjustment_out');
      expect(adjOut, isNotNull);
      expect(adjOut!.type, CategoryType.expense);
      expect(adjOut.systemKey, 'adjustment_out');
    });

    test('returns null for an unknown system key', () async {
      expect(await datasource.getBySystemKey('nope'), isNull);
    });

    test(
      'getCategories still returns the reserved cat (consumers filter)',
      () async {
        // getCategories intentionally KEEPS system cats so Home/Insight can build
        // the exclude set; the presentation sources filter !isSystem, not the DAO.
        final expense = await datasource.getCategories(
          type: CategoryType.expense,
        );
        expect(
          expense.where((c) => c.systemKey == 'adjustment_out'),
          hasLength(1),
        );
      },
    );
  });
}
