import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

/// Pumps a minimal localized tree and returns a context with [Strings]
/// available, so `Failure.localize(context)` can be exercised.
Future<BuildContext> _localizedContext(WidgetTester tester) async {
  late BuildContext captured;
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: Strings.localizationsDelegates,
      supportedLocales: Strings.supportedLocales,
      home: Builder(
        builder: (context) {
          captured = context;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return captured;
}

void main() {
  group('Failure.localize', () {
    testWidgets(
      'CacheFailure and the io backup reason map to errorUnexpected',
      (tester) async {
        final context = await _localizedContext(tester);
        final s = Strings.of(context)!;

        expect(const CacheFailure().localize(context), s.errorUnexpected);
        expect(
          const BackupFailure(BackupFailureReason.io).localize(context),
          s.errorUnexpected,
        );
      },
    );

    testWidgets('ConflictFailure prefers its message when present', (
      tester,
    ) async {
      final context = await _localizedContext(tester);

      expect(
        const ConflictFailure('That name already exists').localize(context),
        'That name already exists',
      );
    });

    testWidgets('ConflictFailure falls back to errorConflict when empty/null', (
      tester,
    ) async {
      final context = await _localizedContext(tester);
      final s = Strings.of(context)!;

      expect(const ConflictFailure('').localize(context), s.errorConflict);
      expect(const ConflictFailure().localize(context), s.errorConflict);
    });
  });
}
