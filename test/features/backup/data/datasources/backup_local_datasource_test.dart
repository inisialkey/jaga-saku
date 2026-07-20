import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/backup/data/datasources/backup_local_datasource.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../helpers/mocks.dart';

/// Exercises [BackupLocalDatasource] against a real in-memory sqflite (ffi)
/// database with `foreign_keys = ON` (mirroring `app_database.dart`), so the
/// atomic restore's deferred-FK handling and rollback are tested for real.
/// Schema via [Migrations.onCreate] — which seeds the two system categories
/// (`_v6`) but not the default accounts (`Seed.run` is not called).
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late BackupLocalDatasource datasource;

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
    datasource = BackupLocalDatasource(appDatabase);
  });

  tearDown(() => db.close());

  Future<int> count(String table) async =>
      (await db.rawQuery('SELECT COUNT(*) AS c FROM $table')).first['c']!
          as int;

  // Sorted so assertions test id preservation, not physical b-tree row order.
  Future<List<int>> ids(String table) async => (await db.query(
    table,
    columns: ['id'],
  )).map((r) => r['id']! as int).toList()..sort();

  // A referentially-sound backup carrying its own system category (as a real
  // export would): 1 account, 2 categories (incl. adjustment_in), 1 tx, 1 budget,
  // 1 template, 1 recurring rule, 1 settings row — all with explicit ids.
  BackupData backupB() => const BackupData(
    settings: [
      <String, Object?>{'key': 'theme', 'value': 'dark'},
    ],
    accounts: [
      <String, Object?>{
        'id': 1,
        'name': 'Bank',
        'type': 'bank',
        'created_at': 0,
      },
    ],
    categories: [
      <String, Object?>{
        'id': 1,
        'name': 'Penyesuaian',
        'type': 'income',
        'system_key': 'adjustment_in',
        'created_at': 0,
      },
      <String, Object?>{
        'id': 2,
        'name': 'Food',
        'type': 'expense',
        'created_at': 0,
      },
    ],
    transactions: [
      <String, Object?>{
        'id': 1,
        'type': 'expense',
        'amount': 5000,
        'account_id': 1,
        'category_id': 2,
        'date': 0,
        'created_at': 0,
      },
    ],
    budgets: [
      <String, Object?>{
        'id': 1,
        'category_id': 2,
        'period': '2026-01',
        'limit_amount': 100000,
        'created_at': 0,
      },
    ],
    txTemplates: [
      <String, Object?>{
        'id': 1,
        'label': 'Kopi',
        'type': 'expense',
        'account_id': 1,
        'category_id': 2,
        'is_favorite': 1,
        'created_at': 0,
      },
    ],
    recurring: [
      <String, Object?>{
        'id': 1,
        'template_id': 1,
        'freq': 'monthly',
        'start_date': 0,
        'next_due': 0,
        'created_at': 0,
      },
    ],
  );

  test(
    'readAllTables returns all seven tables incl. seeded system categories',
    () async {
      final tables = await datasource.readAllTables();

      expect(tables.keys.toSet(), BackupLocalDatasource.tables.toSet());
      // _v6 seeds exactly the adjustment_in / adjustment_out pair.
      expect(tables['categories'], hasLength(2));
      expect(
        tables['categories']!.map((r) => r['system_key']),
        containsAll(<String>['adjustment_in', 'adjustment_out']),
      );
      expect(tables['accounts'], isEmpty);
    },
  );

  test(
    'restore full-replaces every table, preserving explicit ids + integrity',
    () async {
      await datasource.restore(backupB());

      expect(await ids('accounts'), [1]);
      expect(await ids('categories'), [1, 2]);
      expect(await ids('transactions'), [1]);
      expect(await ids('budgets'), [1]);
      expect(await ids('tx_templates'), [1]);
      expect(await ids('recurring'), [1]);
      // The envelope's one row + the re-applied onboarding marker (see below).
      expect(await count('settings'), 2);
      // Referential integrity intact after the replace.
      expect(await db.rawQuery('PRAGMA foreign_key_check'), isEmpty);
    },
  );

  // W1 regression: `settings` is wiped by the restore and NO pre-V5 backup
  // carries `onboarding_completed`, so without the re-apply a restore
  // un-onboards a user who demonstrably has data — and `migrate` can't rescue
  // it, since `user_version` is already at latest.
  test(
    'a pre-V5 backup restore keeps the onboarding completion marker',
    () async {
      // backupB()'s settings hold only `theme` — exactly a pre-V5 envelope.
      await datasource.restore(backupB());

      final marker = await db.query(
        'settings',
        where: 'key = ?',
        whereArgs: ['onboarding_completed'],
      );
      expect(marker.single['value'], '1');
      // The envelope's own settings row still restored alongside it.
      expect(
        (await db.query(
          'settings',
          where: 'key = ?',
          whereArgs: ['theme'],
        )).single['value'],
        'dark',
      );
    },
  );

  test(
    'system categories are restored exactly once (no duplication)',
    () async {
      await datasource.restore(backupB());

      final adjustmentIn =
          (await db.rawQuery(
                'SELECT COUNT(*) AS c FROM categories '
                "WHERE system_key = 'adjustment_in'",
              )).first['c']!
              as int;
      expect(adjustmentIn, 1);
    },
  );

  test(
    'AUTOINCREMENT continues from the max restored id after a restore',
    () async {
      await datasource.restore(backupB());

      // Backup's max account id is 1 → the next insert must be 2, not the
      // pre-restore high-water mark.
      final newId = await db.insert('accounts', {
        'name': 'Fresh',
        'type': 'cash',
        'created_at': 0,
      });
      expect(newId, 2);
    },
  );

  test(
    'a broken foreign key throws and rolls the whole restore back',
    () async {
      // Establish state A and snapshot it.
      await datasource.restore(backupB());
      final before = await datasource.readAllTables();

      // A backup that passes shape but dangles a FK (bypasses the validator).
      const broken = BackupData(
        accounts: [
          <String, Object?>{
            'id': 1,
            'name': 'A',
            'type': 'cash',
            'created_at': 0,
          },
        ],
        transactions: [
          <String, Object?>{
            'id': 1,
            'type': 'expense',
            'amount': 1,
            'account_id': 999, // no such account
            'date': 0,
            'created_at': 0,
          },
        ],
      );

      await expectLater(() => datasource.restore(broken), throwsStateError);

      // DB is byte-for-byte unchanged — the transaction rolled back.
      expect(await datasource.readAllTables(), before);
    },
  );

  test(
    'backup table list matches the DB user tables (coverage guard)',
    () async {
      final userTables = (await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table' "
        "AND name NOT LIKE 'sqlite_%' AND name != 'android_metadata'",
      )).map((r) => r['name']! as String).toSet();

      expect(userTables, BackupLocalDatasource.tables.toSet());
    },
  );
}
