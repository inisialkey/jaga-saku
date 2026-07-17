part of 'export_cubit.dart';

/// State machine for the Export screen.
///
/// [configuring] carries the form data plus an [isExporting] flag (rather than a
/// separate "exporting" state) so the form never disappears mid-export — the
/// button just spins. [success] / [emptyResult] / [failure] are **one-shot**
/// signals the page's `BlocListener` turns into toasts; the cubit re-emits
/// [configuring] immediately after each, and the builder's `buildWhen` ignores
/// the one-shots so it keeps rendering the last form.
@freezed
sealed class ExportState with _$ExportState {
  const factory ExportState.loading() = ExportLoading;

  const factory ExportState.loadFailure(Failure failure) = ExportLoadFailure;

  const factory ExportState.configuring({
    required ExportOptions options,
    required List<Account> accounts,
    required List<Category> categories,
    @Default(false) bool isExporting,
  }) = ExportConfiguring;

  const factory ExportState.success(int rowCount) = ExportSuccess;

  const factory ExportState.emptyResult() = ExportEmptyResult;

  const factory ExportState.failure(Failure failure) = ExportFailure;
}
