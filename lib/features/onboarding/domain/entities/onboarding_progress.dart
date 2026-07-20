import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_progress.freezed.dart';

/// The four onboarding steps, in flow order. Persisted as [name] in the
/// `settings` kv (TEXT-only), so the index is never stored — reordering the
/// enum can't corrupt a resumed session.
enum OnboardingStep {
  welcome,
  value,
  accounts,
  summary;

  /// Maps a stored name back to the enum, defaulting to [welcome] for an
  /// unknown / legacy / absent value (never throws) — mirrors
  /// `AccountType.fromValue`.
  static OnboardingStep fromName(String? name) => OnboardingStep.values
      .firstWhere((s) => s.name == name, orElse: () => OnboardingStep.welcome);

  bool get isFirst => this == OnboardingStep.welcome;

  bool get isLast => this == OnboardingStep.summary;
}

/// Persisted onboarding state (V5-M1). Three `settings` kv keys; defaults are
/// the fresh-install state, so a brand-new DB reads as "not started at step 1".
/// Mirrors `LockConfig` — the same freezed-over-kv shape.
@freezed
abstract class OnboardingProgress with _$OnboardingProgress {
  const factory OnboardingProgress({
    @Default(false) bool completed,
    @Default(OnboardingStep.welcome) OnboardingStep step,
    @Default(false) bool quickStartSelected,
  }) = _OnboardingProgress;
}
