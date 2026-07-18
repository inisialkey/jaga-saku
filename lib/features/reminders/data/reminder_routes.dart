import 'package:jaga_saku/app_router.dart';

/// Maps a delivered notification payload — the `ReminderType.name` string set as
/// the notification payload — to its deep-link target. Pure (no plugin / `tz`):
/// the tap callback in `ReminderService` feeds the result to `appRouter.go(...)`
/// so go_router owns navigation (rule 9). A null / unknown payload falls back to
/// Home, so a stale tap is never a dead end.
String routeForReminderPayload(String? payload) => switch (payload) {
  'dailyCheckIn' => AppRoute.add,
  'recurringDue' => AppRoute.recurringReview,
  'budgetWarning' => AppRoute.budget,
  _ => AppRoute.home,
};
