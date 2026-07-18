import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/features/export/data/csv_serializer.dart';
import 'package:jaga_saku/features/export/domain/entities/export_csv_result.dart';
import 'package:jaga_saku/features/export/domain/entities/export_row.dart';
import 'package:jaga_saku/features/export/domain/repositories/export_repository.dart';
import 'package:jaga_saku/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction_source.dart';
import 'package:sqflite/sqflite.dart';

/// Reads the filtered, join-resolved transaction rows from the shared
/// [TransactionLocalDatasource] (cross-feature data→data, precedented by the
/// recurring datasource), maps each raw row to an [ExportRow] inline, serializes
/// them, and returns an [ExportCsvResult]. Every path is guarded — a DB or
/// serialize error folds to `Left(CacheFailure)`; the repo never throws
/// (rule 4).
class ExportRepositoryImpl implements ExportRepository {
  ExportRepositoryImpl(this._datasource);

  final TransactionLocalDatasource _datasource;

  static const CsvSerializer _serializer = CsvSerializer();

  @override
  Future<Either<Failure, ExportCsvResult>> exportCsv(
    SearchTransactionParams params,
  ) => _guard(() async {
    final rawRows = await _datasource.searchWithNames(params);
    final rows = rawRows.map(_toRow).toList();
    final content = _serializer.serialize(rows);
    return ExportCsvResult(content: content, rowCount: rows.length);
  });

  /// Maps one joined `transactions` column map to a typed [ExportRow]. Names
  /// come from the join aliases; [TransactionSource] is derived from the joined
  /// `category_system_key`; `receipt_attached` hides the device-local path.
  ExportRow _toRow(Map<String, Object?> r) => ExportRow(
    date: (r['date'] as int?) ?? 0,
    type: TransactionType.fromValue(r['type'] as String?),
    source: TransactionSource.fromSystemKey(
      r['category_system_key'] as String?,
    ),
    account: (r['account_name'] as String?) ?? '',
    targetAccount: r['target_account_name'] as String?,
    category: r['category_name'] as String?,
    amount: (r['amount'] as int?) ?? 0,
    plannedStatus: PlannedStatus.fromValue(r['planned_status'] as String?),
    spendingType: SpendingType.fromValue(r['spending_type'] as String?),
    note: r['note'] as String?,
    receiptAttached: r['receipt_path'] != null,
    createdAt: (r['created_at'] as int?) ?? 0,
  );

  /// Runs [action], mapping any failure to a [CacheFailure] (DB or file/serialize
  /// error alike). Errors are logged, never surfaced raw.
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DatabaseException catch (e, s) {
      log.e('Export DB failure', error: e, stackTrace: s);
      return const Left(CacheFailure());
    } catch (e, s) {
      log.e('Export failure', error: e, stackTrace: s);
      return const Left(CacheFailure());
    }
  }
}
