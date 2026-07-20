import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/onboarding/onboarding_service.dart';
import 'package:jaga_saku/features/security/app_lock_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

/// The composed gate as PRODUCTION wires it — `appRouter`'s own `redirect`
/// (`app_router.dart:149-158`), not a copy of the expression.
///
/// `onboarding_gate_test.dart` truth-tables `onboardingRedirect` alone and
/// `lock_gate_test.dart` truth-tables `lockRedirect` alone; both then re-declare
/// the `lockRedirect(...) ?? onboardingRedirect(...)` composition as a LOCAL
/// closure. That copy cannot detect drift: flipping the real `??` operands would
/// leave every one of those tests green while a PIN-enabled user skipped the
/// lock screen. These tests drive the real router instead, so the ordering is
/// pinned where it actually lives.
///
/// They also pin the second, wholly untested claim the review reasoned about
/// rather than proved: that go_router applies the top-level redirect to an
/// arbitrary INITIAL location, which is what makes the `jagasaku://` deep-link
/// scheme (`AndroidManifest.xml:64-69`, `Info.plist:32-35`) safe. The backup
/// restore path writes the onboarding marker unconditionally
/// (`backup_local_datasource.dart:102`) and is only honest if no
/// not-yet-onboarded user can reach `/backup-restore` at all.
void main() {
  late MockAppLockService appLock;
  late MockOnboardingService onboarding;

  // `appRouter` is a lazy top-level final: its merged `refreshListenable` binds
  // whichever instances are registered the first time it is touched, so the
  // singletons are registered ONCE and only their stubs move per test.
  setUpAll(() {
    appLock = MockAppLockService();
    onboarding = MockOnboardingService();
    sl
      ..registerSingleton<AppLockService>(appLock)
      ..registerSingleton<OnboardingService>(onboarding);
  });

  tearDownAll(sl.reset);

  setUp(() {
    reset(appLock);
    reset(onboarding);
  });

  void given({
    required bool isCompleted,
    bool isPinEnabled = false,
    bool isLocked = false,
  }) {
    when(() => appLock.isPinEnabled).thenReturn(isPinEnabled);
    when(() => appLock.isLocked).thenReturn(isLocked);
    when(() => onboarding.isCompleted).thenReturn(isCompleted);
  }

  /// Resolves [location] through the real router's parser, which runs the
  /// top-level `redirect` exactly as a cold start or a deep link does, and
  /// returns the location actually landed on. No page is ever built — route
  /// builders are not invoked by parsing — so this needs no wider DI graph.
  Future<String> resolve(WidgetTester tester, String location) async {
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    final match = await appRouter.routeInformationParser
        .parseRouteInformationWithDependencies(
          RouteInformation(uri: Uri.parse(location)),
          tester.element(find.byType(SizedBox)),
        );
    return match.uri.toString();
  }

  group('gate precedence — the real `??` in app_router.dart', () {
    // The ONE cell that distinguishes the two operand orders. Reversed, this
    // returns /onboarding and a PIN-enabled user walks straight past the lock.
    testWidgets('locked + incomplete → /lock, never /onboarding', (
      tester,
    ) async {
      given(isPinEnabled: true, isLocked: true, isCompleted: false);

      expect(await resolve(tester, AppRoute.home), AppRoute.lock);
    });

    // The strand-the-user case: onboarding must not bounce a locked user back
    // off the lock screen it just sent them to.
    testWidgets('locked + incomplete + already on /lock → stays', (
      tester,
    ) async {
      given(isPinEnabled: true, isLocked: true, isCompleted: false);

      expect(await resolve(tester, AppRoute.lock), AppRoute.lock);
    });

    testWidgets('unlocked + incomplete → the onboarding gate decides', (
      tester,
    ) async {
      given(isPinEnabled: true, isCompleted: false);

      expect(await resolve(tester, AppRoute.home), AppRoute.onboarding);
    });

    testWidgets('no PIN + complete → no redirect at all', (tester) async {
      given(isCompleted: true);

      expect(await resolve(tester, AppRoute.home), AppRoute.home);
    });

    // AC#13, through the real router: the flow cannot be reopened once done.
    testWidgets('complete + /onboarding → /home', (tester) async {
      given(isCompleted: true);

      expect(await resolve(tester, AppRoute.onboarding), AppRoute.home);
    });
  });

  group('deep links (jagasaku://) are gated like any other location', () {
    // The review REASONED this was safe but never proved it. It is what makes
    // `BackupLocalDatasource.restore` re-applying the onboarding marker
    // unconditionally an honest assumption rather than a lie: an incomplete
    // user cannot reach the restore screen by any route, deep link included.
    testWidgets('incomplete + /backup-restore → /onboarding', (tester) async {
      given(isCompleted: false);

      expect(
        await resolve(tester, AppRoute.backupRestore),
        AppRoute.onboarding,
      );
    });

    testWidgets('complete + /backup-restore → reachable', (tester) async {
      given(isCompleted: true);

      expect(
        await resolve(tester, AppRoute.backupRestore),
        AppRoute.backupRestore,
      );
    });

    // The pass-through the Account Setup step depends on: without it the push
    // is redirected back to /onboarding and no account can ever be created.
    testWidgets('incomplete + /accounts/form stays reachable', (tester) async {
      given(isCompleted: false);

      expect(await resolve(tester, AppRoute.accountForm), AppRoute.accountForm);
    });
  });
}
