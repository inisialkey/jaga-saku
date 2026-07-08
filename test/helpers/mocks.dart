import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';
import 'package:jaga_saku/features/users/users.dart';

/// Shared mocktail mock declarations + fallback registration for the test
/// suite. Replaces the mockito codegen (`@GenerateMocks` + `*.mocks.dart`).
///
/// Conventions:
/// - One thin `class MockX extends Mock implements X {}` per mocked type.
/// - `registerFallbackValues()` registers a sentinel for every custom type
///   passed to `any()` / `captureAny()` so mocktail doesn't throw at runtime.
///   Idempotent; safe to call from every test file's `setUpAll`.
///
/// Mocktail has no `provideDummy<...>` mechanism (mockito-only), so every
/// `Either`-returning mock call MUST be stubbed before invocation — otherwise
/// the call throws `Mock cannot return null for non-nullable type ...`.

// ---- Repositories ---------------------------------------------------------

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUsersRepository extends Mock implements UsersRepository {}

// ---- Datasources ----------------------------------------------------------

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MockUsersRemoteDatasource extends Mock implements UsersRemoteDatasource {}

// ---- Core services --------------------------------------------------------

class MockAuthTokenService extends Mock implements AuthTokenService {}

class MockPermissionService extends Mock implements PermissionService {}

class MockUploadService extends Mock implements UploadService {}

// ---- Notification --------------------------------------------------------

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockLocalNotificationHelper extends Mock
    implements LocalNotificationHelper {}

// ---- Auth usecases --------------------------------------------------------

class MockLogin extends Mock implements Login {}

class MockRegister extends Mock implements Register {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockLogout extends Mock implements Logout {}

// ---- Users usecases -------------------------------------------------------

class MockGetUsers extends Mock implements GetUsers {}

class MockGetUser extends Mock implements GetUser {}

class MockUpdateUser extends Mock implements UpdateUser {}

class MockDeleteUser extends Mock implements DeleteUser {}

// ---- Flutter --------------------------------------------------------------

class MockBuildContext extends Mock implements BuildContext {}

/// Registers fallback sentinels for every custom (non-nullable) type that
/// shows up inside `any()` / `captureAny()` matchers across the suite.
/// Mocktail requires this for any type that isn't a primitive / well-known
/// SDK type. Idempotent — calling it again is harmless.
void registerFallbackValues() {
  // Auth params
  registerFallbackValue(const LoginParams());
  registerFallbackValue(const RegisterParams());

  // Users params
  registerFallbackValue(const GetUsersParams());
  registerFallbackValue(const UpdateUserParams(id: ''));

  // Core
  registerFallbackValue(NoParams());
}
