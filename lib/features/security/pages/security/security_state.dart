part of 'security_cubit.dart';

/// State for the Security settings page: the current [config], whether the
/// device offers biometrics (gates the biometric switch), and a [busy] flag
/// while a biometric confirmation is in flight.
@freezed
abstract class SecurityState with _$SecurityState {
  const factory SecurityState({
    @Default(LockConfig()) LockConfig config,
    @Default(false) bool biometricAvailable,
    @Default(false) bool busy,
  }) = _SecurityState;
}
