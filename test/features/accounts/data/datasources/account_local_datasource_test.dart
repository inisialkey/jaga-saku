import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:jaga_saku/features/accounts/data/models/account_model.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../helpers/mocks.dart';

/// Exercises [AccountLocalDatasource] against a real in-memory sqflite (ffi)
/// database (schema via [Migrations.onCreate], no seed), mocking only
/// [AppDatabase] so the DAO resolves a live connection.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late AccountLocalDatasource datasource;

  AccountModel model(
    String name, {
    int openingBalance = 0,
    int sortOrder = 0,
    bool archived = false,
  }) => AccountModel(
    name: name,
    type: AccountType.cash,
    openingBalance: openingBalance,
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
    datasource = AccountLocalDatasource(appDatabase);
  });

  tearDown(() => db.close());

  test(
    'insert then getAccounts returns it with balance == openingBalance',
    () async {
      final id = await datasource.insert(model('Cash', openingBalance: 50000));
      final rows = await datasource.getAccounts();

      expect(rows, hasLength(1));
      expect(rows.first.id, id);
      expect(rows.first.name, 'Cash');
      // Empty transactions table → balance equals the opening balance.
      expect(rows.first.balance, 50000);
    },
  );

  test(
    'balance query sums signed transactions on top of opening balance',
    () async {
      final id = await datasource.insert(model('Cash', openingBalance: 10000));
      await db.insert('transactions', {
        'type': 'income',
        'amount': 2500,
        'account_id': id,
        'date': 0,
        'created_at': 0,
      });
      await db.insert('transactions', {
        'type': 'expense',
        'amount': 1000,
        'account_id': id,
        'date': 0,
        'created_at': 0,
      });

      final rows = await datasource.getAccounts();
      expect(rows.first.balance, 10000 + 2500 - 1000);
    },
  );

  test('update persists changed fields', () async {
    final id = await datasource.insert(model('Cash', openingBalance: 1000));
    await datasource.update(
      model('Updated', openingBalance: 9999).copyWith(id: id),
    );

    final rows = await datasource.getAccounts();
    expect(rows.first.name, 'Updated');
    expect(rows.first.openingBalance, 9999);
  });

  test('delete removes the row and returns the delete count', () async {
    final id = await datasource.insert(model('Cash'));
    final removed = await datasource.delete(id);

    expect(removed, 1);
    expect(await datasource.getAccounts(), isEmpty);
  });

  test('reorder rewrites sort_order to match the given id order', () async {
    final a = await datasource.insert(model('A'));
    final b = await datasource.insert(model('B', sortOrder: 1));
    final c = await datasource.insert(model('C', sortOrder: 2));

    await datasource.reorder([c, a, b]);

    final rows = await datasource.getAccounts();
    expect(rows.map((r) => r.name), ['C', 'A', 'B']);
  });

  test(
    'insert appends: new row gets sort_order = max + 1 and lands last',
    () async {
      // A pre-existing row already at a high sort_order.
      await db.insert('accounts', model('Existing', sortOrder: 5).toMap());

      final id = await datasource.insert(model('New'));
      final rows = await datasource.getAccounts();

      final inserted = rows.firstWhere((r) => r.id == id);
      expect(inserted.sortOrder, 6);
      // ORDER BY sort_order, id → the appended row sorts last, not to the top.
      expect(rows.map((r) => r.name).last, 'New');
    },
  );

  test('getAccounts hides archived rows unless includeArchived', () async {
    await datasource.insert(model('Active'));
    final archivedId = await datasource.insert(model('Archived'));
    await datasource.setArchived(archivedId, archived: true);

    expect((await datasource.getAccounts()).map((r) => r.name), ['Active']);
    expect(
      (await datasource.getAccounts(includeArchived: true)).map((r) => r.name),
      containsAll(<String>['Active', 'Archived']),
    );
  });
}
