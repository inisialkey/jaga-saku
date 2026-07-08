import 'package:jaga_saku/core/utils/services/permission/app_permission.dart';
import 'package:jaga_saku/core/utils/services/permission/permission_result.dart';
import 'package:permission_handler/permission_handler.dart';

/// Abstract interface for permission operations.
///
/// Depend on this type in cubits and other callers — never on [PermissionServiceImpl].
/// This makes it trivial to swap in a [MockPermissionService] in tests.
abstract class PermissionService {
  /// Returns the current permission status without prompting the user.
  Future<PermissionResult> checkPermission(AppPermission permission);

  /// Requests the permission, showing the system dialog if not yet decided.
  ///
  /// If the user has permanently denied, returns [PermissionResult.permanentlyDenied]
  /// without showing a dialog. The caller is responsible for guiding the user
  /// to app settings via [openAppSettings()].
  Future<PermissionResult> requestPermission(AppPermission permission);
}

/// Concrete implementation — the only file in the project that imports
/// `permission_handler` directly.
class PermissionServiceImpl implements PermissionService {
  /// Maps each [AppPermission] value to the corresponding [Permission] from
  /// the permission_handler package.
  ///
  /// To support a new permission: add an entry here and a new value to [AppPermission].
  static const Map<AppPermission, Permission> _permissionMap = {
    AppPermission.camera: Permission.camera,
    AppPermission.location: Permission.locationWhenInUse,
    AppPermission.storage: Permission.storage,
    AppPermission.notification: Permission.notification,
  };

  @override
  Future<PermissionResult> checkPermission(AppPermission permission) async {
    final nativePermission = _permissionMap[permission];
    assert(nativePermission != null, 'Add $permission to _permissionMap');
    final status = await nativePermission!.status;
    return _mapStatus(status);
  }

  @override
  Future<PermissionResult> requestPermission(AppPermission permission) async {
    final nativePermission = _permissionMap[permission];
    assert(nativePermission != null, 'Add $permission to _permissionMap');
    final status = await nativePermission!.request();
    return _mapStatus(status);
  }

  PermissionResult _mapStatus(PermissionStatus status) => switch (status) {
    PermissionStatus.granted => PermissionResult.granted,
    PermissionStatus.denied => PermissionResult.denied,
    PermissionStatus.permanentlyDenied => PermissionResult.permanentlyDenied,
    PermissionStatus.restricted => PermissionResult.restricted,
    PermissionStatus.limited => PermissionResult.limited,
    PermissionStatus.provisional => PermissionResult.provisional,
  };
}
