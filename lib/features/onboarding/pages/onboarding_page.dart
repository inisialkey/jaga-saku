import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:jaga_saku/features/onboarding/pages/onboarding_cubit.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/account_setup_step.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/onboarding_progress_dots.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/setup_summary_step.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/value_proposition_step.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/welcome_step.dart';

/// The single onboarding route (V5-M1): a 4-page `PageView` under one shared
/// shell, so the CTA block never moves between steps.
///
/// Deliberately NOT per-step routes — back + state retention (§14) fall out for
/// free, and it sidesteps the `extra`-dropping refresh hazard entirely.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    // Seed from whatever step the cubit already holds. On a cold route build
    // that is Welcome (load() has not emitted yet) and the listener animates to
    // the resumed step; this only pre-positions when the cubit is already
    // populated (e.g. a hot reload), so it can never start on the wrong page.
    _controller = PageController(
      initialPage: context.read<OnboardingCubit>().state.step.index,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        _syncPage(state.step);

        final duplicate = state.duplicateName;
        if (duplicate != null) {
          // §18: an INFO toast, never a field error, never a blocker.
          s.onboardingDuplicateAccountHint(duplicate).toToastLoading(context);
          context.read<OnboardingCubit>().clearDuplicateHint();
        }
        if (state.status == OnboardingStatus.failure) {
          (state.error?.localize(context) ?? s.errorUnexpected).toToastError(
            context,
          );
        }
      },
      builder: (context, state) => PopScope(
        // System back steps the flow instead of leaving it; on Welcome
        // `back()` is a no-op, so there is no way out of onboarding (§14).
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) context.read<OnboardingCubit>().back();
        },
        // safeArea defaults to true — never pass false here, or the bottom CTA
        // collides with the home indicator / gesture bar.
        child: AppScaffold(
          body: Column(
            children: [
              _BackRow(visible: !state.step.isFirst),
              Expanded(
                child: PageView(
                  controller: _controller,
                  // CTA-driven only: a swipe past an incomplete step would
                  // bypass `canContinue`.
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const WelcomeStep(),
                    const ValuePropositionStep(),
                    AccountSetupStep(
                      accounts: state.accounts,
                      onSuggestionTap: (prefill) =>
                          _openAccountForm(context, prefill: prefill),
                    ),
                    SetupSummaryStep(
                      accountCount: state.accountCount,
                      totalOpeningBalance: state.totalOpeningBalance,
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OnboardingProgressDots(step: state.step),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    label: _primaryLabel(s, state),
                    isLoading: state.isSubmitting && _primaryWrites(state),
                    // Deliberately NOT gated on `canContinue`: that is the
                    // *advance* gate, and on an empty Account Setup the primary
                    // is *Add Account*, not advance — gating it there rendered
                    // the only route to a blank form untappable. A stray
                    // advance is harmless: `next()` self-guards on
                    // `canContinue`.
                    onPressed: state.isSubmitting
                        ? null
                        : () => _onPrimary(context, state),
                  ),
                  if (_secondaryLabel(s, state) case final label?)
                    TextButtonX(
                      label: label,
                      isLoading: state.isSubmitting && _secondaryWrites(state),
                      onPressed: state.isSubmitting
                          ? null
                          : () => _onSecondary(context, state),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Keeps the `PageView` on the cubit's step. Guarded on `hasClients` because
  /// the first listener callback can land before the view is attached.
  void _syncPage(OnboardingStep step) {
    if (!_controller.hasClients) return;
    if (_controller.page?.round() == step.index) return;
    _controller.animateToPage(
      step.index,
      duration: AppDurations.normal,
      curve: Curves.easeOutCubic,
    );
  }

  String _primaryLabel(Strings s, OnboardingState state) =>
      switch (state.step) {
        OnboardingStep.welcome => s.onboardingGetStarted,
        OnboardingStep.value => s.onboardingContinue,
        OnboardingStep.accounts =>
          state.hasAccounts ? s.onboardingContinue : s.addAccount,
        OnboardingStep.summary => s.onboardingStartTracking,
      };

  /// Exactly two CTAs write to sqflite: *Start Tracking* (the summary primary)
  /// and *Quick Start* (the secondary on an empty Account Setup). Every other
  /// CTA only moves the `PageView` or pushes the account form, so the spinner
  /// must be scoped to the control that owns the in-flight write — otherwise
  /// tapping Quick Start spins the *primary*, a button the user never touched.
  bool _primaryWrites(OnboardingState state) =>
      state.step == OnboardingStep.summary;

  bool _secondaryWrites(OnboardingState state) =>
      state.step == OnboardingStep.accounts && !state.hasAccounts;

  String? _secondaryLabel(Strings s, OnboardingState state) =>
      switch (state.step) {
        OnboardingStep.welcome => null,
        OnboardingStep.value => s.onboardingSkip,
        // Never "Skip" here — Quick Start is the non-judgemental escape (§20).
        OnboardingStep.accounts =>
          state.hasAccounts
              ? s.onboardingAddAnotherAccount
              : s.onboardingQuickStart,
        OnboardingStep.summary => null,
      };

  void _onPrimary(BuildContext context, OnboardingState state) {
    final cubit = context.read<OnboardingCubit>();
    switch (state.step) {
      case OnboardingStep.welcome:
      case OnboardingStep.value:
        cubit.next();
      case OnboardingStep.accounts:
        if (state.hasAccounts) {
          cubit.next();
        } else {
          _openAccountForm(context);
        }
      case OnboardingStep.summary:
        cubit.complete();
    }
  }

  void _onSecondary(BuildContext context, OnboardingState state) {
    final cubit = context.read<OnboardingCubit>();
    switch (state.step) {
      case OnboardingStep.value:
        cubit.next();
      case OnboardingStep.accounts:
        if (state.hasAccounts) {
          _openAccountForm(context);
        } else {
          cubit.quickStart();
        }
      case OnboardingStep.welcome:
      case OnboardingStep.summary:
        break;
    }
  }

  /// Pushes the REAL account form (`account_list_page.dart:160` is the same
  /// call), optionally seeded from a suggestion chip. Reading the cubit BEFORE
  /// the await is what makes this safe without a `context.mounted` check — the
  /// same reason the accounts list does it. Never touch `context` after it.
  Future<void> _openAccountForm(
    BuildContext context, {
    Account? prefill,
  }) async {
    final cubit = context.read<OnboardingCubit>();
    final saved = await context.push<bool>(
      AppRoute.accountForm,
      extra: prefill,
    );
    if (saved ?? false) await cubit.accountSaved();
  }
}

/// The back affordance — hidden (but space-preserving) on Welcome, per §14.
class _BackRow extends StatelessWidget {
  const _BackRow({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: kMinInteractiveDimension,
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: visible
          ? IconButton(
              tooltip: Strings.of(context)!.onboardingBack,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.read<OnboardingCubit>().back(),
            )
          : null,
    ),
  );
}
