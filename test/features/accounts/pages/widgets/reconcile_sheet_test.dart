import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/pages/reconcile/reconcile_cubit.dart';
import 'package:jaga_saku/features/accounts/pages/widgets/reconcile_sheet.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

/// Widget test (NOT a golden — the repo has zero goldens): drives the cubit
/// directly and asserts the rendered delta preview + the confirm gate. The
/// keypad is its own modal, so the counted value is set via the cubit.
void main() {
  setUpAll(registerFallbackValues);

  late MockGetSystemCategory getSystemCategory;
  late MockSaveTransaction saveTransaction;

  const adjIn = Category(
    id: 9,
    name: 'Penyesuaian',
    type: CategoryType.income,
    systemKey: 'adjustment_in',
  );
  const adjOut = Category(
    id: 8,
    name: 'Penyesuaian',
    type: CategoryType.expense,
    systemKey: 'adjustment_out',
  );

  setUp(() {
    getSystemCategory = MockGetSystemCategory();
    saveTransaction = MockSaveTransaction();
    when(
      () => getSystemCategory('adjustment_in'),
    ).thenAnswer((_) async => const Right<Failure, Category?>(adjIn));
    when(
      () => getSystemCategory('adjustment_out'),
    ).thenAnswer((_) async => const Right<Failure, Category?>(adjOut));
  });

  ReconcileCubit buildCubit() => ReconcileCubit(
    getSystemCategory: getSystemCategory,
    saveTransaction: saveTransaction,
    accountId: 1,
    currentBalance: 480000,
  );

  Future<void> pumpSheet(WidgetTester tester, ReconcileCubit cubit) => pumpApp(
    tester,
    BlocProvider.value(
      value: cubit,
      child: const ReconcileSheet(accountId: 1, currentBalance: 480000),
    ),
  );

  PrimaryButton confirmButton(WidgetTester tester) =>
      tester.widget<PrimaryButton>(find.byType(PrimaryButton));

  testWidgets('confirm is disabled until the reserved pair resolves', (
    tester,
  ) async {
    final cubit = buildCubit();
    addTearDown(cubit.close);
    await pumpSheet(tester, cubit);

    // Before load: systemReady false → confirm disabled, delta-0 preview shown.
    expect(find.text('Balance is already correct'), findsOneWidget);
    expect(confirmButton(tester).onPressed, isNull);

    await cubit.load();
    await tester.pump();
    expect(confirmButton(tester).onPressed, isNotNull);
  });

  testWidgets('preview shows "Will add" for a positive delta', (tester) async {
    final cubit = buildCubit();
    addTearDown(cubit.close);
    await pumpSheet(tester, cubit);
    await cubit.load();

    cubit.countedChanged(500000); // +20.000
    await tester.pump();

    expect(find.text('Will add Rp 20.000'), findsOneWidget);
  });

  testWidgets('preview shows "Will subtract" for a negative delta', (
    tester,
  ) async {
    final cubit = buildCubit();
    addTearDown(cubit.close);
    await pumpSheet(tester, cubit);
    await cubit.load();

    cubit.countedChanged(450000); // −30.000 (the canonical case)
    await tester.pump();

    expect(find.text('Will subtract Rp 30.000'), findsOneWidget);
  });

  testWidgets('preview shows "already correct" for a zero delta', (
    tester,
  ) async {
    final cubit = buildCubit();
    addTearDown(cubit.close);
    await pumpSheet(tester, cubit);
    await cubit.load();

    cubit.countedChanged(480000); // exactly the current balance
    await tester.pump();

    expect(find.text('Balance is already correct'), findsOneWidget);
  });
}
