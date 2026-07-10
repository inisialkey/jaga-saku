import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:jaga_saku/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:jaga_saku/features/transactions/data/models/transaction_model.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';
// sqflite_ffi re-exports sqflite's `Transaction`; hide it so it does not clash
// with the domain entity of the same name.
import 'package:sqflite_common_ffi/sqflite_ffi.dart' hide Transaction;

import '../../../../helpers/mocks.dart';

/// Exercises [TransactionLocalDatasource] against a real in-memory sqflite (ffi)
/// database (schema via [Migrations.onCreate]). Two seed accounts (ids 1 & 2)
/// satisfy the `account_id` FK; the balance-integration tests then prove a saved
/// transaction moves the balance the [AccountLocalDatasource] balance query
/// reports.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late TransactionLocalDatasource datasource;
  late AccountLocalDatasource accounts;

  int millis(
    int y,
    int m,
    int d, [
    int h = 0,
    int min = 0,
    int s = 0,
    int ms = 0,
  ]) => DateTime(y, m, d, h, min, s, ms).millisecondsSinceEpoch;

  TransactionModel model({
    TransactionType type = TransactionType.expense,
    int amount = 1000,
    int accountId = 1,
    int? toAccountId,
    int? categoryId,
    PlannedStatus? plannedStatus,
    SpendingType? spendingType,
    int date = 0,
    String? note,
  }) => TransactionModel(
    type: type,
    amount: amount,
    accountId: accountId,
    toAccountId: toAccountId,
    categoryId: categoryId,
    plannedStatus: plannedStatus,
    spendingType: spendingType,
    date: date,
    note: note,
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
    await db.insert('accounts', {
      'id': 1,
      'name': 'Cash',
      'type': 'cash',
      'opening_balance': 100000,
      'created_at': 0,
    });
    await db.insert('accounts', {
      'id': 2,
      'name': 'BCA',
      'type': 'bank',
      'opening_balance': 50000,
      'created_at': 0,
    });
    // Categories referenced by category_id (FK is enforced above).
    await db.insert('categories', {
      'id': 1,
      'name': 'Makan',
      'type': 'expense',
      'created_at': 0,
    });
    await db.insert('categories', {
      'id': 7,
      'name': 'Gaji',
      'type': 'income',
      'created_at': 0,
    });
    final appDatabase = MockAppDatabase();
    when(() => appDatabase.db).thenReturn(db);
    datasource = TransactionLocalDatasource(appDatabase);
    accounts = AccountLocalDatasource(appDatabase);
  });

  tearDown(() => db.close());

  test('insert expense then getByDay round-trips all fields', () async {
    final id = await datasource.insert(
      model(
        amount: 35000,
        categoryId: 1,
        plannedStatus: PlannedStatus.planned,
        spendingType: SpendingType.need,
        date: millis(2026, 7, 8),
        note: 'Lunch',
      ),
    );

    final rows = await datasource.getByDay(DateTime(2026, 7, 8));
    expect(rows, hasLength(1));
    final row = rows.single;
    expect(row.id, id);
    expect(row.type, TransactionType.expense);
    expect(row.amount, 35000);
    expect(row.categoryId, 1);
    expect(row.plannedStatus, PlannedStatus.planned);
    expect(row.spendingType, SpendingType.need);
    expect(row.note, 'Lunch');
  });

  test('insert income leaves planned/spending null', () async {
    await datasource.insert(
      model(
        type: TransactionType.income,
        amount: 5000000,
        categoryId: 7,
        date: millis(2026, 7, 8),
      ),
    );

    final row = (await datasource.getByDay(DateTime(2026, 7, 8))).single;
    expect(row.type, TransactionType.income);
    expect(row.plannedStatus, isNull);
    expect(row.spendingType, isNull);
  });

  test('insert transfer stores toAccountId and null category', () async {
    await datasource.insert(
      model(
        type: TransactionType.transfer,
        amount: 20000,
        toAccountId: 2,
        date: millis(2026, 7, 8),
      ),
    );

    final row = (await datasource.getByDay(DateTime(2026, 7, 8))).single;
    expect(row.type, TransactionType.transfer);
    expect(row.toAccountId, 2);
    expect(row.categoryId, isNull);
  });

  test(
    'getByMonth includes the last ms of the month, excludes the next',
    () async {
      await datasource.insert(
        model(date: millis(2026, 7, 31, 23, 59, 59, 999)),
      );
      await datasource.insert(model(date: millis(2026, 8, 1)));

      final july = await datasource.getByMonth(DateTime(2026, 7));
      final august = await datasource.getByMonth(DateTime(2026, 8));

      expect(july, hasLength(1));
      expect(july.single.date, millis(2026, 7, 31, 23, 59, 59, 999));
      expect(august, hasLength(1));
      expect(august.single.date, millis(2026, 8, 1));
    },
  );

  test('getByDay includes the last ms of the day, excludes the next', () async {
    await datasource.insert(model(date: millis(2026, 7, 8)));
    await datasource.insert(model(date: millis(2026, 7, 8, 23, 59, 59, 999)));
    await datasource.insert(model(date: millis(2026, 7, 9)));

    final day = await datasource.getByDay(DateTime(2026, 7, 8));
    expect(day, hasLength(2));
    expect(day.every((t) => t.date < millis(2026, 7, 9)), isTrue);
  });

  test('getRecent returns newest first, capped at the limit', () async {
    await datasource.insert(model(amount: 1, date: millis(2026, 7, 1)));
    await datasource.insert(model(amount: 2, date: millis(2026, 7, 2)));
    await datasource.insert(model(amount: 3, date: millis(2026, 7, 3)));

    final recent = await datasource.getRecent(2);
    expect(recent.map((t) => t.amount), [3, 2]);
  });

  test('delete removes the row and returns the delete count', () async {
    final id = await datasource.insert(model(date: millis(2026, 7, 8)));
    final removed = await datasource.delete(id);

    expect(removed, 1);
    expect(await datasource.getByDay(DateTime(2026, 7, 8)), isEmpty);
  });

  test('a saved expense reduces the source account balance', () async {
    await datasource.insert(model(amount: 30000, date: millis(2026, 7, 8)));

    final rows = await accounts.getAccounts();
    final cash = rows.firstWhere((a) => a.id == 1);
    expect(cash.balance, 100000 - 30000);
  });

  test('a saved income increases the source account balance', () async {
    await datasource.insert(
      model(
        type: TransactionType.income,
        amount: 75000,
        categoryId: 7,
        date: millis(2026, 7, 8),
      ),
    );

    final rows = await accounts.getAccounts();
    final cash = rows.firstWhere((a) => a.id == 1);
    expect(cash.balance, 100000 + 75000);
  });

  test('a transfer moves funds from the source to the destination', () async {
    await datasource.insert(
      model(
        type: TransactionType.transfer,
        amount: 20000,
        toAccountId: 2,
        date: millis(2026, 7, 8),
      ),
    );

    final rows = await accounts.getAccounts();
    final cash = rows.firstWhere((a) => a.id == 1);
    final bca = rows.firstWhere((a) => a.id == 2);
    expect(cash.balance, 100000 - 20000);
    expect(bca.balance, 50000 + 20000);
  });
}
