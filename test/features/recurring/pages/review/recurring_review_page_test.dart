import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/pages/review/recurring_review_cubit.dart';
import 'package:jaga_saku/features/recurring/pages/review/recurring_review_page.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

/// [RecurringReviewPage] over a real cubit (mocked usecases): the D3 bulk-safe
/// Confirm-all — gated by a confirm sheet before any write, then disabling the
/// actions while the write is in flight.
void main() {
  setUpAll(registerFallbackValues);

  late MockGetDueOccurrences getDueOccurrences;
  late MockConfirmOccurrence confirmOccurrence;
  late MockSkipOccurrence skipOccurrence;
  late TxChangeNotifier txChanges;

  const template = TxTemplate(
    label: 'Rent',
    type: TransactionType.expense,
    accountId: 1,
    amount: 50000,
  );
  const rule = RecurringRule(
    id: 1,
    templateId: 1,
    freq: RecurrenceFreq.monthly,
    startDate: 0,
    nextDue: 0,
  );
  PendingOccurrence occ(int dueDate) =>
      PendingOccurrence(rule: rule, template: template, dueDate: dueDate);

  setUp(() {
    getDueOccurrences = MockGetDueOccurrences();
    confirmOccurrence = MockConfirmOccurrence();
    skipOccurrence = MockSkipOccurrence();
    txChanges = TxChangeNotifier();
  });

  tearDown(() => txChanges.dispose());

  RecurringReviewCubit build() => RecurringReviewCubit(
    getDueOccurrences: getDueOccurrences,
    confirmOccurrence: confirmOccurrence,
    skipOccurrence: skipOccurrence,
    txChangeNotifier: txChanges,
  );

  // A tall surface so both occurrence cards (and their buttons) lay out.
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pumpReview(WidgetTester tester, RecurringReviewCubit cubit) =>
      pumpApp(
        tester,
        BlocProvider.value(value: cubit, child: const RecurringReviewPage()),
        scaffold: false,
      );

  testWidgets('D3: Confirm-all is gated by a confirm sheet before any write', (
    tester,
  ) async {
    useTallSurface(tester);
    when(() => getDueOccurrences(any())).thenAnswer(
      (_) async => Right<Failure, List<PendingOccurrence>>([occ(1), occ(2)]),
    );
    when(
      () => confirmOccurrence(any()),
    ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

    final cubit = build()..load();
    addTearDown(cubit.close);
    await pumpReview(tester, cubit);
    await tester.pumpAndSettle();

    // Header Confirm-all opens the sheet; nothing is written yet.
    await tester.tap(find.text('Confirm all'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm all?'), findsOneWidget); // the sheet title
    verifyNever(() => confirmOccurrence(any()));

    // Confirming the sheet runs the bulk write (both occurrences).
    await tester.tap(
      find.descendant(
        of: find.byType(ConfirmSheet),
        matching: find.text('Confirm all'),
      ),
    );
    await tester.pumpAndSettle();
    verify(() => confirmOccurrence(any())).called(2);
  });

  testWidgets(
    'D3: the action buttons disable while the bulk write is running',
    (tester) async {
      useTallSurface(tester);
      final gate = Completer<void>();
      when(() => getDueOccurrences(any())).thenAnswer(
        (_) async => Right<Failure, List<PendingOccurrence>>([occ(1), occ(2)]),
      );
      when(() => confirmOccurrence(any())).thenAnswer((_) async {
        await gate.future;
        return const Right<Failure, Unit>(unit);
      });

      final cubit = build()..load();
      addTearDown(cubit.close);
      await pumpReview(tester, cubit);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm all'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(ConfirmSheet),
          matching: find.text('Confirm all'),
        ),
      );
      // Let the sheet dismiss + confirmAll flag busy, but hold the write open.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Every Primary action button is now in its loading (busy) state.
      final buttons = tester.widgetList<PrimaryButton>(
        find.byType(PrimaryButton),
      );
      expect(buttons, isNotEmpty);
      expect(buttons.every((b) => b.isLoading), isTrue);

      gate.complete();
      await tester.pumpAndSettle();
    },
  );
}
