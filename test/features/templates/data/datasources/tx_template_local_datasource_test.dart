import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/templates/data/datasources/tx_template_local_datasource.dart';
import 'package:jaga_saku/features/templates/data/models/tx_template_model.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../helpers/mocks.dart';

/// Exercises [TxTemplateLocalDatasource] against a real in-memory sqflite (ffi)
/// database (schema via [Migrations.onCreate], `foreign_keys = ON`), mocking
/// only [AppDatabase]. Parent `accounts`/`categories` rows are seeded first so
/// the FK columns (`account_id`, `category_id`) resolve.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late TxTemplateLocalDatasource datasource;

  TxTemplateModel model(
    String label, {
    int accountId = 1,
    int? categoryId = 1,
    int? amount = 15000,
    bool isFavorite = true,
    int sortOrder = 0,
  }) => TxTemplateModel(
    label: label,
    type: TransactionType.expense,
    accountId: accountId,
    categoryId: categoryId,
    amount: amount,
    isFavorite: isFavorite,
    sortOrder: sortOrder,
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
    // FK parents: two accounts + one category.
    await db.insert('accounts', {
      'id': 1,
      'name': 'Cash',
      'type': 'cash',
      'created_at': 0,
    });
    await db.insert('accounts', {
      'id': 2,
      'name': 'BCA',
      'type': 'bank',
      'created_at': 0,
    });
    await db.insert('categories', {
      'id': 1,
      'name': 'Makan',
      'type': 'expense',
      'created_at': 0,
    });
    final appDatabase = MockAppDatabase();
    when(() => appDatabase.db).thenReturn(db);
    datasource = TxTemplateLocalDatasource(appDatabase);
  });

  tearDown(() => db.close());

  test('insert then getFavorites returns it', () async {
    final id = await datasource.insert(model('Coffee'));
    final rows = await datasource.getFavorites();

    expect(rows, hasLength(1));
    expect(rows.first.id, id);
    expect(rows.first.label, 'Coffee');
    expect(rows.first.amount, 15000);
    expect(rows.first.isFavorite, isTrue);
  });

  test('an amount-less favorite round-trips a null amount', () async {
    await datasource.insert(model('Ask each time', amount: null));
    final rows = await datasource.getFavorites();

    expect(rows.first.amount, isNull);
  });

  test('update persists changed fields', () async {
    final id = await datasource.insert(model('Coffee'));
    await datasource.update(model('Latte', amount: 30000).copyWith(id: id));

    final rows = await datasource.getFavorites();
    expect(rows.first.label, 'Latte');
    expect(rows.first.amount, 30000);
  });

  test('delete removes the row and returns the delete count', () async {
    final id = await datasource.insert(model('Coffee'));
    final removed = await datasource.delete(id);

    expect(removed, 1);
    expect(await datasource.getFavorites(), isEmpty);
  });

  test('reorder rewrites sort_order to match the given id order', () async {
    final a = await datasource.insert(model('A'));
    final b = await datasource.insert(model('B'));
    final c = await datasource.insert(model('C'));

    await datasource.reorder([c, a, b]);

    final rows = await datasource.getFavorites();
    expect(rows.map((r) => r.label), ['C', 'A', 'B']);
  });

  test(
    'insert appends: new row gets sort_order = max + 1 and lands last',
    () async {
      await db.insert('tx_templates', model('Existing', sortOrder: 5).toMap());

      final id = await datasource.insert(model('New'));
      final rows = await datasource.getFavorites();

      final inserted = rows.firstWhere((r) => r.id == id);
      expect(inserted.sortOrder, 6);
      expect(rows.map((r) => r.label).last, 'New');
    },
  );

  test('getFavorites excludes schedule-only rows (is_favorite = 0)', () async {
    await datasource.insert(model('Fav'));
    await db.insert(
      'tx_templates',
      model('Schedule', isFavorite: false).toMap(),
    );

    final labels = (await datasource.getFavorites()).map((r) => r.label);
    expect(labels, ['Fav']);
  });
}
