part of 'pin_entry_cubit.dart';

/// State machine for the create / change / disable PIN flow (V3-M4). The entered
/// buffer lives in the cubit; `enteredCount` drives the dots. `mismatch` and
/// `wrong` are one-shot toast signals immediately followed by the resting input
/// step. `done` tells the page to toast + pop with success.
@freezed
sealed class PinEntryState with _$PinEntryState {
  /// Verifying the current PIN (change / disable start here).
  const factory PinEntryState.verifyCurrent({@Default(0) int enteredCount}) =
      PinEntryVerifyCurrent;

  /// Entering the new PIN (create starts here; change reaches it after verify).
  const factory PinEntryState.enterNew({@Default(0) int enteredCount}) =
      PinEntryEnterNew;

  /// Re-entering the new PIN to confirm.
  const factory PinEntryState.confirm({@Default(0) int enteredCount}) =
      PinEntryConfirm;

  /// A store / verify call is in flight — the pad is disabled.
  const factory PinEntryState.submitting() = PinEntrySubmitting;

  /// Confirm did not match the new PIN — restart at enterNew (never persisted).
  const factory PinEntryState.mismatch() = PinEntryMismatch;

  /// The current PIN was wrong (or is in cooldown) — restart at verifyCurrent.
  const factory PinEntryState.wrong({int? cooldownUntilMs}) = PinEntryWrong;

  /// Success — the PIN was set / changed / disabled.
  const factory PinEntryState.done() = PinEntryDone;
}
