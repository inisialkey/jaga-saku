import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/export/domain/entities/export_csv_result.dart';
import 'package:jaga_saku/features/export/domain/repositories/export_repository.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';

/// Builds the filtered-transaction CSV for the given [SearchTransactionParams].
/// Thin pass-through to [ExportRepository.exportCsv] — covered by the repository
/// and cubit tests (no dedicated test).
class ExportTransactionsCsv
    extends UseCase<ExportCsvResult, SearchTransactionParams> {
  ExportTransactionsCsv(this._repository);

  final ExportRepository _repository;

  @override
  Future<Either<Failure, ExportCsvResult>> call(
    SearchTransactionParams params,
  ) => _repository.exportCsv(params);
}
