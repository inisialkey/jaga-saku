import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/features/reminders/data/reminder_routes.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_type.dart';

/// [routeForReminderPayload]: each `ReminderType.name` payload → its deep-link
/// target; null / unknown → Home. Keyed off `ReminderType.name` so a rename of
/// the enum breaks this test (the payload contract stays in sync).
void main() {
  test('dailyCheckIn payload → add', () {
    expect(
      routeForReminderPayload(ReminderType.dailyCheckIn.name),
      AppRoute.add,
    );
  });

  test('recurringDue payload → recurring review', () {
    expect(
      routeForReminderPayload(ReminderType.recurringDue.name),
      AppRoute.recurringReview,
    );
  });

  test('budgetWarning payload → budget', () {
    expect(
      routeForReminderPayload(ReminderType.budgetWarning.name),
      AppRoute.budget,
    );
  });

  test('null payload → home', () {
    expect(routeForReminderPayload(null), AppRoute.home);
  });

  test('unknown payload → home', () {
    expect(routeForReminderPayload('garbage'), AppRoute.home);
  });
}
