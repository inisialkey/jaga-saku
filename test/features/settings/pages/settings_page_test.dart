import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/settings/pages/settings_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/pump_app.dart';

/// [SettingsPage] over a real [AppSettingsCubit] (mocked store): the language
/// selector and the name editor both read + write the cubit.
void main() {
  late MockSettingsService settings;
  late AppSettingsCubit cubit;

  setUp(() {
    settings = MockSettingsService();
    when(() => settings.getString(any())).thenAnswer((_) async => null);
    when(() => settings.setString(any(), any())).thenAnswer((_) async {});
    // Default (unloaded) state → System locale, no name, start-day 1.
    cubit = AppSettingsCubit(settings);
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

  testWidgets('picking a start day persists it', (tester) async {
    await pump(tester);

    // Tapping the row opens the picker; choose a day near the top of the sheet.
    await tester.tap(find.text('Monthly calendar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Day 3'));
    await tester.pumpAndSettle();

    expect(cubit.state.budgetCycleStartDay, 3);
    verify(() => settings.setString('budget_cycle_start_day', '3')).called(1);
  });

  testWidgets('the start-day picker opens scrolled to the selected day '
      '(on-screen) at 1.3× Dynamic Type', (tester) async {
    // W1 regression guard: at 1.3× rows render at scale(48) ≈ 62px, so a scroll
    // offset computed from the BASE 48px extent scrolls a HIGH selected day
    // fully off-screen. Seed day 28 and assert its tile is actually visible.
    await cubit.setBudgetCycleStartDay(28);
    await pumpApp(
      tester,
      BlocProvider.value(value: cubit, child: const SettingsPage()),
      scaffold: false,
      textScaler: const TextScaler.linear(1.3),
    );
    await tester.pumpAndSettle();

    // Open the picker from the row (now labelled "Day 28").
    await tester.tap(find.text('Day 28'));
    await tester.pumpAndSettle();

    // The selected day's tile inside the sheet must be on-screen, not scrolled
    // past the bottom (the pre-fix base-48 offset lands it below the viewport).
    final selectedTile = find.descendant(
      of: find.byType(AppBottomSheet),
      matching: find.text('Day 28'),
    );
    expect(selectedTile, findsOneWidget);
    final tileRect = tester.getRect(selectedTile);
    final screenHeight = tester.getSize(find.byType(MaterialApp)).height;
    expect(tileRect.top, greaterThanOrEqualTo(0.0));
    expect(tileRect.bottom, lessThanOrEqualTo(screenHeight));
  });
}
