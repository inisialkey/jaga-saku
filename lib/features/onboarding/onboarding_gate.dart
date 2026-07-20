import 'package:jaga_saku/app_router.dart';

/// Locations that stay reachable while onboarding is INCOMPLETE:
///
/// * [AppRoute.onboarding] — the flow itself.
/// * [AppRoute.accountForm] — the Account Setup step pushes the real account
///   form (`account_list_page.dart:160` is the same call). Without this the
///   push would be redirected straight back to `/onboarding` and the step could
///   never create an account.
/// * [AppRoute.lock] — the app lock OUTRANKS onboarding. `lockRedirect` returns
///   null once the user is already on `/lock`, so without this entry the
///   onboarding gate would bounce a locked user off the lock screen and strand
///   them in a redirect fight. Reachable via a V3-M1 restore that brings in a
///   PIN-enabled settings row.
const Set<String> _onboardingPassThrough = {
  AppRoute.onboarding,
  AppRoute.accountForm,
  AppRoute.lock,
};

/// The pure onboarding-gate redirect (V5-M1) — kept off the widget tree so it
/// is exhaustively truth-table tested in isolation, exactly like `lockRedirect`.
///
/// Composed in `appRouter` as `lockRedirect(...) ?? onboardingRedirect(...)`:
/// the lock always wins, so a PIN-enabled user never skips the lock screen.
String? onboardingRedirect({
  required bool isCompleted,
  required String location,
}) {
  if (isCompleted) {
    // Onboarding is unreachable once done (AC#13) — including a stale deep
    // link or a back-stack entry.
    return location == AppRoute.onboarding ? AppRoute.home : null;
  }
  if (_onboardingPassThrough.contains(location)) return null;
  return AppRoute.onboarding;
}
