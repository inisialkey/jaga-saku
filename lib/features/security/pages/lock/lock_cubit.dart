import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/security/app_lock_service.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:jaga_saku/features/security/domain/entities/pin_check.dart';
import 'package:jaga_saku/features/security/domain/usecases/authenticate_biometric.dart';
import 'package:jaga_saku/features/security/domain/usecases/verify_pin.dart';

part 'lock_cubit.freezed.dart';
part 'lock_state.dart';

/// Drives the lock screen: fills the 6-digit buffer, verifies (inheriting the
/// datasource's persisted backoff), and — when biometric is enabled — auto-
/// prompts once on open. On success it flips [AppLockService.unlock] so the
/// redirect releases the user. Every emit after an `await` is guarded by
/// [isClosed]; the cooldown [Timer.periodic] is cancelled in [close] (Rule 7).
class LockCubit extends Cubit<LockState> {
  LockCubit({
    required VerifyPin verifyPin,
    required AuthenticateBiometric authenticateBiometric,
    required AppLockService appLock,
    required LockConfig config,
    required String biometricReason,
    DateTime Function()? now,
  }) : _verifyPin = verifyPin,
       _authenticateBiometric = authenticateBiometric,
       _appLock = appLock,
       _config = config,
       _biometricReason = biometricReason,
       _now = now ?? DateTime.now,
       super(const LockState.input()) {
    if (_config.isBiometricEnabled) unawaited(authenticateWithBiometric());
  }

  final VerifyPin _verifyPin;
  final AuthenticateBiometric _authenticateBiometric;
  final AppLockService _appLock;
  final LockConfig _config;
  final String _biometricReason;
  final DateTime Function() _now;

  static const int _pinLength = 6;

  String _pin = '';
  int _failedAttempts = 0;
  Timer? _cooldownTimer;

  bool get isBiometricEnabled => _config.isBiometricEnabled;

  /// Runs the biometric prompt. Success unlocks; any cancel / failure is a
  /// silent PIN fallback (stays on the current state).
  Future<void> authenticateWithBiometric() async {
    final result = await _appLock.duringAuthPrompt(
      () => _authenticateBiometric(_biometricReason),
    );
    if (isClosed) return;
    result.match((_) {}, (ok) {
      if (ok) _unlock();
    });
  }

  void addDigit(String digit) {
    if (state is LockVerifying || state is LockCooldown) return;
    if (_pin.length >= _pinLength) return;
    _pin += digit;
    emit(
      LockState.input(
        enteredCount: _pin.length,
        failedAttempts: _failedAttempts,
      ),
    );
    if (_pin.length == _pinLength) unawaited(_submit());
  }

  void backspace() {
    if (state is LockVerifying || state is LockCooldown) return;
    if (_pin.isEmpty) return;
    _pin = _pin.substring(0, _pin.length - 1);
    emit(
      LockState.input(
        enteredCount: _pin.length,
        failedAttempts: _failedAttempts,
      ),
    );
  }

  Future<void> _submit() async {
    emit(const LockState.verifying());
    final result = await _verifyPin(_pin);
    if (isClosed) return;
    // A storage glitch (Left) is treated as a retryable wrong entry — the pad
    // stays usable, no cooldown.
    result.match((_) => _onWrong(_failedAttempts, null), _handleCheck);
  }

  void _handleCheck(PinCheck check) {
    switch (check) {
      case PinCheckOk():
        _unlock();
      case PinCheckWrong(:final failedAttempts, :final cooldownUntilMs):
        _failedAttempts = failedAttempts;
        _onWrong(failedAttempts, cooldownUntilMs);
      case PinCheckLockedOut(:final cooldownUntilMs):
        _pin = '';
        _startCooldown(cooldownUntilMs);
    }
  }

  void _onWrong(int attempts, int? cooldownUntilMs) {
    _pin = '';
    if (cooldownUntilMs != null) {
      _startCooldown(cooldownUntilMs);
    } else {
      emit(LockState.error(failedAttempts: attempts));
    }
  }

  void _startCooldown(int untilMs) {
    _cooldownTimer?.cancel();
    emit(
      LockState.cooldown(
        untilMs: untilMs,
        remainingSeconds: _remaining(untilMs),
      ),
    );
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) return;
      final remaining = _remaining(untilMs);
      if (remaining <= 0) {
        _cooldownTimer?.cancel();
        emit(LockState.input(failedAttempts: _failedAttempts));
      } else {
        emit(LockState.cooldown(untilMs: untilMs, remainingSeconds: remaining));
      }
    });
  }

  int _remaining(int untilMs) =>
      ((untilMs - _now().millisecondsSinceEpoch) / 1000).ceil();

  void _unlock() {
    _cooldownTimer?.cancel();
    _appLock.unlock();
    emit(const LockState.unlocked());
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
  }
}
