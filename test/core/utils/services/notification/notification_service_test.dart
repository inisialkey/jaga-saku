import 'package:jaga_saku/core/utils/services/hive/main_box.dart';
import 'package:jaga_saku/core/utils/services/notification/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../helpers/fake_path_provider_platform.dart';
import '../../../../helpers/mocks.dart';

/// Unit tests for the only Firebase-free logic in [NotificationService]:
/// FCM-token persistence into Hive under [MainBoxKeys.fcm].
///
/// The FirebaseMessaging IO (permission prompt, token fetch, stream wiring) is
/// integration-only — it cannot run without a live Firebase app, so it is NOT
/// exercised here. We inject a mock [FirebaseMessaging] purely so the service
/// constructs without hitting `FirebaseMessaging.instance`.
void main() {
  late NotificationService service;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await MainBoxMixin.initHive('notification_service_test_');
    // Start from a clean key each run.
    await MainBoxMixin.mainBox?.delete(MainBoxKeys.fcm.name);

    service = NotificationService(
      messaging: MockFirebaseMessaging(),
      localNotifications: MockLocalNotificationHelper(),
    );
  });

  String? storedToken() =>
      MainBoxMixin.mainBox?.get(MainBoxKeys.fcm.name) as String?;

  group('FCM token persistence (MainBoxKeys.fcm)', () {
    test('persists a non-empty token to Hive', () async {
      await service.saveTokenForTest('tok-123');
      expect(storedToken(), 'tok-123');
    });

    test('overwrites a previously stored token', () async {
      await service.saveTokenForTest('old');
      await service.saveTokenForTest('new');
      expect(storedToken(), 'new');
    });

    test('ignores a null token (no write)', () async {
      await service.saveTokenForTest('keep');
      await service.saveTokenForTest(null);
      expect(storedToken(), 'keep');
    });

    test('ignores an empty token (no write)', () async {
      await service.saveTokenForTest('keep');
      await service.saveTokenForTest('');
      expect(storedToken(), 'keep');
    });
  });

  group('topic pass-throughs delegate to FirebaseMessaging', () {
    test('subscribeToTopic forwards the topic', () async {
      final messaging = MockFirebaseMessaging();
      when(() => messaging.subscribeToTopic(any())).thenAnswer((_) async {});
      final s = NotificationService(
        messaging: messaging,
        localNotifications: MockLocalNotificationHelper(),
      );

      await s.subscribeToTopic('news');
      verify(() => messaging.subscribeToTopic('news')).called(1);
    });

    test('unsubscribeFromTopic forwards the topic', () async {
      final messaging = MockFirebaseMessaging();
      when(
        () => messaging.unsubscribeFromTopic(any()),
      ).thenAnswer((_) async {});
      final s = NotificationService(
        messaging: messaging,
        localNotifications: MockLocalNotificationHelper(),
      );

      await s.unsubscribeFromTopic('news');
      verify(() => messaging.unsubscribeFromTopic('news')).called(1);
    });
  });
}
