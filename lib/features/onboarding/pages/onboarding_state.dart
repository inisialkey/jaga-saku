part of 'onboarding_cubit.dart';

/// Lifecycle of the two writing actions (Quick Start, Start Tracking). A status
/// enum rather than a sealed union, because [OnboardingState.accounts] must
/// survive the `submitting` transition — a union would force the list into
/// every case. Mirrors `AccountFormState`.
enum OnboardingStatus { editing, submitting, completed, failure }

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(OnboardingStep.welcome) OnboardingStep step,
    @Default(<Account>[]) List<Account> accounts,
    @Default(OnboardingStatus.editing) OnboardingStatus status,
    Failure? error,

    /// One-shot §18 duplicate-name hint. Set when a just-saved account shares
    /// its (trimmed, case-insensitive) name with an existing one; the page
    /// fires an info toast and calls `clearDuplicateHint`. Never blocks a save.
    String? duplicateName,
  }) = _OnboardingState;

  const OnboardingState._();

  bool get isSubmitting => status == OnboardingStatus.submitting;

  bool get hasAccounts => accounts.isNotEmpty;

  int get accountCount => accounts.length;

  int get totalOpeningBalance =>
      accounts.fold(0, (sum, a) => sum + a.openingBalance);

  /// Account Setup is the only step with a completion gate: every other step's
  /// primary CTA is always live.
  bool get canContinue => step != OnboardingStep.accounts || hasAccounts;
}
