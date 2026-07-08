import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

/// Authenticated account, mirroring the backend `user` object
/// (`/auth/login`, `/auth/register`, `/auth/me`).
///
/// Named `AuthUser` rather than `User` to avoid colliding with the existing
/// list-feature `User` entity (`features/users`), which has a different shape.
@freezed
sealed class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String name,
    required String email,
    required String role,
    required bool isActive,
    required String createdAt,
    required String updatedAt,
    String? phone,
    String? avatarUrl,
  }) = _AuthUser;
}
