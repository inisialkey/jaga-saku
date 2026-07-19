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
  bool _authPromptActive = false;

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
  ///
  /// Deliberately does NOT notify: only [isLocked] transitions need the router
  /// to re-run the gate, and `redirect` reads [isPinEnabled] live on every
  /// navigation anyway. A spurious refresh makes go_router re-parse the stack
  /// from the *encoded* route state, which drops any non-JSON `extra` (no
  /// `extraCodec` is configured) — that is how enabling a PIN used to null out
  /// `/pin-entry`'s own `PinEntryArgs` mid-flow and crash on `state.extra!`.
  Future<void> refreshConfig() async {
    final result = await _getLockConfig(NoParams());
    result.match((_) {}, (config) => _config = config);
  }

  /// Stamps the moment the app was backgrounded (paused / hidden). A system
  /// auth sheet is not a real background — see [duringAuthPrompt].
  void markBackgrounded() {
    if (_authPromptActive) return;
    _backgroundedAtMs = _now().millisecondsSinceEpoch;
  }

  /// Runs [action] — anything that shows a system auth sheet (the biometric
  /// prompt) — with the auto-lock suppressed. Android can drive the app through
  /// `paused`/`resumed` to show that sheet, and reading it as a real background
  /// re-locks the app the instant biometric unlocked it. Clearing the stamp in
  /// the `finally` makes both event orders (resume before / after the future
  /// completes) fall into the no-stamp branch of [evaluateAutoLock].
  Future<T> duringAuthPrompt<T>(Future<T> Function() action) async {
    _authPromptActive = true;
    try {
      return await action();
    } finally {
      _authPromptActive = false;
      _backgroundedAtMs = null;
    }
  }

  /// On resume: re-lock when a PIN is set AND the elapsed background time
  /// reached the threshold. `immediately` (Duration.zero) locks on any
  /// background. No PIN ⇒ never locks.
  ///
  /// A resume consumes its stamp. With no stamp this resume had no matching
  /// background, so it never locks — the old `?? nowMs` fallback made `elapsed`
  /// 0, which satisfies `>= 0` under `immediately` and re-locked on any stray
  /// resume.
  void evaluateAutoLock() {
    if (!isPinEnabled) return;
    final backgroundedAtMs = _backgroundedAtMs;
    _backgroundedAtMs = null;
    if (backgroundedAtMs == null) return;
    final elapsed = _now().millisecondsSinceEpoch - backgroundedAtMs;
    if (elapsed >= _config.autoLockDuration.duration.inMilliseconds) {
      _isLocked = true;
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
