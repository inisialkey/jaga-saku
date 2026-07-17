import 'package:freezed_annotation/freezed_annotation.dart';

part 'export_csv_result.freezed.dart';

/// The result of a CSV export: the full serialized [content] plus the number of
/// data [rowCount] rows it holds (header excluded). [rowCount] drives the
/// empty-result branch in the cubit (0 rows → info toast, no share) and the
/// success toast count.
@freezed
abstract class ExportCsvResult with _$ExportCsvResult {
  const factory ExportCsvResult({
    required String content,
    required int rowCount,
  }) = _ExportCsvResult;
}
