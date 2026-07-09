import 'package:sqflite/sqflite.dart';

/// Versioned schema DDL. [onCreate] builds the latest schema on a fresh DB;
/// [migrate] steps an existing DB forward one version at a time.
///
/// Money = INTEGER rupiah (positive; sign implied by transaction type).
/// Dates = INTEGER epoch millis. Colors = INTEGER ARGB.
class Migrations {
  Migrations._();

  /// Current schema version. Bump when adding a new `_v<N>` step and wiring it
  /// into [migrate].
  static const int latestVersion = 1;

  /// Runs on a brand-new database — builds the full v1 schema.
  static Future<void> onCreate(Database db) => _v1(db);

  /// Steps an existing database from [oldVersion] to [newVersion].
  static Future<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // No migrations beyond v1 yet. Add `if (oldVersion < 2) await _v2(db);`
    // etc. as the schema evolves.
  }

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
}
