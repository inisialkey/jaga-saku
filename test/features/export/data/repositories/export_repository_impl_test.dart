import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/export/data/repositories/export_repository_impl.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// Maps crafted joined column maps through [ExportRepositoryImpl.exportCsv]:
/// proves the inline row mapping, `source` derivation, `receipt_attached`
/// hiding, CSV escaping, `rowCount`, and the never-throws → `Left(CacheFailure)`
/// guarantee (rule 4).
void main() {
  late MockTransactionLocalDatasource datasource;
  late ExportRepositoryImpl repository;

  const params = SearchTransactionParams();

  Map<String, Object?> joined({
    required String type,
    required String accountName,
    String? targetAccountName,
    String? categoryName,
    String? categorySystemKey,
    String? plannedStatus,
    String? spendingType,
    String? note,
    String? receiptPath,
    int amount = 1000,
  }) => {
    'id': 1,
    'type': type,
    'amount': amount,
    'account_id': 1,
    'to_account_id': targetAccountName == null ? null : 2,
    'category_id': categoryName == null ? null : 1,
    'planned_status': plannedStatus,
    'spending_type': spendingType,
    'date': DateTime(2026, 7, 8).millisecondsSinceEpoch,
    'note': note,
    'receipt_path': receiptPath,
    'created_at': DateTime(2026, 7, 8, 14, 30).millisecondsSinceEpoch,
    'account_name': accountName,
    'target_account_name': targetAccountName,
    'category_name': categoryName,
    'category_system_key': categorySystemKey,
  };

  setUp(() {
    datasource = MockTransactionLocalDatasource();
    repository = ExportRepositoryImpl(datasource);
  });

  test('maps joined rows to CSV with correct rowCount and escaping', () async {
    when(() => datasource.searchWithNames(params)).thenAnswer(
      (_) async => [
        joined(
          type: 'expense',
          accountName: 'Cash',
          categoryName: 'Makan',
          plannedStatus: 'planned',
          spendingType: 'need',
          note: 'Lunch, drinks',
          amount: 35000,
        ),
        joined(
          type: 'expense',
          accountName: 'Cash',
          categoryName: 'Penyesuaian',
          categorySystemKey: 'adjustment_in',
          amount: 5000,
        ),
        joined(
          type: 'transfer',
          accountName: 'Cash',
          targetAccountName: 'BCA',
          receiptPath: 'receipts/1.jpg',
          amount: 20000,
        ),
      ],
    );

    final result = await repository.exportCsv(params);

    expect(result.isRight(), isTrue);
    final data = result.getRight().toNullable()!;
    expect(data.rowCount, 3);

    final lines = data.content.split('\r\n');
    expect(lines, hasLength(4)); // header + 3 rows
    // Row 1 — a note with a comma is RFC-quoted.
    expect(lines[1].contains('"Lunch, drinks"'), isTrue);
    expect(lines[1].contains(',manual,'), isTrue);
    // Row 2 — adjustment_in category derives the reconciliation source.
    expect(lines[2].contains(',reconciliation,'), isTrue);
    // Row 3 — transfer: target filled, empty category, receipt yes.
    expect(lines[3].contains(',transfer,manual,Cash,BCA,,'), isTrue);
    expect(lines[3].contains(',yes,'), isTrue);
  });

  test(
    'an empty result set yields a header-only file with rowCount 0',
    () async {
      when(
        () => datasource.searchWithNames(params),
      ).thenAnswer((_) async => []);

      final result = await repository.exportCsv(params);

      final data = result.getRight().toNullable()!;
      expect(data.rowCount, 0);
      expect(
        data.content.contains('\r\n'),
        isFalse,
      ); // header only, no data rows
    },
  );

  test(
    'a datasource throw folds to Left(CacheFailure), never throws',
    () async {
      when(
        () => datasource.searchWithNames(params),
      ).thenThrow(Exception('boom'));

      final result = await repository.exportCsv(params);

      expect(result.isLeft(), isTrue);
      expect(result.getLeft().toNullable(), const CacheFailure());
    },
  );
}
