import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/export/domain/entities/export_csv_result.dart';
import 'package:jaga_saku/features/export/domain/entities/export_date_preset.dart';
import 'package:jaga_saku/features/export/domain/entities/export_options.dart';
import 'package:jaga_saku/features/export/pages/export/cubit/export_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// State-machine + delivery tests for [ExportCubit] (deterministic `now`).
/// Covers load, updateOptions, the export happy path (stable filename +
/// share), the empty-result branch (no file, no share), failure, and the
/// re-entry guard. The cubit has no save/delete usecase, so there is no
/// mutation surface to exercise (read-only by construction).
void main() {
  setUpAll(registerFallbackValues);

  late MockExportTransactionsCsv exportCsv;
  late MockGetAccounts getAccounts;
  late MockGetCategories getCategories;
  late MockExportFileService fileService;

  const account = Account(id: 1, name: 'Cash', type: AccountType.cash);
  const category = Category(id: 1, name: 'Makan', type: CategoryType.expense);
  const result = ExportCsvResult(content: 'header\r\nrow', rowCount: 1);

  ExportCubit build() => ExportCubit(
    exportCsv: exportCsv,
    getAccounts: getAccounts,
    getCategories: getCategories,
    fileService: fileService,
    now: () => DateTime(2026, 7, 17, 14, 30),
  );

  setUp(() {
    exportCsv = MockExportTransactionsCsv();
    getAccounts = MockGetAccounts();
    getCategories = MockGetCategories();
    fileService = MockExportFileService();
    // Happy-path defaults; individual tests override.
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Account>>([account]));
    when(
      () => getCategories(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Category>>([category]));
    when(
      () => exportCsv(any()),
    ).thenAnswer((_) async => const Right<Failure, ExportCsvResult>(result));
    when(
      () => fileService.write(any(), any()),
    ).thenAnswer((_) async => '/tmp/exports/f.csv');
    when(() => fileService.share(any())).thenAnswer((_) async {});
  });

  // ── load ──────────────────────────────────────────────────────────────────
  blocTest<ExportCubit, ExportState>(
    'load fetches accounts + both category types → [loading, configuring]',
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      const ExportState.loading(),
      isA<ExportConfiguring>()
          .having((s) => s.accounts, 'accounts', const [account])
          // expense + income calls each return [category] → merged length 2.
          .having((s) => s.categories.length, 'categories', 2)
          .having((s) => s.isExporting, 'isExporting', false),
    ],
    verify: (_) {
      verify(() => getAccounts(any())).called(1);
      verify(() => getCategories(any())).called(2);
    },
  );

  blocTest<ExportCubit, ExportState>(
    'load failure → [loading, loadFailure]',
    setUp: () => when(() => getAccounts(any())).thenAnswer(
      (_) async => const Left<Failure, List<Account>>(CacheFailure()),
    ),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      ExportState.loading(),
      ExportState.loadFailure(CacheFailure()),
    ],
  );

  // ── updateOptions ───────────────────────────────────────────────────────────
  blocTest<ExportCubit, ExportState>(
    'updateOptions re-emits configuring carrying the new options',
    build: build,
    act: (cubit) async {
      await cubit.load();
      cubit.updateOptions(
        const ExportOptions(preset: ExportDatePreset.all, accountId: 1),
      );
    },
    skip: 2, // [loading, configuring] from load()
    expect: () => [
      isA<ExportConfiguring>()
          .having((s) => s.options.preset, 'preset', ExportDatePreset.all)
          .having((s) => s.options.accountId, 'accountId', 1),
    ],
  );

  // ── export ──────────────────────────────────────────────────────────────────
  blocTest<ExportCubit, ExportState>(
    'export success: spins, writes the stable filename, shares, then re-configures',
    build: build,
    act: (cubit) async {
      await cubit.load();
      await cubit.export();
    },
    skip: 2,
    expect: () => [
      isA<ExportConfiguring>().having(
        (s) => s.isExporting,
        'isExporting',
        true,
      ),
      const ExportState.success(1),
      isA<ExportConfiguring>().having(
        (s) => s.isExporting,
        'isExporting',
        false,
      ),
    ],
    verify: (_) {
      final captured = verify(
        () => fileService.write(captureAny(), any()),
      ).captured;
      expect(captured.single, 'jaga-saku-transactions-20260717-1430.csv');
      verify(() => fileService.share(any())).called(1);
    },
  );

  blocTest<ExportCubit, ExportState>(
    'export with zero rows → emptyResult, no file written, no share',
    setUp: () => when(() => exportCsv(any())).thenAnswer(
      (_) async => const Right<Failure, ExportCsvResult>(
        ExportCsvResult(content: 'header', rowCount: 0),
      ),
    ),
    build: build,
    act: (cubit) async {
      await cubit.load();
      await cubit.export();
    },
    skip: 2,
    expect: () => [
      isA<ExportConfiguring>().having(
        (s) => s.isExporting,
        'isExporting',
        true,
      ),
      const ExportState.emptyResult(),
      isA<ExportConfiguring>().having(
        (s) => s.isExporting,
        'isExporting',
        false,
      ),
    ],
    verify: (_) {
      verifyNever(() => fileService.write(any(), any()));
      verifyNever(() => fileService.share(any()));
    },
  );

  blocTest<ExportCubit, ExportState>(
    'export failure from the usecase → failure toast then re-configure',
    setUp: () => when(() => exportCsv(any())).thenAnswer(
      (_) async => const Left<Failure, ExportCsvResult>(CacheFailure()),
    ),
    build: build,
    act: (cubit) async {
      await cubit.load();
      await cubit.export();
    },
    skip: 2,
    expect: () => [
      isA<ExportConfiguring>().having(
        (s) => s.isExporting,
        'isExporting',
        true,
      ),
      const ExportState.failure(CacheFailure()),
      isA<ExportConfiguring>().having(
        (s) => s.isExporting,
        'isExporting',
        false,
      ),
    ],
    verify: (_) => verifyNever(() => fileService.write(any(), any())),
  );

  blocTest<ExportCubit, ExportState>(
    're-entry: export() while already exporting emits nothing and no-ops',
    build: build,
    seed: () => const ExportState.configuring(
      options: ExportOptions(),
      accounts: [],
      categories: [],
      isExporting: true,
    ),
    act: (cubit) => cubit.export(),
    expect: () => const <ExportState>[],
    verify: (_) => verifyNever(() => exportCsv(any())),
  );
}
