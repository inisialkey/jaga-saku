import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

/// Pumps a minimal localized tree so `BackupFailure.localize(context)` resolves
/// against real ARB strings (mirrors `failure_x_test.dart`).
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
  testWidgets('each BackupFailureReason maps to its localized string', (
    tester,
  ) async {
    final context = await _localizedContext(tester);
    final s = Strings.of(context)!;

    expect(
      const BackupFailure(BackupFailureReason.invalidFile).localize(context),
      s.backupErrorInvalidFile,
    );
    expect(
      const BackupFailure(
        BackupFailureReason.unsupportedVersion,
      ).localize(context),
      s.backupErrorUnsupportedVersion,
    );
    expect(
      const BackupFailure(BackupFailureReason.corrupt).localize(context),
      s.backupErrorCorrupt,
    );
    // io has no bespoke copy — falls back to the generic unexpected string.
    expect(
      const BackupFailure(BackupFailureReason.io).localize(context),
      s.errorUnexpected,
    );
  });
}
