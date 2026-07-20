import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/save_account.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:jaga_saku/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:jaga_saku/features/onboarding/domain/usecases/get_onboarding_progress.dart';
import 'package:jaga_saku/features/onboarding/domain/usecases/mark_quick_start_selected.dart';
import 'package:jaga_saku/features/onboarding/domain/usecases/set_onboarding_step.dart';
import 'package:jaga_saku/features/onboarding/onboarding_service.dart';

part 'onboarding_state.dart';
part 'onboarding_cubit.freezed.dart';

/// Drives the 4-step onboarding `PageView` (V5-M1).
///
/// Every step change persists through [SetOnboardingStep] and every account
/// persists immediately through the existing [SaveAccount], so a kill
/// mid-onboarding loses nothing (§14). Navigation to Home is NOT this cubit's
/// job: [complete] flips `OnboardingService`, whose notification makes the
/// router redirect map `/onboarding` to `/home`.
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required GetOnboardingProgress getProgress,
    required SetOnboardingStep setStep,
    required MarkQuickStartSelected markQuickStartSelected,
    required CompleteOnboarding completeOnboarding,
    required GetAccounts getAccounts,
    required SaveAccount saveAccount,
    required OnboardingService onboardingService,
  }) : _getProgress = getProgress,
       _setStep = setStep,
       _markQuickStartSelected = markQuickStartSelected,
       _completeOnboarding = completeOnboarding,
       _getAccounts = getAccounts,
       _saveAccount = saveAccount,
       _onboardingService = onboardingService,
       super(const OnboardingState());

  final GetOnboardingProgress _getProgress;
  final SetOnboardingStep _setStep;
  final MarkQuickStartSelected _markQuickStartSelected;
  final CompleteOnboarding _completeOnboarding;
  final GetAccounts _getAccounts;
  final SaveAccount _saveAccount;
  final OnboardingService _onboardingService;

  /// Resumes at the persisted step with the already-created accounts. A `Left`
  /// on either read leaves the defaults (a fresh install has neither) — the
  /// first paint of a first run must not open with a failure toast.
  Future<void> load() async {
    final progress = await _getProgress(NoParams());
    if (isClosed) return;
    final step = progress.fold((_) => state.step, (p) => p.step);
    final accounts = await _readAccounts();
    if (isClosed) return;
    emit(state.copyWith(step: step, accounts: accounts));
  }

  /// Advances one step. Blocked by [OnboardingState.canContinue] (Account Setup
  /// with no accounts) and inert on the last step. Persists AFTER the emit so
  /// the UI never waits on disk.
  Future<void> next() async {
    if (!state.canContinue || state.step.isLast) return;
    final next = OnboardingStep.values[state.step.index + 1];
    emit(state.copyWith(step: next));
    await _setStep(next);
  }

  /// Steps back; a no-op on Welcome (§14 — Back is hidden there).
  Future<void> back() async {
    if (state.step.isFirst) return;
    final previous = OnboardingStep.values[state.step.index - 1];
    emit(state.copyWith(step: previous));
    await _setStep(previous);
  }

  /// The escape hatch on the one step that would otherwise trap the user:
  /// creates a single `Cash` account at `openingBalance: 0` and jumps to the
  /// summary. The name is a literal, not localized — it is a DB row the user
  /// renames freely later.
  Future<void> quickStart() async {
    if (state.isSubmitting) return;
    emit(state.copyWith(status: OnboardingStatus.submitting, error: null));

    final result = await _saveAccount(
      Account(
        name: 'Cash',
        type: AccountType.cash,
        icon: 'wallet',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    if (isClosed) return;
    final failure = result.fold<Failure?>((f) => f, (_) => null);
    if (failure != null) {
      emit(state.copyWith(status: OnboardingStatus.failure, error: failure));
      return;
    }

    await _markQuickStartSelected(NoParams());
    if (isClosed) return;
    final accounts = await _readAccounts();
    if (isClosed) return;
    emit(
      state.copyWith(
        accounts: accounts,
        step: OnboardingStep.summary,
        status: OnboardingStatus.editing,
      ),
    );
    await _setStep(OnboardingStep.summary);
  }

  /// Called by the page after the account form pops `true`. Reloads the list and
  /// raises the §18 duplicate-name hint when the new row collides with an
  /// existing name — a hint only; the save has already happened.
  Future<void> accountSaved() async {
    final knownIds = state.accounts.map((a) => a.id).toSet();
    final accounts = await _readAccounts();
    if (isClosed) return;
    final added = accounts.where((a) => !knownIds.contains(a.id));
    emit(
      state.copyWith(
        accounts: accounts,
        duplicateName: added.isEmpty
            ? null
            : _collidingName(added.first, accounts),
      ),
    );
  }

  /// Consumes the one-shot hint once the page has shown its toast.
  void clearDuplicateHint() {
    if (state.duplicateName == null) return;
    emit(state.copyWith(duplicateName: null));
  }

  /// *Start Tracking* — persists the completion marker, then releases the gate.
  Future<void> complete() async {
    if (state.isSubmitting) return;
    emit(state.copyWith(status: OnboardingStatus.submitting, error: null));

    final result = await _completeOnboarding(NoParams());
    if (isClosed) return;
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: OnboardingStatus.failure, error: failure),
        (_) => state.copyWith(status: OnboardingStatus.completed),
      ),
    );
    // Emit BEFORE notifying: markCompleted triggers the redirect, which
    // disposes this route and closes the cubit.
    if (state.status == OnboardingStatus.completed) {
      _onboardingService.markCompleted();
    }
  }

  /// Accounts as the DB has them; a `Left` keeps whatever is already on screen.
  Future<List<Account>> _readAccounts() async {
    final result = await _getAccounts(NoParams());
    return result.getOrElse((_) => state.accounts);
  }

  /// The name [account] shares (trimmed, case-insensitively) with another row,
  /// or null when it is unique.
  String? _collidingName(Account account, List<Account> accounts) {
    final name = account.name.trim().toLowerCase();
    final collides = accounts.any(
      (a) => a.id != account.id && a.name.trim().toLowerCase() == name,
    );
    return collides ? account.name : null;
  }
}
