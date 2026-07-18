import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/features/security/lock_gate.dart';

/// The redirect truth table — the highest-risk surface, proven in isolation so a
/// wrong branch can never strand a user on `/lock` or bypass the gate.
void main() {
  test(
    'gate OFF (no PIN) never redirects — a fresh install is never gated',
    () {
      expect(
        lockRedirect(
          isPinEnabled: false,
          isLocked: false,
          location: AppRoute.home,
        ),
        isNull,
      );
      expect(
        lockRedirect(
          isPinEnabled: false,
          isLocked: true,
          location: AppRoute.home,
        ),
        isNull,
      );
      expect(
        lockRedirect(
          isPinEnabled: false,
          isLocked: true,
          location: AppRoute.lock,
        ),
        isNull,
      );
    },
  );

  test('locked + not on the lock screen → redirect to lock', () {
    expect(
      lockRedirect(isPinEnabled: true, isLocked: true, location: AppRoute.home),
      AppRoute.lock,
    );
    expect(
      lockRedirect(
        isPinEnabled: true,
        isLocked: true,
        location: AppRoute.calendar,
      ),
      AppRoute.lock,
    );
  });

  test('locked + already on the lock screen → pass through', () {
    expect(
      lockRedirect(isPinEnabled: true, isLocked: true, location: AppRoute.lock),
      isNull,
    );
  });

  test('unlocked + stranded on the lock screen → home', () {
    expect(
      lockRedirect(
        isPinEnabled: true,
        isLocked: false,
        location: AppRoute.lock,
      ),
      AppRoute.home,
    );
  });

  test('unlocked + a normal route → pass through', () {
    expect(
      lockRedirect(
        isPinEnabled: true,
        isLocked: false,
        location: AppRoute.calendar,
      ),
      isNull,
    );
    expect(
      lockRedirect(
        isPinEnabled: true,
        isLocked: false,
        location: AppRoute.home,
      ),
      isNull,
    );
  });
}
