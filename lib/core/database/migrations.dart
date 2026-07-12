import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:sqflite/sqflite.dart';

/// Versioned schema DDL. [onCreate] builds the latest schema on a fresh DB by
/// replaying every `_v<N>` step in order; [migrate] steps an existing DB
/// forward, applying only the steps newer than its current version.
///
/// Keep [onCreate] and [migrate] in lock-step: every `_v<N>` must appear in
/// both. `test/core/database/schema_parity_test.dart` fails CI if they diverge.
///
/// Money = INTEGER rupiah. Dates = INTEGER epoch millis. Colors = INTEGER ARGB.
class Migrations {
  Migrations._();

  /// Current schema version. Bump when adding a new `_v<N>` step; wire that step
  /// into BOTH [onCreate] (append `await _vN(db);`) and [migrate]
  /// (append `if (oldVersion < N) await _vN(db);`).
  static const int latestVersion = 6;

  /// Runs on a brand-new database — replays every version step in order so a
  /// fresh install produces the exact schema an upgrade-from-v1 produces. Steps
  /// from `_v2` on are `IF NOT EXISTS` + append-only, so replaying them on a
  /// just-created DB is safe.
  static Future<void> onCreate(Database db) async {
    await _v1(db);
    await _v2(db);
    await _v3(db);
    await _v4(db);
    await _v5(db);
    await _v6(db);
  }

