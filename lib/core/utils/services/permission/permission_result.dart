/// The result returned by every [PermissionService.checkPermission] and
/// [PermissionService.requestPermission] call.
///
/// Callers switch exhaustively on this value — no permission_handler types
/// ever leave [PermissionServiceImpl].
enum PermissionResult {
  /// User allowed access. Proceed with the feature.
  granted,

  /// Not yet granted and can still be requested.
  /// Show a rationale dialog if appropriate, then request again.
  denied,

  /// User tapped "Never ask again". The system dialog will not appear again.
  /// Show an "Open Settings" dialog so the user can grant access manually.
  permanentlyDenied,

  /// OS-level restriction (parental controls, MDM). Cannot be resolved in-app.
  /// Show an informational message.
  restricted,

  /// Partial access granted (iOS 14+ for photos/contacts).
  /// Proceed with limited capability.
  limited,

  /// iOS 12+ provisional notification permission — quiet/non-interruptive delivery.
  /// Treat as usable (caller should check and upgrade to full permission later).
  provisional,
}
