import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Thin wrapper over [LocalAuthentication] (V3-M4). Biometric is only an
/// accelerator over the base PIN, so every failure / cancel path returns
/// `false` and the caller falls back to PIN silently — a raw
/// [PlatformException] never surfaces (Rule 17). Hits a platform channel, so it
/// is coverage-ignored and exercised by the manual device pass in the DoD.
// coverage:ignore-file
class BiometricAuthDatasource {
  BiometricAuthDatasource({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  /// Whether the device supports biometrics AND has some enrolled — the gate
  /// for showing the biometric toggle and for the lock-screen auto-prompt.
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  /// Runs a biometric-only prompt. Any failure / cancel → `false` so the caller
  /// stays on PIN entry (never hard-blocks).
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException {
      return false;
    }
  }
}
