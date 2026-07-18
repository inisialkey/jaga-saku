part of 'lock_cubit.dart';

/// State machine for the lock screen (V3-M4). The entered PIN buffer lives in
/// the cubit; states carry only what the UI renders. `error` is a resting state
/// (empty pad) that also one-shot-triggers the wrong-PIN haptic + toast; the
/// next digit resumes `input`.
@freezed
sealed class LockState with _$LockState {
  /// Entering the PIN. [enteredCount] drives the dot indicators.
  const factory LockState.input({
    @Default(0) int enteredCount,
    @Default(0) int failedAttempts,
  }) = LockInput;

  /// Verifying the entered PIN — the pad is disabled.
  const factory LockState.verifying() = LockVerifying;

  /// A wrong PIN was just entered (pad cleared) — the one-shot wrong-PIN signal.
  const factory LockState.error({@Default(0) int failedAttempts}) = LockError;

  /// Cooling down after repeated wrong PINs. [remainingSeconds] ticks each
  /// second for the countdown; [untilMs] is the epoch-ms it lifts.
  const factory LockState.cooldown({
    required int untilMs,
    required int remainingSeconds,
  }) = LockCooldown;

  /// Unlocked — the gate releases the user to their route.
  const factory LockState.unlocked() = LockUnlocked;
}
