import 'package:flutter/foundation.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:jaga_saku/features/security/domain/usecases/get_lock_config.dart';

/// App-global lock controller (V3-M4): a [ChangeNotifier] DI singleton, [load]ed
/// once before `runApp` like `AppSettingsCubit`. It is the `refreshListenable`
/// on `appRouter`, so every lock / unlock re-runs the redirect instantly.
///
/// The clock is injected ([now]) so the auto-lock elapsed-time decision is
/// unit-tested without a real clock; the lifecycle observer in `app.dart` just
/// calls [markBackgrounded] / [evaluateAutoLock]. App-lifetime singleton — never
/// disposed (like `AppSettingsCubit` / `TxChangeNotifier`).
class AppLockService extends ChangeNotifier {
  AppLockService({
    required GetLockConfig getLockConfig,
    DateTime Function()? now,
  }) : _getLockConfig = getLockConfig,
       _now = now ?? DateTime.now;

  final GetLockConfig _getLockConfig;
  final DateTime Function() _now;

  LockConfig _config = const LockConfig();
  bool _isLocked = false;
  int? _backgroundedAtMs;

  bool get isPinEnabled => _config.isPinEnabled;
  bool get isLocked => _isLocked;
  LockConfig get config => _config;

  /// Reads config before the first frame. When a PIN is enabled the app starts
  /// LOCKED (the cold-start gate). A `Left` (storage fault) keeps the off
  /// defaults so the app stays usable. Always notifies so the first redirect
  /// evaluates against the loaded state.
  Future<void> load() async {
    final result = await _getLockConfig(NoParams());
    result.match((_) {}, (config) {
      _config = config;
      _isLocked = config.isPinEnabled;
    });
    notifyListeners();
  }

  /// Reloads config after a settings write (enable / disable / biometric /
  /// duration). Leaves [isLocked] as-is — enabling a PIN does not lock the
  /// already-open session.
  Future<void> refreshConfig() async {
    final result = await _getLockConfig(NoParams());
    result.match((_) {}, (config) => _config = config);
    notifyListeners();
  }

  /// Stamps the moment the app was backgrounded (paused / hidden).
  void markBackgrounded() => _backgroundedAtMs = _now().millisecondsSinceEpoch;

  /// On resume: re-lock when a PIN is set AND the elapsed background time
  /// reached the threshold. `immediately` (Duration.zero) locks on any
  /// background. No PIN ⇒ never locks.
  void evaluateAutoLock() {
    if (!isPinEnabled) return;
    final nowMs = _now().millisecondsSinceEpoch;
    final elapsed = nowMs - (_backgroundedAtMs ?? nowMs);
    if (elapsed >= _config.autoLockDuration.duration.inMilliseconds) {
      _isLocked = true;
      _backgroundedAtMs = null;
      notifyListeners();
    }
  }

  /// Marks the app unlocked — called by `LockCubit` on a successful PIN or
  /// biometric unlock; the redirect then releases the user to their route.
  void unlock() {
    _isLocked = false;
    _backgroundedAtMs = null;
    notifyListeners();
  }
}
