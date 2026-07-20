import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';

/// sqflite DAO for whole-database backup / restore. Reads every table for
/// export and performs the atomic full-replace restore. Reads/writes through the
/// shared [AppDatabase] connection (resolved per call via `.db`); never opens
/// its own.
class BackupLocalDatasource {
  BackupLocalDatasource(this._database);

  final AppDatabase _database;

  /// The seven backed-up tables, in parent→child insert order. `sqlite_sequence`
  /// and `android_metadata` are engine bookkeeping — never backed up/restored.
  /// A `foreign_key_check`-style guard in the datasource test asserts this list
  /// still equals the DB's user tables (catches a new migration table).
  static const List<String> tables = [
    'settings',
    'accounts',
    'categories',
    'transactions',
    'budgets',
    'tx_templates',
    'recurring',
  ];

  /// The six AUTOINCREMENT tables whose `sqlite_sequence` cursor is reset after a
  /// restore (`settings` has a TEXT primary key — no sequence).
  static const List<String> _autoincTables = [
    'accounts',
    'categories',
    'transactions',
    'budgets',
    'tx_templates',
    'recurring',
  ];

  /// Raw rows of every table keyed by table name — the export source. Row maps
  /// preserve the DB column shape verbatim (ids, int money, int-1/0 bools).
  Future<Map<String, List<Map<String, Object?>>>> readAllTables() async {
    final result = <String, List<Map<String, Object?>>>{};
    for (final table in tables) {
      result[table] = await _database.db.query(table);
    }
    return result;
  }

  /// Atomic full-replace: clear every table, then re-insert [data]'s rows with
  /// their explicit primary keys (parents before children). All-or-nothing — any
  /// thrown error (insert constraint, integrity check) rolls the whole
  /// transaction back, leaving the database byte-for-byte unchanged.
  ///
  /// `PRAGMA foreign_keys` is a NO-OP inside a transaction, so FK enforcement is
  /// deferred to commit-time with `PRAGMA defer_foreign_keys = ON` (auto-resets
  /// at transaction end). That lets us clear + bulk-insert without hand-ordering
  /// the self-referential `categories.parent_id` or the child FKs.
  ///
  /// One row survives the envelope rather than coming from it: the onboarding
  /// completion marker — see step 3.
  Future<void> restore(BackupData data) => _database.db.transaction((
    txn,
  ) async {
    await txn.execute('PRAGMA defer_foreign_keys = ON');

    // 1. Clear every table (order irrelevant under deferred FK).
    for (final table in tables) {
      await txn.delete(table);
    }

    // 2. Bulk-insert with explicit ids, parents before children.
    final rowsByTable = <String, List<Map<String, Object?>>>{
      'settings': data.settings,
      'accounts': data.accounts,
      'categories': data.categories,
      'transactions': data.transactions,
      'budgets': data.budgets,
      'tx_templates': data.txTemplates,
      'recurring': data.recurring,
    };
    final batch = txn.batch();
    for (final table in tables) {
      for (final row in rowsByTable[table]!) {
        batch.insert(table, row);
      }
    }
    await batch.commit(noResult: true);

    // 3. Re-apply the onboarding completion marker (V5-M1). Step 1 deleted
    // `settings`, and EVERY backup taken before V5 carries no
    // `onboarding_completed` row — so a restore would silently drop a
    // fully-populated database back into onboarding on the NEXT cold start
    // (the in-memory `OnboardingService` still reads completed, so nothing
    // looks wrong until the app is killed). `Migrations.migrate` cannot rescue
    // it: `user_version` is already at latest, so `onUpgrade` never re-runs.
    //
    // Unconditional and independent of the envelope, because a restore is
    // unreachable until onboarding is complete: `onboardingRedirect` sends
    // EVERY location outside `_onboardingPassThrough` to `/onboarding`, and
    // `/backup-restore` is not in that set. That covers the external entry
    // point too — the `jagasaku://` scheme is registered on both platforms
    // (`AndroidManifest.xml`, `Info.plist`), and go_router applies the
    // top-level redirect to the initial deep-link location. Pinned by
    // `test/features/onboarding/onboarding_router_redirect_test.dart`.
    // Inside the transaction so it rolls back with everything else (step 5).
    await Migrations.grandfatherOnboarding(txn);

    // 4. Reset AUTOINCREMENT cursors so the next insert continues from the
    // max restored id, not the pre-restore high-water mark. Explicit-id
    // inserts only ever RAISE the sequence, so a backup with lower ids needs
    // this to bring it back down.
    for (final table in _autoincTables) {
      await txn.rawUpdate(
        'UPDATE sqlite_sequence SET seq = '
        '(SELECT COALESCE(MAX(id), 0) FROM $table) WHERE name = ?',
        [table],
      );
    }

    // 5. Integrity gate → controlled rollback. A dangling deferred FK would
    // fail the implicit commit anyway; the explicit check throws first for a
    // clean, unit-testable rollback path.
    final violations = await txn.rawQuery('PRAGMA foreign_key_check');
    if (violations.isNotEmpty) {
      throw StateError('restore aborted: referential integrity violation');
    }
  });
}
