import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/utils/utils.dart';

part 'permission_cubit.freezed.dart';

/// Manages permission requests during the onboarding flow.
///
/// For lazy (per-feature) permissions — camera, location, storage — inject
/// [PermissionService] directly into the feature cubit and call
/// [PermissionService.requestPermission] before accessing the feature.
class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit(this._permissionService)
    : super(const PermissionState.initial());

  final PermissionService _permissionService;

  /// Requests the notification permission (called once during onboarding).
  Future<void> requestNotification() async {
    final result = await _permissionService.requestPermission(
      AppPermission.notification,
    );
    _emitResult(result);
  }

  /// Checks the current notification permission status without prompting.
  /// Useful for checking whether to skip the permission step on re-entry.
  Future<void> checkNotification() async {
    final result = await _permissionService.checkPermission(
      AppPermission.notification,
    );
    _emitResult(result);
  }

  void _emitResult(PermissionResult result) {
    switch (result) {
      case PermissionResult.granted:
      case PermissionResult.limited:
      case PermissionResult.provisional:
        emit(const PermissionState.granted());
      case PermissionResult.denied:
        emit(const PermissionState.denied());
      case PermissionResult.permanentlyDenied:
        emit(const PermissionState.permanentlyDenied());
      case PermissionResult.restricted:
        emit(const PermissionState.restricted());
    }
  }
}

@freezed
sealed class PermissionState with _$PermissionState {
  /// Permission request has not been made yet.
  const factory PermissionState.initial() = PermissionStateInitial;

  /// Permission was granted (or limited, treated as usable).
  const factory PermissionState.granted() = PermissionStateGranted;

  /// Permission was denied — can still be requested again.
  const factory PermissionState.denied() = PermissionStateDenied;

  /// User permanently denied — guide them to app settings.
  /// Call [openAppSettings()] from the page's BlocListener, not from this cubit.
  const factory PermissionState.permanentlyDenied() =
      PermissionStatePermanentlyDenied;

  /// OS-level restriction (parental controls, MDM) — show informational message.
  const factory PermissionState.restricted() = PermissionStateRestricted;
}
