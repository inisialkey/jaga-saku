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
  static const int latestVersion = 2;

  /// Runs on a brand-new database — replays every version step in order so a
  /// fresh install produces the exact schema an upgrade-from-v1 produces. Steps
  /// from `_v2` on are `IF NOT EXISTS` + append-only, so replaying them on a
  /// just-created DB is safe.
  static Future<void> onCreate(Database db) async {
    await _v1(db);
    await _v2(db);
  }

  /// Steps an existing database from [oldVersion] to [newVersion], applying only
  /// the steps newer than [oldVersion].
  static Future<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) await _v2(db);
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
}
