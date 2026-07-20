import 'package:flutter/foundation.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:jaga_saku/features/onboarding/domain/usecases/get_onboarding_progress.dart';

/// App-global onboarding gate input (V5-M1): a [ChangeNotifier] DI singleton,
/// [load]ed once before `runApp` exactly like `AppLockService`. It is one half
/// of `appRouter`'s merged `refreshListenable`.
///
/// It holds ONLY [isCompleted] — the single input the router redirect reads.
/// The current STEP is deliberately not here: step changes are internal
/// `PageView` state, and exposing a step setter would invite a
/// `notifyListeners()` per step. A router refresh re-parses the stack from the
/// *encoded* route state and silently drops any non-JSON `extra` (no
/// `extraCodec` is configured) — the failure mode fixed in
/// `AppLockService.refreshConfig` (commit c5cf379). During onboarding the user
/// can be standing on `/accounts/form`, whose `extra` carries the suggested-
/// chip prefill `Account`; a spurious refresh would blank it mid-typing.
/// Keeping the step off this class makes that impossible rather than merely
/// discouraged.
///
/// App-lifetime singleton — never disposed (like `AppSettingsCubit`).
class OnboardingService extends ChangeNotifier {
  OnboardingService({required GetOnboardingProgress getProgress})
    : _getProgress = getProgress;

  final GetOnboardingProgress _getProgress;

  OnboardingProgress _progress = const OnboardingProgress();

  bool get isCompleted => _progress.completed;

  OnboardingProgress get progress => _progress;

  /// Reads the marker before the first frame so the very first redirect already
  /// knows whether to gate — no flash of Home on a fresh install.
  ///
  /// A `Left` (settings/DB fault) FAILS OPEN — treated as completed — so a
  /// storage error can never lock a user out of their own data. Same fail-safe
  /// posture as `AppLockService.load` ("a Left keeps the app usable"). A fresh
  /// install is not this case: an absent key reads as `Right(completed: false)`.
  Future<void> load() async {
    final result = await _getProgress(NoParams());
    result.match(
      (_) => _progress = const OnboardingProgress(completed: true),
      (progress) => _progress = progress,
    );
    notifyListeners();
  }

  /// The ONLY notifying transition after [load]: called by `OnboardingCubit`
  /// once `CompleteOnboarding` has persisted. The router then re-runs the gate
  /// and maps `/onboarding` to `/home`. Safe to notify here — at this moment
  /// the stack is `[/onboarding]`, which carries no `extra`.
  void markCompleted() {
    if (_progress.completed) return;
    _progress = _progress.copyWith(completed: true);
    notifyListeners();
  }
}
