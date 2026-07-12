import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/recurring/data/repositories/recurring_repository_impl.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../helpers/mocks.dart';

/// Repository maps datasource outcomes to `Either<Failure, T>` and never throws.
/// A genuine sqflite [DatabaseException] (a NOT NULL clash) drives the failure
/// mapping rather than a fake.
void main() {
  late DatabaseException genericError;

  setUpAll(() async {
    registerFallbackValues();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: Migrations.latestVersion,
        onCreate: (db, _) => Migrations.onCreate(db),
      ),
    );
    try {
      // `name` is NOT NULL — a non-unique constraint violation.
      await db.insert('accounts', {'type': 'cash', 'created_at': 0});
    } on DatabaseException catch (e) {
      genericError = e;
    }
    await db.close();
  });

  late MockRecurringLocalDatasource datasource;
  late RecurringRepositoryImpl repository;

  const template = TxTemplate(
    label: 'Rent',
    type: TransactionType.expense,
    accountId: 1,
    amount: 50000,
    isFavorite: false,
  );
  const rule = RecurringRule(
    templateId: 0,
    freq: RecurrenceFreq.monthly,
    startDate: 1000,
    nextDue: 1000,
  );

  setUp(() {
    datasource = MockRecurringLocalDatasource();
    repository = RecurringRepositoryImpl(datasource);
  });

  test('getRules success maps models to Right(entities)', () async {
    when(
      () => datasource.getRules(),
    ).thenAnswer((_) async => [rule.copyWith(id: 1, template: template)]);

    final result = await repository.getRules();

    expect(result.isRight(), isTrue);
    expect(result.getRight().toNullable()?.single.template?.label, 'Rent');
  });

  test('insertRuleWithTemplate returns Right(new rule id)', () async {
    when(
      () => datasource.insertRuleWithTemplate(any(), any()),
    ).thenAnswer((_) async => 42);

    final result = await repository.insertRuleWithTemplate(template, rule);

    expect(result.getRight().toNullable(), 42);
  });

  test('updateRule success → Right(unit)', () async {
    when(() => datasource.updateRule(any(), any())).thenAnswer((_) async {});

    final result = await repository.updateRule(
      template.copyWith(id: 1),
      rule.copyWith(id: 1),
    );

    expect(result.isRight(), isTrue);
  });

  test('deleteRule success → Right(unit)', () async {
    when(() => datasource.deleteRule(1)).thenAnswer((_) async => 1);

    final result = await repository.deleteRule(1);

    expect(result.isRight(), isTrue);
  });

  test('advanceCursor success → Right(unit)', () async {
    when(() => datasource.advanceCursor(1, 2000)).thenAnswer((_) async {});

    final result = await repository.advanceCursor(1, 2000);

    expect(result.isRight(), isTrue);
  });

  test('a DatabaseException → Left(CacheFailure)', () async {
    when(
      () => datasource.insertRuleWithTemplate(any(), any()),
    ).thenThrow(genericError);

    final result = await repository.insertRuleWithTemplate(template, rule);

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });

  test('an unexpected (non-DB) error → Left(CacheFailure)', () async {
    when(() => datasource.deleteRule(1)).thenThrow(Exception('boom'));

    final result = await repository.deleteRule(1);

    expect(result.getLeft().toNullable(), isA<CacheFailure>());
  });
}
