import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/security/domain/entities/auto_lock_duration.dart';

part 'lock_config.freezed.dart';

/// The persisted, non-secret app-lock configuration (V3-M4). The secret PIN
/// hash + salt live in secure storage, never here. The three fields map to
/// three `settings` kv keys; copyWith / equality drive the reactive
/// `AppLockService`. Defaults are the off state, so a fresh install is never
/// gated.
@freezed
abstract class LockConfig with _$LockConfig {
  const factory LockConfig({
    @Default(false) bool isPinEnabled,
    @Default(false) bool isBiometricEnabled,
    @Default(AutoLockDuration.immediately) AutoLockDuration autoLockDuration,
  }) = _LockConfig;
}
