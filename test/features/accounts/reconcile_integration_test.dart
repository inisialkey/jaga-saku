import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:jaga_saku/features/accounts/data/models/account_model.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/categories/data/datasources/category_local_datasource.dart';
import 'package:jaga_saku/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:jaga_saku/features/transactions/domain/transaction_aggregator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../helpers/mocks.dart';

/// The single test that pins BOTH halves of the M6 invariant (C3) against a real
/// in-memory sqflite: a reconcile correction MOVES the derived balance to the
/// counted value (the balance SQL is unchanged and includes the adjustment) yet
/// is INVISIBLE to the income/expense reports (the aggregator excludes the
/// reserved category ids). The reserved pair is seeded by `_v6` under
/// [Migrations.onCreate], so [CategoryLocalDatasource.getBySystemKey] resolves
/// it exactly as production would.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late AccountLocalDatasource accountDs;
  late CategoryLocalDatasource categoryDs;
  late TransactionLocalDatasource transactionDs;

  setUp(() async {
    db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: Migrations.latestVersion,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, _) => Migrations.onCreate(db), // _v6 seeds the pair
      ),
    );
    final appDatabase = MockAppDatabase();
    when(() => appDatabase.db).thenReturn(db);
    accountDs = AccountLocalDatasource(appDatabase);
    categoryDs = CategoryLocalDatasource(appDatabase);
    transactionDs = TransactionLocalDatasource(appDatabase);
  });

  tearDown(() => db.close());

  test(
    'reconcile moves the balance to the counted value but leaves reports identical',
    () async {
      // The reserved pair is present via _v6.
      final adjIn = await categoryDs.getBySystemKey('adjustment_in');
      final adjOut = await categoryDs.getBySystemKey('adjustment_out');
      expect(adjIn, isNotNull);
      expect(adjOut, isNotNull);

      // A genuine user category (id auto-assigned after the seeded pair).
      final realCatId = await db.insert('categories', {
        'name': 'Makan',
        'type': 'expense',
        'created_at': 0,
      });

      final accId = await accountDs.insert(
        const AccountModel(
          name: 'Cash',
          type: AccountType.cash,
          openingBalance: 100000,
          createdAt: 1,
        ),
      );

      // One REAL expense of 20.000 → derived balance 80.000.
      await db.insert('transactions', {
        'type': 'expense',
        'amount': 20000,
        'account_id': accId,
        'category_id': realCatId,
        'date': DateTime(2026, 7, 5).millisecondsSinceEpoch,
        'created_at': 0,
      });
      expect((await accountDs.getAccounts()).single.balance, 80000);

      // Reconcile: counted 50.000 → delta −30.000 → an expense adjustment_out
      // of 30.000 (exactly what ReconcileCubit.confirm would write).
      await db.insert('transactions', {
        'type': 'expense',
        'amount': 30000,
        'account_id': accId,
        'category_id': adjOut!.id,
        'date': DateTime(2026, 7, 6).millisecondsSinceEpoch,
        'created_at': 0,
      });

      // (a) BALANCE moved to the counted value — the unchanged SQL includes the
      // adjustment (80.000 − 30.000 = 50.000).
      expect((await accountDs.getAccounts()).single.balance, 50000);

      // (b) REPORTS exclude it — identical to the no-adjustment case.
      final month = (await transactionDs.getByMonth(
        DateTime(2026, 7),
      )).map((m) => m.toEntity()).toList();
      final exclude = <int>{adjIn!.id!, adjOut.id!};

      final report = TransactionAggregator.incomeExpense(
        month,
        excludeCategoryIds: exclude,
      );
      expect(report.expense, 20000); // NOT 50.000 — the adjustment is invisible
      expect(report.income, 0);
      expect(
        TransactionAggregator.expenseByCategory(
          month,
          excludeCategoryIds: exclude,
        ),
        {realCatId: 20000}, // no reserved slice
      );
    },
  );
}
