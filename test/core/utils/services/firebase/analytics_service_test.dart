import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  late MockFirebaseAnalytics analytics;
  late AnalyticsService service;

  setUp(() {
    analytics = MockFirebaseAnalytics();
    service = AnalyticsService(analytics);
  });

  test('logLogin delegates the method to FirebaseAnalytics', () async {
    when(
      () => analytics.logLogin(loginMethod: any(named: 'loginMethod')),
    ).thenAnswer((_) async {});

    await service.logLogin(method: 'google');

    verify(() => analytics.logLogin(loginMethod: 'google')).called(1);
  });

  test('logEvent delegates the name and parameters', () async {
    when(
      () => analytics.logEvent(
        name: any(named: 'name'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async {});

    await service.logEvent('button_tap', parameters: const {'id': 'save'});

    verify(
      () => analytics.logEvent(
        name: 'button_tap',
        parameters: const {'id': 'save'},
      ),
    ).called(1);
  });

  test('setUserId delegates to FirebaseAnalytics', () async {
    when(
      () => analytics.setUserId(id: any(named: 'id')),
    ).thenAnswer((_) async {});

    await service.setUserId('u1');

    verify(() => analytics.setUserId(id: 'u1')).called(1);
  });
}
