import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

/// A user record from the `/users` CRUD endpoints.
///
/// This feature owns its own [User] entity. It is intentionally distinct from
/// the auth feature's `AuthUser` (no cross-feature import): the two evolve
/// independently even though they currently mirror the same backend shape.
@freezed
sealed class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required String role,
    required bool isActive,
    required String createdAt,
    required String updatedAt,
    String? phone,
    String? avatarUrl,
  }) = _User;
}
