import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/core/utils/services/export_file_service.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/export/domain/entities/export_options.dart';
import 'package:jaga_saku/features/export/domain/export_file_name.dart';
import 'package:jaga_saku/features/export/domain/usecases/export_transactions_csv.dart';

part 'export_cubit.freezed.dart';
part 'export_state.dart';

/// Drives the Export screen: loads the account / category filter data, tracks
/// the on-screen [ExportOptions], and runs the export (resolve params → build
/// CSV → write temp file → share sheet). Read-only — no save/delete usecase is
/// injected, so there is no mutation surface. Every emit after an `await` is
/// guarded by [isClosed]; there is no stream subscription, so [close] needs no
/// override. [now] is a seam so the date-range resolution and the filename are
/// deterministic in tests.
class ExportCubit extends Cubit<ExportState> {
  ExportCubit({
    required ExportTransactionsCsv exportCsv,
    required GetAccounts getAccounts,
    required GetCategories getCategories,
    required ExportFileService fileService,
    DateTime Function() now = DateTime.now,
  }) : _exportCsv = exportCsv,
       _getAccounts = getAccounts,
       _getCategories = getCategories,
       _fileService = fileService,
       _now = now,
       super(const ExportState.loading());

  final ExportTransactionsCsv _exportCsv;
  final GetAccounts _getAccounts;
  final GetCategories _getCategories;
  final ExportFileService _fileService;
  final DateTime Function() _now;

  ExportOptions _options = const ExportOptions();
  List<Account> _accounts = const [];
  List<Category> _categories = const [];

  /// Loads accounts + (expense & income) categories for the filter pickers. Any
  /// `Left` short-circuits to [ExportLoadFailure] (the page shows a retry).
  Future<void> load() async {
    emit(const ExportState.loading());

    final accountsResult = await _getAccounts(NoParams());
    if (isClosed) return;
    if (accountsResult.isLeft()) {
      emit(ExportState.loadFailure(accountsResult.getLeft().toNullable()!));
      return;
    }

    final expenseResult = await _getCategories(CategoryType.expense);
    if (isClosed) return;
    if (expenseResult.isLeft()) {
      emit(ExportState.loadFailure(expenseResult.getLeft().toNullable()!));
      return;
    }

    final incomeResult = await _getCategories(CategoryType.income);
    if (isClosed) return;
    if (incomeResult.isLeft()) {
      emit(ExportState.loadFailure(incomeResult.getLeft().toNullable()!));
      return;
    }

    _accounts = accountsResult.getRight().toNullable()!;
    _categories = [
      ...expenseResult.getRight().toNullable()!,
      ...incomeResult.getRight().toNullable()!,
    ];
    emit(_configuring());
  }

  /// Replaces the current selection and re-renders the form. Clearing a filter
  /// to "All" relies on freezed's `copyWith(field: null)` at the call site.
  void updateOptions(ExportOptions options) {
    _options = options;
    emit(_configuring());
  }

  /// Resolves the options into query params, builds the CSV, writes it, and
  /// opens the share sheet. Zero matching rows → [emptyResult] (no file, no
  /// share). Re-entrant taps while a run is in flight are ignored.
  Future<void> export() async {
    final current = state;
    if (current is ExportConfiguring && current.isExporting) return;
    emit(_configuring(isExporting: true));

    final result = await _exportCsv(_options.toParams(_now()));
    if (isClosed) return;
    if (result.isLeft()) {
      emit(ExportState.failure(result.getLeft().toNullable()!));
      emit(_configuring());
      return;
    }

    final data = result.getRight().toNullable()!;
    if (data.rowCount == 0) {
      emit(const ExportState.emptyResult());
      emit(_configuring());
      return;
    }

    try {
      final path = await _fileService.write(
        exportFileName(_now()),
        data.content,
      );
      if (isClosed) return;
      await _fileService.share(path);
      if (isClosed) return;
      emit(ExportState.success(data.rowCount));
    } catch (e, s) {
      log.e('Export delivery failed', error: e, stackTrace: s);
      if (isClosed) return;
      emit(const ExportState.failure(CacheFailure()));
    }
    if (isClosed) return;
    emit(_configuring());
  }

  ExportState _configuring({bool isExporting = false}) =>
      ExportState.configuring(
        options: _options,
        accounts: _accounts,
        categories: _categories,
        isExporting: isExporting,
      );
}
