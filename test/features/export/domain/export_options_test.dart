import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/export/domain/entities/export_date_preset.dart';
import 'package:jaga_saku/features/export/domain/entities/export_options.dart';
import 'package:jaga_saku/features/export/domain/export_file_name.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// [ExportOptions.toParams] date-window resolution (deterministic via an
/// injected `now`) and the stable, locale-independent [exportFileName].
void main() {
  int millis(int y, int m, int d) => DateTime(y, m, d).millisecondsSinceEpoch;

  group('toParams date windows', () {
    final now = DateTime(2026, 7, 15, 9, 30);

    test('thisMonth → [month start, next month start)', () {
      final params = const ExportOptions().toParams(now);
      expect(params.startDate, millis(2026, 7, 1));
      expect(params.endDate, millis(2026, 8, 1));
    });

    test('lastMonth → [prev month start, month start)', () {
      final params = const ExportOptions(
        preset: ExportDatePreset.lastMonth,
      ).toParams(now);
      expect(params.startDate, millis(2026, 6, 1));
      expect(params.endDate, millis(2026, 7, 1));
    });

    test('custom → [start, end + 1 day) so the end date is inclusive', () {
      final params = ExportOptions(
        preset: ExportDatePreset.custom,
        customStart: millis(2026, 7, 3),
        customEnd: millis(2026, 7, 20),
      ).toParams(now);
      expect(params.startDate, millis(2026, 7, 3));
      expect(params.endDate, millis(2026, 7, 21));
    });

    test('custom with null bounds stays unbounded', () {
      final params = const ExportOptions(
        preset: ExportDatePreset.custom,
      ).toParams(now);
      expect(params.startDate, isNull);
      expect(params.endDate, isNull);
    });

    test('all → unbounded window', () {
      final params = const ExportOptions(
        preset: ExportDatePreset.all,
      ).toParams(now);
      expect(params.startDate, isNull);
      expect(params.endDate, isNull);
    });

    test('filter fields pass through verbatim', () {
      final params = const ExportOptions(
        accountId: 3,
        categoryId: 8,
        type: TransactionType.income,
        plannedStatus: PlannedStatus.planned,
        spendingType: SpendingType.need,
      ).toParams(now);
      expect(params.accountId, 3);
      expect(params.categoryId, 8);
      expect(params.type, TransactionType.income);
      expect(params.plannedStatus, PlannedStatus.planned);
      expect(params.spendingType, SpendingType.need);
    });
  });

  test('exportFileName is stable and zero-padded', () {
    expect(
      exportFileName(DateTime(2026, 7, 17, 14, 30)),
      'jaga-saku-transactions-20260717-1430.csv',
    );
    // Single-digit month/day/hour/minute are zero-padded.
    expect(
      exportFileName(DateTime(2026, 1, 5, 8, 9)),
      'jaga-saku-transactions-20260105-0809.csv',
    );
  });
}