  /// Steps an existing database from [oldVersion] to [newVersion], applying only
  /// the steps newer than [oldVersion].
  static Future<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) await _v2(db);
    if (oldVersion < 3) await _v3(db);
    if (oldVersion < 4) await _v4(db);
    if (oldVersion < 5) await _v5(db);
    if (oldVersion < 6) await _v6(db);
  }

  /// Builds the v1 baseline only. Exposed for the schema-parity test, which
  /// needs a genuine v1 starting point to replay [migrate] against — [onCreate]
  /// now builds the full schema, so it can't double as the v1 baseline. Never
  /// call from app code: it produces an intentionally-incomplete schema.
  @visibleForTesting
  static Future<void> createV1(Database db) => _v1(db);

  static Future<void> _v1(Database db) async {
    await db.execute('''
      CREATE TABLE settings (
        key   TEXT PRIMARY KEY,
        value TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE accounts (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        name            TEXT    NOT NULL,
        type            TEXT    NOT NULL,
        opening_balance INTEGER NOT NULL DEFAULT 0,
        icon            TEXT,
        color           INTEGER,
        sort_order      INTEGER NOT NULL DEFAULT 0,
        archived        INTEGER NOT NULL DEFAULT 0,
        created_at      INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        name       TEXT    NOT NULL,
        type       TEXT    NOT NULL,
        parent_id  INTEGER REFERENCES categories(id) ON DELETE CASCADE,
        icon       TEXT,
        color      INTEGER,
        sort_order INTEGER NOT NULL DEFAULT 0,
        archived   INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id             INTEGER PRIMARY KEY AUTOINCREMENT,
        type           TEXT    NOT NULL,
        amount         INTEGER NOT NULL,
        account_id     INTEGER NOT NULL REFERENCES accounts(id),
        to_account_id  INTEGER REFERENCES accounts(id),
        category_id    INTEGER REFERENCES categories(id),
        planned_status TEXT,
        spending_type  TEXT,
        date           INTEGER NOT NULL,
        note           TEXT,
        created_at     INTEGER NOT NULL
      );
    ''');

    await db.execute('CREATE INDEX idx_tx_date ON transactions(date);');
    await db.execute(
      'CREATE INDEX idx_tx_category ON transactions(category_id);',
    );
    await db.execute(
      'CREATE INDEX idx_tx_account ON transactions(account_id);',
    );

    await db.execute('''
      CREATE TABLE budgets (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id  INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
        period       TEXT    NOT NULL,
        limit_amount INTEGER NOT NULL,
        created_at   INTEGER NOT NULL,
        UNIQUE(category_id, period)
      );
    ''');
  }

  /// v2 — indexes flagged by the pre-V2 audit. Append-only + `IF NOT EXISTS`
  /// so replaying under [onCreate] on a fresh DB is a no-op-safe re-run.
  static Future<void> _v2(Database db) async {
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_budget_period ON budgets(period);',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_cat_type ON categories(type);',
    );
  }

  /// v3 — `tx_templates` (V2-M2 favorites; the shared spine V2-M5 recurring
  /// extends). A template is the add-tx shape minus `date`, plus `label` +
  /// `sort_order`. `amount` is nullable (NULL = ask at use — the prefill path);
  /// `is_favorite` is the int-1/0 flag (no bool columns) filtering the Home strip
  /// from M5's schedule-only shapes. Append-only + `IF NOT EXISTS` so replaying
  /// under [onCreate] on a fresh DB is a no-op-safe re-run.
  static Future<void> _v3(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tx_templates (
        id             INTEGER PRIMARY KEY AUTOINCREMENT,
        label          TEXT    NOT NULL,
        type           TEXT    NOT NULL,
        amount         INTEGER,
        account_id     INTEGER NOT NULL REFERENCES accounts(id),
        to_account_id  INTEGER REFERENCES accounts(id),
        category_id    INTEGER REFERENCES categories(id),
        planned_status TEXT,
        spending_type  TEXT,
        note           TEXT,
        is_favorite    INTEGER NOT NULL DEFAULT 1,
        sort_order     INTEGER NOT NULL DEFAULT 0,
        created_at     INTEGER NOT NULL
      );
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_tpl_sort ON tx_templates(sort_order);',
    );
  }

  /// v4 — receipt attachment (V2-M4). Adds a nullable relative-path column to the
  /// existing `transactions` table. `ADD COLUMN` has no `IF NOT EXISTS`, but `_v4`
  /// runs exactly once per path (onCreate replays it once on a fresh DB; migrate
  /// runs it once for oldVersion < 4), so there is no double-add. Money/date
  /// conventions untouched.
  static Future<void> _v4(Database db) async {
    await db.execute('ALTER TABLE transactions ADD COLUMN receipt_path TEXT;');
  }

  /// v5 — recurring rules (V2-M5). A rule = a `tx_templates` shape
  /// (`is_favorite = 0`) + a schedule; `next_due` is the idempotency cursor (the
  /// earliest UNRESOLVED occurrence). FK `ON DELETE CASCADE`: deleting the owned
  /// template drops the rule (`foreign_keys` is ON at runtime — see
  /// `app_database.dart`). `IF NOT EXISTS` + append-only, so replaying under
  /// [onCreate] on a fresh DB is a no-op-safe re-run. (`interval` is not a
  /// reserved SQLite identifier — SQLite has no INTERVAL type — so it needs no
  /// quoting.)
  static Future<void> _v5(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS recurring (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        template_id INTEGER NOT NULL REFERENCES tx_templates(id) ON DELETE CASCADE,
        freq        TEXT    NOT NULL,
        interval    INTEGER NOT NULL DEFAULT 1,
        start_date  INTEGER NOT NULL,
        end_date    INTEGER,
        next_due    INTEGER NOT NULL,
        created_at  INTEGER NOT NULL
      );
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_recurring_due ON recurring(next_due);',
    );
  }

  /// v6 — wallet reconciliation (V2-M6). Adds the reserved system-category marker
  /// `system_key` and seeds the "Penyesuaian" income/expense pair
  /// (`adjustment_in` / `adjustment_out`) the reconcile write tags.
  ///
  /// The seed lives HERE — NOT in `Seed.run`, which runs on `onCreate` only —
  /// because `_v6` runs under BOTH `onCreate` (a fresh-install replay) AND
  /// `migrate` (an existing-install upgrade), so every install gets the pair.
  /// `ADD COLUMN` has no `IF NOT EXISTS`, but `_v6` runs exactly once per path
  /// (onCreate replays it once on a fresh DB; migrate runs it once for
  /// oldVersion < 6), so the ALTER never double-adds. The seed is factored into
  /// [seedSystemCategories] so the migration test can prove its idempotency
  /// without re-running the once-only ALTER (which would throw).
  static Future<void> _v6(Database db) async {
    await db.execute('ALTER TABLE categories ADD COLUMN system_key TEXT;');
    await seedSystemCategories(db);
  }

  /// Idempotent reserved-pair seed. Each INSERT ... SELECT ... WHERE NOT EXISTS
  /// no-ops when a row with that `system_key` already exists, so a defensive
  /// replay never double-inserts. Supplies every NOT-NULL column (`name`,
  /// `type`, `created_at`); `sort_order` / `archived` fall to their column
  /// defaults (0). `name` is the literal 'Penyesuaian' (a migration can't
  /// localize — the `categoryAdjustment` l10n key mirrors it for any localized
  /// display); `icon` / `color` give the honest ledger tile a slate glyph.
  /// [visibleForTesting] so the idempotency test can call it twice directly.
  @visibleForTesting
  static Future<void> seedSystemCategories(Database db) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    const insert = '''
      INSERT INTO categories (name, type, system_key, icon, color, created_at)
      SELECT ?, ?, ?, ?, ?, ?
      WHERE NOT EXISTS (SELECT 1 FROM categories WHERE system_key = ?)
    ''';
    await db.rawInsert(insert, [
      'Penyesuaian',
      'income',
      'adjustment_in',
      'category',
      0xFF64748B,
      now,
      'adjustment_in',
    ]);
    await db.rawInsert(insert, [
      'Penyesuaian',
      'expense',
      'adjustment_out',
      'category',
      0xFF64748B,
      now,
      'adjustment_out',
    ]);
  }
}
