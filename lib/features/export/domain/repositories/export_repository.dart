import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/export/domain/entities/export_csv_result.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';

/// Contract for producing a CSV export of the filtered `transactions` ledger.
/// Read-only — resolves [params] into rows, serializes them, and never mutates
/// app data. Returns `Left(Failure)` on any DB/serialize error (rule 4).
abstract class ExportRepository {
  Future<Either<Failure, ExportCsvResult>> exportCsv(
    SearchTransactionParams params,
  );
}
