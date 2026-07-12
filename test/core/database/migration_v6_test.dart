import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Dedicated v5→v6 upgrade guard: an existing install must gain
/// `categories.system_key` (V2-M6) and the seeded reserved "Penyesuaian" pair
/// (`adjustment_in` income + `adjustment_out` expense) the reconcile write tags.
/// `schema_parity_test` already proves fresh==migrated; this proves the step
/// itself (column absent before, present after; existing rows stay NULL; the
/// pair exists exactly once) and — critically — that the seed is idempotent
/// under replay via the extracted [Migrations.seedSystemCategories] (calling it
/// twice, NEVER re-running `_v6`, whose once-only ALTER would throw).
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  // `singleInstance: false` so each open is a fresh, independent in-memory DB.
  Future<Database> openBlank() => databaseFactory.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(singleInstance: false),
  );

  test(
    'the v5→v6 migration adds system_key, keeps existing rows NULL and seeds the pair once',
    () async {
      final db = await openBlank();
      addTearDown(db.close);
      // The v1 baseline builds `categories` without `system_key`.
      await Migrations.createV1(db);
      await db.insert('categories', {
        'name': 'Makan',
        'type': 'expense',
        'created_at': 0,
      });
      expect(
        (await db.rawQuery(
          'PRAGMA table_info(categories)',
        )).map((c) => c['name']),
        isNot(contains('system_key')),
      );

      // oldVersion 5 skips _v2/_v3/_v4/_v5, runs only _v6 (the step under test).
      await Migrations.migrate(db, 5, 6);

      final cols = (await db.rawQuery(
        'PRAGMA table_info(categories)',
      )).map((c) => c['name']).toSet();
      expect(cols, contains('system_key'));

      // A pre-existing user category keeps a NULL system_key.
      expect(
        (await db.query(
          'categories',
          where: "name = 'Makan'",
        )).single['system_key'],
        isNull,
      );

      // The reserved pair exists exactly once, with the right types.
      final adjIn = await db.query(
        'categories',
        where: "system_key = 'adjustment_in'",
      );
      final adjOut = await db.query(
        'categories',
        where: "system_key = 'adjustment_out'",
      );
      expect(adjIn, hasLength(1));
      expect(adjOut, hasLength(1));
      expect(adjIn.single['type'], 'income');
      expect(adjOut.single['type'], 'expense');
    },
  );

  test(
    'the reserved-pair seed is idempotent under replay (WHERE NOT EXISTS)',
    () async {
      final db = await openBlank();
      addTearDown(db.close);
      await Migrations.createV1(db);
      await Migrations.migrate(db, 5, 6); // _v6 once → pair present

      // Replay the SEED ONLY — never re-run _v6, whose ALTER would throw
      // "duplicate column name". WHERE NOT EXISTS must keep the pair singular.
      await Migrations.seedSystemCategories(db);
      await Migrations.seedSystemCategories(db);

      expect(
        await db.query('categories', where: "system_key = 'adjustment_in'"),
        hasLength(1),
      );
      expect(
        await db.query('categories', where: "system_key = 'adjustment_out'"),
        hasLength(1),
      );
    },
  );
}
