import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/utils/services/permission/app_permission.dart';
import 'package:jaga_saku/core/utils/services/permission/permission_result.dart';
import 'package:jaga_saku/core/utils/services/permission/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

// Helper: installs a method channel handler that returns [status] for every
// permission check and request call.
void _mockPermissionChannel(PermissionStatus status) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('flutter.baseflow.com/permissions/methods'),
        (MethodCall call) async {
          switch (call.method) {
            case 'checkPermissionStatus':
              return status.index;
            case 'requestPermissions':
              final permissions = call.arguments as List<dynamic>;
              return <int, int>{
                for (final p in permissions) p as int: status.index,
              };
            default:
              return null;
          }
        },
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PermissionServiceImpl service;

  setUp(() {
    service = PermissionServiceImpl();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter.baseflow.com/permissions/methods'),
          null,
        );
  });

  group('checkPermission', () {
    test('returns granted when OS status is granted', () async {
      _mockPermissionChannel(PermissionStatus.granted);
      expect(
        await service.checkPermission(AppPermission.camera),
        PermissionResult.granted,
      );
    });

    test('returns denied when OS status is denied', () async {
      _mockPermissionChannel(PermissionStatus.denied);
      expect(
        await service.checkPermission(AppPermission.location),
        PermissionResult.denied,
      );
    });

    test(
      'returns permanentlyDenied when OS status is permanentlyDenied',
      () async {
        _mockPermissionChannel(PermissionStatus.permanentlyDenied);
        expect(
          await service.checkPermission(AppPermission.notification),
          PermissionResult.permanentlyDenied,
        );
      },
    );

    test('returns restricted when OS status is restricted', () async {
      _mockPermissionChannel(PermissionStatus.restricted);
      expect(
        await service.checkPermission(AppPermission.storage),
        PermissionResult.restricted,
      );
    });

    test('returns limited when OS status is limited', () async {
      _mockPermissionChannel(PermissionStatus.limited);
      expect(
        await service.checkPermission(AppPermission.camera),
        PermissionResult.limited,
      );
    });

    test('returns provisional when OS status is provisional', () async {
      _mockPermissionChannel(PermissionStatus.provisional);
      expect(
        await service.checkPermission(AppPermission.notification),
        PermissionResult.provisional,
      );
    });
  });

  group('requestPermission', () {
    test('returns granted after successful request', () async {
      _mockPermissionChannel(PermissionStatus.granted);
      expect(
        await service.requestPermission(AppPermission.camera),
        PermissionResult.granted,
      );
    });

    test('returns permanentlyDenied when user taps Never ask again', () async {
      _mockPermissionChannel(PermissionStatus.permanentlyDenied);
      expect(
        await service.requestPermission(AppPermission.notification),
        PermissionResult.permanentlyDenied,
      );
    });

    test('returns denied when user dismisses the dialog', () async {
      _mockPermissionChannel(PermissionStatus.denied);
      expect(
        await service.requestPermission(AppPermission.location),
        PermissionResult.denied,
      );
    });

    test('returns restricted when OS returns restricted', () async {
      _mockPermissionChannel(PermissionStatus.restricted);
      expect(
        await service.requestPermission(AppPermission.storage),
        PermissionResult.restricted,
      );
    });

    test('returns limited when OS returns limited', () async {
      _mockPermissionChannel(PermissionStatus.limited);
      expect(
        await service.requestPermission(AppPermission.storage),
        PermissionResult.limited,
      );
    });

    test('returns provisional when OS returns provisional', () async {
      _mockPermissionChannel(PermissionStatus.provisional);
      expect(
        await service.requestPermission(AppPermission.notification),
        PermissionResult.provisional,
      );
    });
  });

  group('all AppPermission values are mapped', () {
    test('no AppPermission value throws on checkPermission', () {
      _mockPermissionChannel(PermissionStatus.granted);
      for (final permission in AppPermission.values) {
        expect(() => service.checkPermission(permission), returnsNormally);
      }
    });
  });
}
