import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:jaga_saku/features/onboarding/pages/onboarding_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

/// [OnboardingCubit]: step machine + persistence, the Quick Start write, the
/// non-blocking duplicate-name hint, and the completion handshake with
/// `OnboardingService`.
void main() {
  setUpAll(registerFallbackValues);

  late MockGetOnboardingProgress getProgress;
  late MockSetOnboardingStep setStep;
  late MockMarkQuickStartSelected markQuickStartSelected;
  late MockCompleteOnboarding completeOnboarding;
  late MockGetAccounts getAccounts;
  late MockSaveAccount saveAccount;
  late MockOnboardingService onboardingService;

  const bca = Account(
    id: 1,
    name: 'BCA',
    type: AccountType.bank,
    openingBalance: 4500000,
    icon: 'bank',
  );
  const cash = Account(id: 2, name: 'Cash', type: AccountType.cash);

  void stubAccounts(List<Account> accounts) =>
      when(() => getAccounts(any())).thenAnswer((_) async => Right(accounts));

  setUp(() {
    getProgress = MockGetOnboardingProgress();
    setStep = MockSetOnboardingStep();
    markQuickStartSelected = MockMarkQuickStartSelected();
    completeOnboarding = MockCompleteOnboarding();
    getAccounts = MockGetAccounts();
    saveAccount = MockSaveAccount();
    onboardingService = MockOnboardingService();

    when(
      () => getProgress(any()),
    ).thenAnswer((_) async => const Right(OnboardingProgress()));
    when(() => setStep(any())).thenAnswer((_) async => const Right(unit));
    when(
      () => markQuickStartSelected(any()),
    ).thenAnswer((_) async => const Right(unit));
    when(
      () => completeOnboarding(any()),
    ).thenAnswer((_) async => const Right(unit));
    when(() => saveAccount(any())).thenAnswer((_) async => const Right(1));
    when(() => onboardingService.markCompleted()).thenReturn(null);
    stubAccounts([]);
  });

  OnboardingCubit build() => OnboardingCubit(
    getProgress: getProgress,
    setStep: setStep,
    markQuickStartSelected: markQuickStartSelected,
    completeOnboarding: completeOnboarding,
    getAccounts: getAccounts,
    saveAccount: saveAccount,
    onboardingService: onboardingService,
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'load resumes the persisted step with the already-created accounts',
    setUp: () {
      when(() => getProgress(any())).thenAnswer(
        (_) async =>
            const Right(OnboardingProgress(step: OnboardingStep.accounts)),
      );
      stubAccounts([bca]);
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      OnboardingState(step: OnboardingStep.accounts, accounts: [bca]),
    ],
  );

  // A first run must not open with a failure toast.
  blocTest<OnboardingCubit, OnboardingState>(
    'load on a Left keeps the defaults and surfaces no failure',
    setUp: () {
      when(
        () => getProgress(any()),
      ).thenAnswer((_) async => const Left(CacheFailure()));
      when(
        () => getAccounts(any()),
      ).thenAnswer((_) async => const Left(CacheFailure()));
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [OnboardingState()],
    verify: (cubit) => expect(cubit.state.status, OnboardingStatus.editing),
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'next advances welcome → value and persists the step',
    build: build,
    act: (cubit) => cubit.next(),
    expect: () => const [OnboardingState(step: OnboardingStep.value)],
    verify: (_) => verify(() => setStep(OnboardingStep.value)).called(1),
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'next at Account Setup with no accounts does NOT advance',
    build: build,
    seed: () => const OnboardingState(step: OnboardingStep.accounts),
    act: (cubit) => cubit.next(),
    expect: () => const <OnboardingState>[],
    verify: (_) => verifyNever(() => setStep(any())),
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'next at Account Setup with an account advances to the summary',
    build: build,
    seed: () =>
        const OnboardingState(step: OnboardingStep.accounts, accounts: [bca]),
    act: (cubit) => cubit.next(),
    expect: () => const [
      OnboardingState(step: OnboardingStep.summary, accounts: [bca]),
    ],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'back on Welcome is a no-op (§14 — Back is hidden there)',
    build: build,
    act: (cubit) => cubit.back(),
    expect: () => const <OnboardingState>[],
    verify: (_) => verifyNever(() => setStep(any())),
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'back steps to the previous step and persists it',
    build: build,
    seed: () => const OnboardingState(step: OnboardingStep.accounts),
    act: (cubit) => cubit.back(),
    expect: () => const [OnboardingState(step: OnboardingStep.value)],
    verify: (_) => verify(() => setStep(OnboardingStep.value)).called(1),
  );

  group('quickStart', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'writes exactly one Cash account at Rp0 and jumps to the summary',
      // The reload after the save sees the new row.
      setUp: () => stubAccounts([cash]),
      build: build,
      seed: () => const OnboardingState(step: OnboardingStep.accounts),
      act: (cubit) => cubit.quickStart(),
      expect: () => const [
        OnboardingState(
          step: OnboardingStep.accounts,
          status: OnboardingStatus.submitting,
        ),
        OnboardingState(step: OnboardingStep.summary, accounts: [cash]),
      ],
      verify: (_) {
        final saved =
            verify(() => saveAccount(captureAny())).captured.single as Account;
        expect(saved.name, 'Cash');
        expect(saved.type, AccountType.cash);
        expect(saved.openingBalance, 0);
        expect(saved.icon, 'wallet');
        verify(() => markQuickStartSelected(any())).called(1);
        verify(() => setStep(OnboardingStep.summary)).called(1);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'a failed write surfaces the failure and leaves the step alone',
      setUp: () => when(
        () => saveAccount(any()),
      ).thenAnswer((_) async => const Left(CacheFailure())),
      build: build,
      seed: () => const OnboardingState(step: OnboardingStep.accounts),
      act: (cubit) => cubit.quickStart(),
      expect: () => const [
        OnboardingState(
          step: OnboardingStep.accounts,
          status: OnboardingStatus.submitting,
        ),
        OnboardingState(
          step: OnboardingStep.accounts,
          status: OnboardingStatus.failure,
          error: CacheFailure(),
        ),
      ],
      verify: (_) => verifyNever(() => markQuickStartSelected(any())),
    );

    // The double-tap guard: a slow disk write must not produce two accounts.
    blocTest<OnboardingCubit, OnboardingState>(
      'is inert while a write is already in flight',
      build: build,
      seed: () => const OnboardingState(
        step: OnboardingStep.accounts,
        status: OnboardingStatus.submitting,
      ),
      act: (cubit) => cubit.quickStart(),
      expect: () => const <OnboardingState>[],
      verify: (_) => verifyNever(() => saveAccount(any())),
    );
  });

  group('accountSaved', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'reloads and raises the hint when the new name collides (§18)',
      setUp: () => stubAccounts([
        bca,
        // Same name, different case + padding — still a collision.
        const Account(id: 3, name: ' bca ', type: AccountType.ewallet),
      ]),
      build: build,
      seed: () =>
          const OnboardingState(step: OnboardingStep.accounts, accounts: [bca]),
      act: (cubit) => cubit.accountSaved(),
      verify: (cubit) {
        expect(cubit.state.duplicateName, ' bca ');
        expect(cubit.state.accounts, hasLength(2));
        // A hint only — never a blocker; the save already happened.
        expect(cubit.state.status, OnboardingStatus.editing);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'leaves the hint null for a unique name',
      setUp: () => stubAccounts([bca, cash]),
      build: build,
      seed: () =>
          const OnboardingState(step: OnboardingStep.accounts, accounts: [bca]),
      act: (cubit) => cubit.accountSaved(),
      verify: (cubit) {
        expect(cubit.state.duplicateName, isNull);
        expect(cubit.state.accounts, hasLength(2));
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'clearDuplicateHint consumes the one-shot hint',
      build: build,
      seed: () => const OnboardingState(
        step: OnboardingStep.accounts,
        accounts: [bca],
        duplicateName: 'BCA',
      ),
      act: (cubit) => cubit.clearDuplicateHint(),
      verify: (cubit) => expect(cubit.state.duplicateName, isNull),
    );
  });

  group('complete', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'persists, emits completed, THEN releases the gate',
      build: build,
      seed: () =>
          const OnboardingState(step: OnboardingStep.summary, accounts: [cash]),
      act: (cubit) => cubit.complete(),
      expect: () => const [
        OnboardingState(
          step: OnboardingStep.summary,
          accounts: [cash],
          status: OnboardingStatus.submitting,
        ),
        OnboardingState(
          step: OnboardingStep.summary,
          accounts: [cash],
          status: OnboardingStatus.completed,
        ),
      ],
      verify: (_) {
        // Order matters: markCompleted triggers the redirect that disposes this
        // route, so the completed state must already be emitted.
        verifyInOrder([
          () => completeOnboarding(any()),
          () => onboardingService.markCompleted(),
        ]);
        // verifyInOrder consumed exactly one markCompleted; a second would
        // remain unverified and fail here.
        verifyNoMoreInteractions(onboardingService);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'a failed write never releases the gate',
      setUp: () => when(
        () => completeOnboarding(any()),
      ).thenAnswer((_) async => const Left(CacheFailure())),
      build: build,
      seed: () => const OnboardingState(step: OnboardingStep.summary),
      act: (cubit) => cubit.complete(),
      expect: () => const [
        OnboardingState(
          step: OnboardingStep.summary,
          status: OnboardingStatus.submitting,
        ),
        OnboardingState(
          step: OnboardingStep.summary,
          status: OnboardingStatus.failure,
          error: CacheFailure(),
        ),
      ],
      verify: (_) => verifyNever(() => onboardingService.markCompleted()),
    );
  });

  group('derived state', () {
    test('totalOpeningBalance sums the created accounts', () {
      const state = OnboardingState(accounts: [bca, cash]);

      expect(state.totalOpeningBalance, 4500000);
      expect(state.accountCount, 2);
    });

    test('canContinue gates ONLY the Account Setup step', () {
      for (final step in OnboardingStep.values) {
        expect(
          OnboardingState(step: step).canContinue,
          step != OnboardingStep.accounts,
          reason: '$step with no accounts',
        );
        expect(
          OnboardingState(step: step, accounts: const [bca]).canContinue,
          isTrue,
          reason: '$step with an account',
        );
      }
    });
  });
}
