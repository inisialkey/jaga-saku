import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/pages/form/account_form_cubit.dart';
import 'package:jaga_saku/features/accounts/pages/form/account_form_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

/// [AccountFormPage] over a real [AccountFormCubit] (mocked [SaveAccount]),
/// pushed onto a go_router stack — the D1 always-enabled Save + D2 unsaved-
/// changes guard, incl. the catch #2 "a successful save does not double-prompt".
void main() {
  setUpAll(registerFallbackValues);

  late MockSaveAccount saveAccount;
  late MockTxChangeNotifier txChanges;

  setUp(() {
    saveAccount = MockSaveAccount();
    txChanges = MockTxChangeNotifier();
  });

  Future<void> pumpForm(WidgetTester tester, AccountFormCubit cubit) =>
      pumpFormRouter(
        tester,
        formChild: BlocProvider.value(
          value: cubit,
          child: const AccountFormPage(),
        ),
      );

  testWidgets('D1: Save stays enabled while invalid and an invalid tap never '
      'saves', (tester) async {
    final cubit = AccountFormCubit(
      saveAccount: saveAccount,
      txChangeNotifier: txChanges,
    );
    addTearDown(cubit.close);
    await pumpForm(tester, cubit);

    // The Save button is enabled (onPressed non-null) despite the empty name.
    final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    expect(button.onPressed, isNotNull);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // Invalid submit surfaces a toast (via the failure listener) but never saves
    // and never leaves the form.
    verifyNever(() => saveAccount(any()));
    expect(find.byType(AccountFormPage), findsOneWidget);
  });

  testWidgets('D2: a pristine form pops back with no confirm sheet', (
    tester,
  ) async {
    final cubit = AccountFormCubit(
      saveAccount: saveAccount,
      txChangeNotifier: txChanges,
    );
    addTearDown(cubit.close);
    await pumpForm(tester, cubit);

    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();

    expect(find.byKey(pumpFormHomeKey), findsOneWidget);
    expect(find.text('Discard changes?'), findsNothing);
  });

  testWidgets(
    'D2: an edited form prompts; keep-editing stays, discard leaves',
    (tester) async {
      final cubit = AccountFormCubit(
        saveAccount: saveAccount,
        txChangeNotifier: txChanges,
      );
      addTearDown(cubit.close);
      await pumpForm(tester, cubit);

      await tester.enterText(find.byType(TextField).first, 'Cash');
      await tester.pump();

      // Back with unsaved edits → the discard confirm sheet.
      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();
      expect(find.text('Discard changes?'), findsOneWidget);

      // Keep editing → sheet closes, still on the form.
      await tester.tap(find.text('Keep editing'));
      await tester.pumpAndSettle();
      expect(find.byType(AccountFormPage), findsOneWidget);
      expect(find.byKey(pumpFormHomeKey), findsNothing);

      // Back again, discard this time → leaves to home.
      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Discard'));
      await tester.pumpAndSettle();
      expect(find.byKey(pumpFormHomeKey), findsOneWidget);
    },
  );

  testWidgets('Catch #2: a successful save pops with no confirm sheet', (
    tester,
  ) async {
    when(
      () => saveAccount(any()),
    ).thenAnswer((_) async => const Right<Failure, int>(1));
    final cubit = AccountFormCubit(
      saveAccount: saveAccount,
      txChangeNotifier: txChanges,
    );
    addTearDown(cubit.close);
    await pumpForm(tester, cubit);

    // A valid, edited form: saving here must NOT trip the unsaved-changes guard.
    await tester.enterText(find.byType(TextField).first, 'Cash');
    await tester.pump();
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    verify(() => saveAccount(any())).called(1);
    // The success `context.pop(true)` is an imperative pop — it bypasses the
    // PopScope, so the discard sheet never appears and we land back on home.
    expect(find.text('Discard changes?'), findsNothing);
    expect(find.byKey(pumpFormHomeKey), findsOneWidget);
  });
}
