import 'package:jaga_saku/app_router.dart';

/// The pure lock-gate redirect (V3-M4) — the highest-risk surface, deliberately
/// kept off the widget tree so it is exhaustively truth-table tested in
/// isolation (§8). Given the current lock state + [location], returns the
/// redirect target, or `null` to pass through.
///
/// Wired on `appRouter` as `redirect:` with `refreshListenable:` on the
/// `AppLockService`, so every lock/unlock `notifyListeners()` re-runs it.
String? lockRedirect({
  required bool isPinEnabled,
  required bool isLocked,
  required String location,
}) {
  // Gate OFF (fresh install / no PIN) — never touch navigation.
  if (!isPinEnabled) return null;
  final atLock = location == AppRoute.lock;
  // Locked and anywhere but the lock screen → send to the lock screen.
  if (isLocked && !atLock) return AppRoute.lock;
  // Unlocked but stranded on the lock screen → back to home.
  if (!isLocked && atLock) return AppRoute.home;
  return null;
}
