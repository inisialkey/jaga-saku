import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/features/recurring/data/models/recurring_model.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/templates/data/models/tx_template_model.dart';

/// sqflite DAO for the `recurring` table. Reads/writes through the shared
/// [AppDatabase] connection (resolved per call via `.db`); never opens its own.
///
/// A recurring rule OWNS a `tx_templates` shape (`is_favorite = 0`, hidden from
/// the Home strip), so writes span two tables — always inside one
/// `db.transaction` (both rows or neither, C3). Deletes hit the TEMPLATE so the
/// FK `ON DELETE CASCADE` drops the rule (C4 — deleting the rule directly would
/// orphan the template).
class RecurringLocalDatasource {
  RecurringLocalDatasource(this._database);

  final AppDatabase _database;

  static const String _table = 'recurring';

  /// Every rule joined to its owned template (label / amount / shape for the
  /// manage list + catch-up), ordered by the cursor then id. The joined
  /// [TxTemplate] is hung on `RecurringRule.template` (non-persisted).
  Future<List<RecurringRule>> getRules() async {
    final rows = await _database.db.rawQuery('''
      SELECT r.id, r.template_id, r.freq, r.interval, r.start_date, r.end_date,
             r.next_due, r.created_at,
             t.id AS tpl_id, t.label AS tpl_label, t.type AS tpl_type,
             t.amount AS tpl_amount, t.account_id AS tpl_account_id,
             t.to_account_id AS tpl_to_account_id, t.category_id AS tpl_category_id,
             t.planned_status AS tpl_planned_status,
             t.spending_type AS tpl_spending_type, t.note AS tpl_note,
             t.is_favorite AS tpl_is_favorite, t.sort_order AS tpl_sort_order,
             t.created_at AS tpl_created_at
      FROM $_table r
      JOIN tx_templates t ON t.id = r.template_id
      ORDER BY r.next_due, r.id
    ''');
    return rows.map((row) {
      final template = TxTemplateModel.fromMap({
        'id': row['tpl_id'],
        'label': row['tpl_label'],
        'type': row['tpl_type'],
        'amount': row['tpl_amount'],
        'account_id': row['tpl_account_id'],
        'to_account_id': row['tpl_to_account_id'],
        'category_id': row['tpl_category_id'],
        'planned_status': row['tpl_planned_status'],
        'spending_type': row['tpl_spending_type'],
        'note': row['tpl_note'],
        'is_favorite': row['tpl_is_favorite'],
        'sort_order': row['tpl_sort_order'],
        'created_at': row['tpl_created_at'],
      }).toEntity();
      return RecurringModel.fromMap(
        row,
      ).toEntity().copyWith(template: template);
    }).toList();
  }

  /// C3 — inserts the owned template then the rule in ONE transaction (both rows
  /// or neither). The template's `is_favorite` is already `0` in its map;
  /// `template_id` is stamped from the freshly-inserted row id, and `next_due`
  /// is already set to `start_date` by the caller. Returns the new rule id.
  Future<int> insertRuleWithTemplate(
    TxTemplateModel template,
    RecurringModel rule,
  ) => _database.db.transaction((txn) async {
    final templateId = await txn.insert('tx_templates', template.toMap());
    return txn.insert(_table, {...rule.toMap(), 'template_id': templateId});
  });

  /// Updates both the owned template row and the rule row in one transaction.
  Future<void> updateRule(TxTemplateModel template, RecurringModel rule) =>
      _database.db.transaction((txn) async {
        await txn.update(
          'tx_templates',
          template.toMap(),
          where: 'id = ?',
          whereArgs: [template.id],
        );
        await txn.update(
          _table,
          rule.toMap(),
          where: 'id = ?',
          whereArgs: [rule.id],
        );
      });

  /// C4 — deletes the owned TEMPLATE so the FK `ON DELETE CASCADE` removes the
  /// recurring row too (deleting the recurring row directly would orphan the
  /// template). Returns the number of template rows removed.
  Future<int> deleteRule(int templateId) => _database.db.delete(
    'tx_templates',
    where: 'id = ?',
    whereArgs: [templateId],
  );

  /// Advances the idempotency cursor after a confirm / skip. The cursor only
  /// ever moves forward (the usecase computes the next occurrence).
  Future<void> advanceCursor(int ruleId, int nextDue) => _database.db.update(
    _table,
    {'next_due': nextDue},
    where: 'id = ?',
    whereArgs: [ruleId],
  );
}
