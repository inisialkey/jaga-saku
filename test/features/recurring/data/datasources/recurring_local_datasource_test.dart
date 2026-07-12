import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/features/recurring/data/datasources/recurring_local_datasource.dart';
import 'package:jaga_saku/features/recurring/data/models/recurring_model.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/templates/data/models/tx_template_model.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../helpers/mocks.dart';

/// Exercises [RecurringLocalDatasource] against a real in-memory sqflite (ffi)
/// database (schema via [Migrations.onCreate], FK ON), mocking only
/// [AppDatabase]. Proves the two-table atomic insert (C3), the join read, the
/// FK cascade on delete (C4) and the cursor advance.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late RecurringLocalDatasource datasource;

  TxTemplateModel tpl(String label, {int? amount = 50000}) => TxTemplateModel(
    label: label,
    type: TransactionType.expense,
    accountId: 1,
    amount: amount,
    categoryId: 1,
    isFavorite: false,
    createdAt: 1,
  );

  RecurringModel rule({
    required int start,
    required int nextDue,
    RecurrenceFreq freq = RecurrenceFreq.monthly,
    int interval = 1,
    int? endDate,
  }) => RecurringModel(
    templateId: 0,
    freq: freq,
    interval: interval,
    startDate: start,
    endDate: endDate,
    nextDue: nextDue,
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
    // FK parents for the owned template (account_id / category_id).
    await db.insert('accounts', {
      'id': 1,
      'name': 'Cash',
      'type': 'cash',
      'created_at': 0,
    });
    await db.insert('categories', {
      'id': 1,
      'name': 'Bills',
      'type': 'expense',
      'created_at': 0,
    });
    final appDatabase = MockAppDatabase();
    when(() => appDatabase.db).thenReturn(db);
    datasource = RecurringLocalDatasource(appDatabase);
  });

  tearDown(() => db.close());

  test('insertRuleWithTemplate writes BOTH rows atomically (C3)', () async {
    final ruleId = await datasource.insertRuleWithTemplate(
      tpl('Rent'),
      rule(start: 1000, nextDue: 1000),
    );

    // The owned template landed with is_favorite = 0 and is NOT in the
    // favorites strip.
    final templates = await db.query('tx_templates');
    expect(templates, hasLength(1));
    expect(templates.single['label'], 'Rent');
    expect(templates.single['is_favorite'], 0);

    // The recurring row landed, linked to the freshly-inserted template, with
    // next_due seeded to the start.
    final recurring = await db.query('recurring');
    expect(recurring, hasLength(1));
    expect(recurring.single['id'], ruleId);
    expect(recurring.single['template_id'], templates.single['id']);
    expect(recurring.single['next_due'], 1000);
  });

  test('getRules joins the template and orders by next_due', () async {
    await datasource.insertRuleWithTemplate(
      tpl('Later'),
      rule(start: 5000, nextDue: 5000),
    );
    await datasource.insertRuleWithTemplate(
      tpl('Sooner', amount: 12345),
      rule(start: 1000, nextDue: 1000),
    );

    final rules = await datasource.getRules();
    expect(rules.map((r) => r.template?.label), ['Sooner', 'Later']);
    expect(rules.first.template?.amount, 12345);
    expect(rules.first.template?.isFavorite, isFalse);
    expect(rules.first.nextDue, 1000);
  });

  test(
    'deleteRule deletes the template so the FK cascades the rule (C4)',
    () async {
      await datasource.insertRuleWithTemplate(
        tpl('Rent'),
        rule(start: 1000, nextDue: 1000),
      );
      final templateId = (await db.query('tx_templates')).single['id']! as int;

      final removed = await datasource.deleteRule(templateId);

      expect(removed, 1);
      expect(await db.query('tx_templates'), isEmpty);
      expect(await db.query('recurring'), isEmpty); // cascade fired
    },
  );

  test('advanceCursor persists the new next_due', () async {
    final ruleId = await datasource.insertRuleWithTemplate(
      tpl('Rent'),
      rule(start: 1000, nextDue: 1000),
    );

    await datasource.advanceCursor(ruleId, 9999);

    final rules = await datasource.getRules();
    expect(rules.single.nextDue, 9999);
  });

  test('updateRule updates both the template and the rule rows', () async {
    final ruleId = await datasource.insertRuleWithTemplate(
      tpl('Rent'),
      rule(start: 1000, nextDue: 1000),
    );
    final templateId = (await db.query('tx_templates')).single['id']! as int;

    await datasource.updateRule(
      tpl('Rent+', amount: 75000).copyWith(id: templateId),
      rule(
        start: 1000,
        nextDue: 2000,
        interval: 2,
      ).copyWith(id: ruleId, templateId: templateId),
    );

    final rules = await datasource.getRules();
    expect(rules.single.template?.label, 'Rent+');
    expect(rules.single.template?.amount, 75000);
    expect(rules.single.interval, 2);
    expect(rules.single.nextDue, 2000);
  });
}
