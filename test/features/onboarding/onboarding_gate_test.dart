import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/features/onboarding/onboarding_gate.dart';
import 'package:jaga_saku/features/security/lock_gate.dart';

/// The onboarding redirect truth table plus the composition with the V3-M4 lock
/// gate — proven in isolation so a wrong branch can never strand a user on
/// `/onboarding` or let one skip it.
void main() {
  group('onboardingRedirect — incomplete', () {
    test('gates every ordinary route to /onboarding', () {
      for (final location in [AppRoute.home, AppRoute.calendar, AppRoute.add]) {
        expect(
          onboardingRedirect(isCompleted: false, location: location),
          AppRoute.onboarding,
          reason: '$location should be gated',
        );
      }
    });

    test('passes through the flow itself', () {
      expect(
        onboardingRedirect(isCompleted: false, location: AppRoute.onboarding),
        isNull,
      );
    });

    test('passes through the account form the Account Setup step pushes', () {
      expect(
        onboardingRedirect(isCompleted: false, location: AppRoute.accountForm),
        isNull,
      );
    });

    // Without this the onboarding gate would bounce a locked user off /lock and
    // strand them in a redirect fight with lockRedirect.
    test('passes through /lock — the lock outranks onboarding', () {
      expect(
        onboardingRedirect(isCompleted: false, location: AppRoute.lock),
        isNull,
      );
    });
  });

  group('onboardingRedirect — complete', () {
    test('never gates an ordinary route', () {
      for (final location in [
        AppRoute.home,
        AppRoute.accountForm,
        AppRoute.lock,
      ]) {
        expect(
          onboardingRedirect(isCompleted: true, location: location),
          isNull,
          reason: '$location should pass through',
        );
      }
    });

    // AC#13 — a stale deep link or back-stack entry can't reopen the flow.
    test('/onboarding becomes unreachable and maps to /home', () {
      expect(
        onboardingRedirect(isCompleted: true, location: AppRoute.onboarding),
        AppRoute.home,
      );
    });
  });

  group('composition — the exact expression in app_router.dart', () {
    String? redirect({
      required bool isPinEnabled,
      required bool isLocked,
      required bool isCompleted,
      required String location,
    }) =>
        lockRedirect(
          isPinEnabled: isPinEnabled,
          isLocked: isLocked,
          location: location,
        ) ??
        onboardingRedirect(isCompleted: isCompleted, location: location);

    test('locked + incomplete → /lock (the lock wins)', () {
      expect(
        redirect(
          isPinEnabled: true,
          isLocked: true,
          isCompleted: false,
          location: AppRoute.home,
        ),
        AppRoute.lock,
      );
    });

    // The strand-the-user regression: onboarding must not bounce a locked user
    // off the lock screen.
    test('locked + incomplete + already on /lock → pass through', () {
      expect(
        redirect(
          isPinEnabled: true,
          isLocked: true,
          isCompleted: false,
          location: AppRoute.lock,
        ),
        isNull,
      );
    });

    test('unlocked + incomplete → /onboarding', () {
      expect(
        redirect(
          isPinEnabled: true,
          isLocked: false,
          isCompleted: false,
          location: AppRoute.home,
        ),
        AppRoute.onboarding,
      );
    });

    test('no PIN + complete → never redirects', () {
      expect(
        redirect(
          isPinEnabled: false,
          isLocked: false,
          isCompleted: true,
          location: AppRoute.home,
        ),
        isNull,
      );
    });
  });
}
