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
    testWidgets('maps technical/network failures to ARB strings', (
      tester,
    ) async {
      final context = await _localizedContext(tester);
      final s = Strings.of(context)!;

      expect(
        const ConnectionFailure().localize(context),
        s.noInternetConnection,
      );
      expect(const TimeoutFailure().localize(context), s.errorTimeout);
      expect(
        const SessionExpiredFailure().localize(context),
        s.sessionExpiredMessage,
      );
      expect(const CancelledFailure().localize(context), s.errorCancelled);
      expect(const NoDataFailure().localize(context), s.errorNoData);
      expect(const CacheFailure().localize(context), s.errorUnexpected);
      expect(const ConflictFailure().localize(context), s.errorConflict);
      expect(
        const PayloadTooLargeFailure().localize(context),
        s.errorPayloadTooLarge,
      );
      expect(
        const UnsupportedMediaTypeFailure().localize(context),
        s.errorUnsupportedMediaType,
      );
      expect(const InternalServerFailure().localize(context), s.errorServer);
      expect(const MaintenanceFailure().localize(context), s.errorMaintenance);
    });

    testWidgets('prefers the backend message when present', (tester) async {
      final context = await _localizedContext(tester);

      expect(
        const UnauthorizedFailure('Invalid credentials').localize(context),
        'Invalid credentials',
      );
      expect(
        const ServerFailure('Backend says no').localize(context),
        'Backend says no',
      );
    });

    testWidgets('falls back to a localized string when message is empty/null', (
      tester,
    ) async {
      final context = await _localizedContext(tester);
      final s = Strings.of(context)!;

      expect(
        const UnauthorizedFailure().localize(context),
        s.errorUnauthorized,
      );
      expect(const ServerFailure(null).localize(context), s.errorUnexpected);
      expect(const ForbiddenFailure('').localize(context), s.errorForbidden);
    });
  });
}
