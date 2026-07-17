import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/export/domain/entities/export_date_preset.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

part 'export_options.freezed.dart';

/// The on-screen export selection (not persisted). [preset] drives the date
/// window; [customStart] / [customEnd] are midnight-local epoch millis set only
/// while `preset == custom`. The remaining fields are optional filters — `null`
/// means "all". [toParams] resolves the selection into the shared
/// [SearchTransactionParams] the query surface consumes.
///
/// Cross-feature **domain** import of [SearchTransactionParams] + the ledger
/// enums is allowed (domain→domain, no data/Flutter — rule 19).
@freezed
abstract class ExportOptions with _$ExportOptions {
  const factory ExportOptions({
    @Default(ExportDatePreset.thisMonth) ExportDatePreset preset,
    int? customStart,
    int? customEnd,
    int? accountId,
    int? categoryId,
    TransactionType? type,
    PlannedStatus? plannedStatus,
    SpendingType? spendingType,
  }) = _ExportOptions;

  const ExportOptions._();

  /// Resolves the current selection into the shared query params, using [now]
  /// (a seam) for the relative presets. The custom upper bound is pushed to the
  /// **next day's midnight** so the picked end date is inclusive; `[start, end)`
  /// stays half-open everywhere.
  SearchTransactionParams toParams(DateTime now) {
    final (int? start, int? end) = switch (preset) {
      ExportDatePreset.thisMonth => (
        DateTime(now.year, now.month).millisecondsSinceEpoch,
        DateTime(now.year, now.month + 1).millisecondsSinceEpoch,
      ),
      ExportDatePreset.lastMonth => (
        DateTime(now.year, now.month - 1).millisecondsSinceEpoch,
        DateTime(now.year, now.month).millisecondsSinceEpoch,
      ),
      ExportDatePreset.custom => (
        customStart,
        customEnd == null ? null : _nextMidnight(customEnd!),
      ),
      ExportDatePreset.all => (null, null),
    };
    return SearchTransactionParams(
      startDate: start,
      endDate: end,
      accountId: accountId,
      categoryId: categoryId,
      type: type,
      plannedStatus: plannedStatus,
      spendingType: spendingType,
    );
  }

  /// Midnight of the day after [millis] (calendar arithmetic, DST-safe — mirrors
  /// the datasource's `getByDay` upper bound).
  static int _nextMidnight(int millis) {
    final d = DateTime.fromMillisecondsSinceEpoch(millis);
    return DateTime(d.year, d.month, d.day + 1).millisecondsSinceEpoch;
  }
}
