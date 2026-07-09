import 'package:sqflite/sqflite.dart';

/// Seeds the default accounts + categories on first DB creation only (called
/// from `onCreate`). Icons are stored as string keys (mapped to `IconData` in
/// the UI layer later); colors are ARGB ints used by the expense donut chart.
class Seed {
  Seed._();

  static Future<void> run(Database db) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = db.batch();

    // ── Accounts ─────────────────────────────────────────────────────────
    const accounts = [
      ('Cash', 'cash', 'wallet'),
      ('BCA', 'bank', 'account_balance'),
      ('GoPay', 'ewallet', 'account_balance_wallet'),
    ];
    for (var i = 0; i < accounts.length; i++) {
      final (name, type, icon) = accounts[i];
      batch.insert('accounts', {
        'name': name,
        'type': type,
        'opening_balance': 0,
        'icon': icon,
        'sort_order': i,
        'archived': 0,
        'created_at': now,
      });
    }

    // ── Expense categories (with donut colors, ARGB ints) ────────────────
    const expenseCategories = [
      ('Makan', 'restaurant', 0xFF16A34A),
      ('Transport', 'directions_bus', 0xFF3B82F6),
      ('Kopi', 'local_cafe', 0xFFF59E0B),
      ('Belanja', 'shopping_bag', 0xFFEF4444),
      ('Hiburan', 'movie', 0xFF8B5CF6),
      ('Lainnya', 'category', 0xFF64748B),
    ];
    for (var i = 0; i < expenseCategories.length; i++) {
      final (name, icon, color) = expenseCategories[i];
      batch.insert('categories', {
        'name': name,
        'type': 'expense',
        'icon': icon,
        'color': color,
        'sort_order': i,
        'archived': 0,
        'created_at': now,
      });
    }

    // ── Income categories ────────────────────────────────────────────────
    const incomeCategories = [
      ('Gaji', 'payments', 0xFF22C55E),
      ('Lainnya', 'category', 0xFF0EA5E9),
    ];
    for (var i = 0; i < incomeCategories.length; i++) {
      final (name, icon, color) = incomeCategories[i];
      batch.insert('categories', {
        'name': name,
        'type': 'income',
        'icon': icon,
        'color': color,
        'sort_order': i,
        'archived': 0,
        'created_at': now,
      });
    }

    await batch.commit(noResult: true);
  }
}
