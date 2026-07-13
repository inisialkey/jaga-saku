import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/features/settings/pages/settings_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/pump_app.dart';

/// [SettingsPage] over a real [AppSettingsCubit] (mocked store): the language
/// selector and the name editor both read + write the cubit.
void main() {
  late MockSettingsService settings;
  late MockTxChangeNotifier txChanges;
  late AppSettingsCubit cubit;

  setUp(() {
    settings = MockSettingsService();
    txChanges = MockTxChangeNotifier();
    when(() => settings.getString(any())).thenAnswer((_) async => null);
    when(() => settings.setString(any(), any())).thenAnswer((_) async {});
    // Default (unloaded) state → System locale, no name, start-day 1.
    cubit = AppSettingsCubit(settings, txChanges);
  });

  tearDown(() => cubit.close());

  Future<void> pump(WidgetTester tester) => pumpApp(
    tester,
    BlocProvider.value(value: cubit, child: const SettingsPage()),
    scaffold: false,
  );

  testWidgets('shows language options (System ticked) and a name field', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('System'), findsOneWidget);
    expect(find.text('Indonesia'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    // Default locale null (System) → exactly one option ticked.
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('tapping English selects and persists the en locale', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(cubit.state.locale, const Locale('en'));
    verify(() => settings.setString('locale', 'en')).called(1);
  });

  testWidgets('persists the name on focus loss, not per keystroke', (
    tester,
  ) async {
    await pump(tester);

    await tester.enterText(find.byType(TextField), 'Budi');
    await tester.pump();
    // Typing must not persist — no sqflite write per keystroke (W1).
    verifyNever(() => settings.setString('user_name', any()));

    // Blurring the field commits the edit once.
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    expect(cubit.state.userName, 'Budi');
    verify(() => settings.setString('user_name', 'Budi')).called(1);
  });

  testWidgets('committing with the keyboard "done" action persists the name', (
    tester,
  ) async {
    await pump(tester);

    await tester.enterText(find.byType(TextField), 'Budi');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(cubit.state.userName, 'Budi');
    verify(() => settings.setString('user_name', 'Budi')).called(1);
  });

  // ── Budget cycle start-day (V2-M1) ──────────────────────────────────────────

  testWidgets('shows the budget cycle row labelled "Monthly calendar" at 1', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('Budget Cycle'), findsOneWidget);
    // Default start-day 1 → the row reads the monthly-calendar label.
    expect(find.text('Monthly calendar'), findsOneWidget);
  });

  testWidgets('picking a start day persists it and pings the tx bus', (
    tester,
  ) async {
    await pump(tester);

    // Tapping the row opens the picker; choose a day near the top of the sheet.
    await tester.tap(find.text('Monthly calendar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Day 3'));
    await tester.pumpAndSettle();

    expect(cubit.state.budgetCycleStartDay, 3);
    verify(() => settings.setString('budget_cycle_start_day', '3')).called(1);
    // A cycle-window change is a derived-money-view change (plan §5).
    verify(() => txChanges.ping()).called(1);
  });
}
