/// App-level abstraction over permission_handler's [Permission] type.
///
/// Add a new value here (plus one entry in [PermissionServiceImpl._permissionMap])
/// to support a new permission — no other files need to change.
enum AppPermission { camera, location, storage, notification }
