import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:jaga_saku/features/onboarding/pages/onboarding_cubit.dart';
import 'package:jaga_saku/features/onboarding/pages/onboarding_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

/// [OnboardingPage] over a REAL [OnboardingCubit] backed by mocked usecases —
/// the repo's page-test shape (`home_page_test.dart`, `account_form_page_test`).
///
/// The page owns EVERY CTA decision (label, enablement, which control spins,
/// which cubit method fires), and none of it was covered: the dark smoke test
/// pumps the four step widgets standalone, never the page. That gap is exactly
/// how the dead "Add Account" button shipped, so these tests pin the CTA block
/// specifically.
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

  /// Marker on the stub account-form route — visible only once the page has
  /// actually pushed it. Tapping it pops `true`, which is exactly what the real
  /// form does on a successful save (`account_form_page.dart:47`).
  const accountFormMarker = Key('accountFormRoute');

  /// Whatever the page handed the form as `extra` on the most recent push.
  Account? pushedPrefill;

  setUp(() {
    pushedPrefill = null;
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
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Account>>([]));
  });

  OnboardingCubit buildCubit() => OnboardingCubit(
    getProgress: getProgress,
    setStep: setStep,
    markQuickStartSelected: markQuickStartSelected,
    completeOnboarding: completeOnboarding,
    getAccounts: getAccounts,
    saveAccount: saveAccount,
    onboardingService: onboardingService,
  );

  /// Builds a cubit already resumed at [step] with [accounts], then pumps the
  /// page on a real go_router stack (the page pushes `AppRoute.accountForm`, so
  /// a plain `MaterialApp` would not do).
  ///
  /// `load()` runs BEFORE the pump so `PageController.initialPage` is already
  /// the right page — no settle race on the resume animation.
  Future<OnboardingCubit> pumpAt(
    WidgetTester tester, {
    OnboardingStep step = OnboardingStep.welcome,
    List<Account> accounts = const [],
  }) async {
    when(
      () => getProgress(any()),
    ).thenAnswer((_) async => Right(OnboardingProgress(step: step)));
    when(
      () => getAccounts(any()),
    ).thenAnswer((_) async => Right<Failure, List<Account>>(accounts));

    final cubit = buildCubit();
    addTearDown(cubit.close);
    await cubit.load();

    final router = GoRouter(
      initialLocation: AppRoute.onboarding,
      routes: [
        GoRoute(
          path: AppRoute.onboarding,
          builder: (_, _) =>
              BlocProvider.value(value: cubit, child: const OnboardingPage()),
        ),
        GoRoute(
          path: AppRoute.accountForm,
          builder: (context, state) {
            pushedPrefill = state.extra as Account?;
            return Scaffold(
              body: TextButton(
                key: accountFormMarker,
                onPressed: () => context.pop(true),
                child: const Text('form'),
              ),
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, _) => MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          localizationsDelegates: Strings.localizationsDelegates,
          supportedLocales: Strings.supportedLocales,
          theme: AppTheme.light,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return cubit;
  }

  PrimaryButton primary(WidgetTester tester) =>
      tester.widget<PrimaryButton>(find.byType(PrimaryButton));

  TextButtonX secondary(WidgetTester tester) =>
      tester.widget<TextButtonX>(find.byType(TextButtonX));

  Finder spinnerIn(Type button) => find.descendant(
    of: find.byType(button),
    matching: find.byType(CircularProgressIndicator),
  );

  group('Account Setup CTA', () {
    // THE C1 regression. `canContinue` is the *advance* gate and is false here;
    // binding it to `onPressed` made the one route to a blank account form
    // untappable, leaving any name outside the 9 suggestion chips unreachable.
    testWidgets('empty: the primary reads "Add Account" and is TAPPABLE', (
      tester,
    ) async {
      await pumpAt(tester, step: OnboardingStep.accounts);

      expect(find.text('Add Account'), findsOneWidget);
      expect(primary(tester).onPressed, isNotNull);
      expect(primary(tester).isLoading, isFalse);

      // Tappable in substance, not just in shape: it reaches the real form.
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();
      expect(find.byKey(accountFormMarker), findsOneWidget);
    });

    testWidgets('populated: the primary flips to "Continue" and advances', (
      tester,
    ) async {
      final cubit = await pumpAt(
        tester,
        step: OnboardingStep.accounts,
        accounts: const [bca],
      );

      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Add Account'), findsNothing);

      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();
      expect(cubit.state.step, OnboardingStep.summary);
    });

    testWidgets('empty: the secondary is Quick Start, never "Skip" (§20)', (
      tester,
    ) async {
      await pumpAt(tester, step: OnboardingStep.accounts);

      expect(find.text('Quick Start'), findsOneWidget);
      expect(find.text('Skip'), findsNothing);
    });

    testWidgets('populated: the secondary becomes Add Another Account', (
      tester,
    ) async {
      await pumpAt(
        tester,
        step: OnboardingStep.accounts,
        accounts: const [bca],
      );

      expect(find.text('Add Another Account'), findsOneWidget);

      await tester.tap(find.byType(TextButtonX));
      await tester.pumpAndSettle();
      expect(find.byKey(accountFormMarker), findsOneWidget);
    });
  });

  group('busy state lands on the tapped control', () {
    // THE W2 regression. Quick Start is the SECONDARY; the spinner used to
    // render on the (disabled) primary — a button the user never touched.
    testWidgets('Quick Start spins the secondary, not the primary', (
      tester,
    ) async {
      final gate = Completer<Either<Failure, int>>();
      when(() => saveAccount(any())).thenAnswer((_) => gate.future);
      await pumpAt(tester, step: OnboardingStep.accounts);

      await tester.tap(find.byType(TextButtonX));
      await tester.pump();

      // The spinner is on the tapped control...
      expect(spinnerIn(TextButtonX), findsOneWidget);
      expect(spinnerIn(PrimaryButton), findsNothing);
      expect(primary(tester).isLoading, isFalse);
      // ...and neither control can be tapped while the write is in flight.
      expect(primary(tester).onPressed, isNull);
      expect(secondary(tester).onPressed, isNull);

      // A second tap during the write must not queue a second account.
      await tester.tap(find.byType(TextButtonX));
      await tester.pump();
      verify(() => saveAccount(any())).called(1);

      gate.complete(const Right(1));
      await tester.pumpAndSettle();
      expect(spinnerIn(TextButtonX), findsNothing);
    });

    // The mirror case: on the summary the PRIMARY is the writer, so the
    // spinner belongs there.
    testWidgets('Start Tracking spins the primary', (tester) async {
      final gate = Completer<Either<Failure, Unit>>();
      when(() => completeOnboarding(any())).thenAnswer((_) => gate.future);
      await pumpAt(tester, step: OnboardingStep.summary);

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      expect(spinnerIn(PrimaryButton), findsOneWidget);
      expect(primary(tester).onPressed, isNull);
      // The summary has no secondary at all.
      expect(find.byType(TextButtonX), findsNothing);

      gate.complete(const Right(unit));
      await tester.pumpAndSettle();
      verify(() => onboardingService.markCompleted()).called(1);
    });
  });

  group('CTA dispatch per step', () {
    testWidgets('welcome: Get Started advances, and there is no secondary', (
      tester,
    ) async {
      final cubit = await pumpAt(tester);

      expect(find.text('Get Started'), findsOneWidget);
      expect(find.byType(TextButtonX), findsNothing);

      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();
      expect(cubit.state.step, OnboardingStep.value);
      verify(() => setStep(OnboardingStep.value)).called(1);
    });

    testWidgets('value: Continue advances', (tester) async {
      final cubit = await pumpAt(tester, step: OnboardingStep.value);

      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();
      expect(cubit.state.step, OnboardingStep.accounts);
    });

    // Currency Setup is out of scope (Q2), so Skip resolves to the next
    // REMAINING step — Account Setup, same as Continue.
    testWidgets('value: Skip also advances to Account Setup', (tester) async {
      final cubit = await pumpAt(tester, step: OnboardingStep.value);

      expect(find.text('Skip'), findsOneWidget);
      await tester.tap(find.byType(TextButtonX));
      await tester.pumpAndSettle();
      expect(cubit.state.step, OnboardingStep.accounts);
    });

    testWidgets('summary: Start Tracking completes and releases the gate', (
      tester,
    ) async {
      await pumpAt(tester, step: OnboardingStep.summary);

      expect(find.text('Start Tracking'), findsOneWidget);
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      verify(() => completeOnboarding(any())).called(1);
      verify(() => onboardingService.markCompleted()).called(1);
    });

    // §14: Back on every step except Welcome.
    testWidgets('back is hidden on Welcome', (tester) async {
      await pumpAt(tester);

      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('back steps to the previous step elsewhere', (tester) async {
      final cubit = await pumpAt(tester, step: OnboardingStep.accounts);

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(cubit.state.step, OnboardingStep.value);
    });
  });

  // The PopScope block, distinct from the back ARROW above: the arrow is an
  // IconButton, this is the OS gesture / hardware key. `canPop: false` means
  // the flow can never be escaped — on Welcome there is nowhere back to go, so
  // the app must simply stay put rather than dropping the user somewhere the
  // onboarding gate would only redirect them away from again.
  group('system back (§14 — no way out of onboarding)', () {
    testWidgets('steps back instead of leaving the flow', (tester) async {
      final cubit = await pumpAt(tester, step: OnboardingStep.summary);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(cubit.state.step, OnboardingStep.accounts);
      expect(find.byType(OnboardingPage), findsOneWidget);
    });

    testWidgets('on Welcome it is inert — the page stays', (tester) async {
      final cubit = await pumpAt(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(cubit.state.step, OnboardingStep.welcome);
      expect(find.byType(OnboardingPage), findsOneWidget);
    });
  });

  group('suggestion chip → prefilled form', () {
    // The chip is the step's whole drop-off mitigation, and the prefill it
    // builds is what the `isEditing: initial.id != null` root-cause fix exists
    // for: an id-less Account must open the form as ADD (no "Edit Account"
    // title, no dead Reconcile row). Nothing asserted that the page actually
    // hands the form an id-less, fully-seeded prefill.
    testWidgets('pushes the form with an id-less, seeded prefill', (
      tester,
    ) async {
      await pumpAt(tester, step: OnboardingStep.accounts);

      await tester.tap(find.text('BCA'));
      await tester.pumpAndSettle();

      expect(find.byKey(accountFormMarker), findsOneWidget);
      expect(pushedPrefill?.name, 'BCA');
      expect(pushedPrefill?.type, AccountType.bank);
      expect(pushedPrefill?.icon, 'bank');
      // The load-bearing bit: no id, so the form opens in ADD mode.
      expect(pushedPrefill?.id, isNull);
    });

    testWidgets('the blank-form primary pushes NO prefill', (tester) async {
      await pumpAt(tester, step: OnboardingStep.accounts);

      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(pushedPrefill, isNull);
    });

    // `if (saved ?? false) await cubit.accountSaved()` — the wiring that makes
    // the step's list grow. A form that pops anything but `true` must not
    // trigger a reload.
    testWidgets('a form that pops true reloads the accounts', (tester) async {
      final cubit = await pumpAt(tester, step: OnboardingStep.accounts);

      await tester.tap(find.text('BCA'));
      await tester.pumpAndSettle();

      // The save landed while the form was open.
      when(
        () => getAccounts(any()),
      ).thenAnswer((_) async => const Right<Failure, List<Account>>([bca]));
      await tester.tap(find.byKey(accountFormMarker));
      await tester.pumpAndSettle();

      expect(cubit.state.accounts, const [bca]);
      // Back on the step, now in its populated shape.
      expect(find.text('Continue'), findsOneWidget);
    });

    // §18: the duplicate hint is a ONE-SHOT. If the listener raised the toast
    // without consuming the hint, every subsequent rebuild would re-raise it.
    testWidgets('a colliding name raises the hint and consumes it', (
      tester,
    ) async {
      final cubit = await pumpAt(
        tester,
        step: OnboardingStep.accounts,
        accounts: const [bca],
      );

      await tester.tap(find.byType(TextButtonX));
      await tester.pumpAndSettle();

      when(() => getAccounts(any())).thenAnswer(
        (_) async => const Right<Failure, List<Account>>([
          bca,
          Account(id: 2, name: 'bca', type: AccountType.ewallet),
        ]),
      );
      await tester.tap(find.byKey(accountFormMarker));
      await tester.pumpAndSettle();

      expect(cubit.state.accounts, hasLength(2));
      // Raised, then cleared by the page's listener — never a sticky flag.
      expect(cubit.state.duplicateName, isNull);
      // A hint only: the save stands and the step is not blocked.
      expect(cubit.state.status, OnboardingStatus.editing);
    });
  });
}
