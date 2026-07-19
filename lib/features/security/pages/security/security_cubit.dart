import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/security/app_lock_service.dart';
import 'package:jaga_saku/features/security/domain/entities/auto_lock_duration.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:jaga_saku/features/security/domain/usecases/get_lock_config.dart';
import 'package:jaga_saku/features/security/domain/usecases/is_biometric_available.dart';
import 'package:jaga_saku/features/security/domain/usecases/set_auto_lock_duration.dart';
import 'package:jaga_saku/features/security/domain/usecases/set_biometric_enabled.dart';

part 'security_cubit.freezed.dart';
part 'security_state.dart';

/// Outcome of toggling the biometric switch — drives the page's toast.
enum BiometricToggleResult { enabled, cancelled, disabled, failure }

/// Drives the Security settings page: load config + biometric availability, and
/// toggle biometric / auto-lock. Enable/disable/change PIN itself is done by the
/// PIN-entry flow (pushed by the page); this cubit reloads via [refresh] on
/// return. After every write it re-reads config from [AppLockService] (the
/// source of truth) so the switches reflect what actually persisted.
class SecurityCubit extends Cubit<SecurityState> {
  SecurityCubit({
    required GetLockConfig getLockConfig,
    required IsBiometricAvailable isBiometricAvailable,
    required SetBiometricEnabled setBiometricEnabled,
    required SetAutoLockDuration setAutoLockDuration,
    required AppLockService appLock,
  }) : _getLockConfig = getLockConfig,
       _isBiometricAvailable = isBiometricAvailable,
       _setBiometricEnabled = setBiometricEnabled,
       _setAutoLockDuration = setAutoLockDuration,
       _appLock = appLock,
       super(const SecurityState());

  final GetLockConfig _getLockConfig;
  final IsBiometricAvailable _isBiometricAvailable;
  final SetBiometricEnabled _setBiometricEnabled;
  final SetAutoLockDuration _setAutoLockDuration;
  final AppLockService _appLock;

  Future<void> load() async {
    final configResult = await _getLockConfig(NoParams());
    final availableResult = await _isBiometricAvailable(NoParams());
    if (isClosed) return;
    emit(
      state.copyWith(
        config: configResult.getOrElse((_) => const LockConfig()),
        biometricAvailable: availableResult.getOrElse((_) => false),
      ),
    );
  }

  /// Reloads after returning from the PIN-entry flow.
  Future<void> refresh() => load();

  /// Enables / disables biometric. Enabling runs a live confirmation
  /// (repo-side); returns the outcome so the page can toast success / cancel /
  /// error. Reflects the persisted config afterwards.
  Future<BiometricToggleResult> toggleBiometric({
    required bool enabled,
    required String reason,
  }) async {
    emit(state.copyWith(busy: true));
    // Enabling runs a live biometric prompt inside the repo — suppress the
    // auto-lock across it, or the app locks itself the moment it succeeds.
    final result = await _appLock.duringAuthPrompt(
      () => _setBiometricEnabled(
        SetBiometricParams(enabled: enabled, reason: reason),
      ),
    );
    await _appLock.refreshConfig();
    if (isClosed) return BiometricToggleResult.failure;
    emit(state.copyWith(busy: false, config: _appLock.config));
    return result.match(
      (_) => BiometricToggleResult.failure,
      (applied) => enabled
          ? (applied
                ? BiometricToggleResult.enabled
                : BiometricToggleResult.cancelled)
          : BiometricToggleResult.disabled,
    );
  }

  /// Persists the auto-lock threshold (a local pref — no failure surface).
  Future<void> setAutoLockDuration(AutoLockDuration duration) async {
    await _setAutoLockDuration(duration);
    await _appLock.refreshConfig();
    if (isClosed) return;
    emit(state.copyWith(config: _appLock.config));
  }
}
