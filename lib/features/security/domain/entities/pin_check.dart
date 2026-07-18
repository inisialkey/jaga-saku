import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_check.freezed.dart';

/// Outcome of a PIN verification (V3-M4). A wrong PIN or an active cooldown are
/// *states* here, not failures: the datasource centralises the backoff so both
/// the lock gate and settings-verify inherit it and the UI never sees the
/// escalation math. Returned as `Right(PinCheck)` from the repo — `Left(Failure)`
/// is reserved for a real storage fault.
@freezed
sealed class PinCheck with _$PinCheck {
  /// PIN matched — clear to unlock.
  const factory PinCheck.ok() = PinCheckOk;

  /// PIN did not match. [failedAttempts] is the running count; when the backoff
  /// has armed a cooldown, [cooldownUntilMs] is the epoch-ms it lifts.
  const factory PinCheck.wrong({
    required int failedAttempts,
    int? cooldownUntilMs,
  }) = PinCheckWrong;

  /// Verification was refused because a cooldown is still active — no hash
  /// compare happened. [cooldownUntilMs] is the epoch-ms it lifts.
  const factory PinCheck.lockedOut({required int cooldownUntilMs}) =
      PinCheckLockedOut;
}
