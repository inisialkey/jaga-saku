part of 'reconcile_cubit.dart';

/// Lifecycle of a reconcile. A status enum gives the page clean one-shot
/// transitions to listen on. [noChange] (delta == 0) toasts "already correct"
/// and pops without a write; [success] pops after the correction is saved.
enum ReconcileStatus { editing, saving, success, noChange, failure }

/// Working state of the reconcile sheet. [currentBalance] is the derived balance
/// snapshot at open; [counted] is what the user counted (null until typed).
@freezed
abstract class ReconcileState with _$ReconcileState {
  const factory ReconcileState({
    required int currentBalance,
    int? counted,
    @Default(ReconcileStatus.editing) ReconcileStatus status,
    Failure? error,

    /// False until [ReconcileCubit.load] resolves BOTH reserved ids. When false
    /// (a botched migration) confirm is disabled and confirm() is a no-op + log
    /// (C5) — the sheet never writes an untagged correction.
    @Default(false) bool systemReady,
  }) = _ReconcileState;

  const ReconcileState._();

  /// counted − current. > 0 = income adjustment, < 0 = expense, 0 = no change.
  /// An untouched (null counted) sheet reads as 0 ("already correct").
  int get delta => (counted ?? currentBalance) - currentBalance;

  bool get canConfirm => systemReady && status != ReconcileStatus.saving;
}
