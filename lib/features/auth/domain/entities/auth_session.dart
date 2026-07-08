import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/auth/domain/entities/auth_user.dart';

part 'auth_session.freezed.dart';

/// Result of a successful login / register: the authenticated [AuthUser]
/// plus the token pair the app stores in secure storage.
@freezed
sealed class AuthSession with _$AuthSession {
  const factory AuthSession({
    required AuthUser user,
    required String accessToken,
    required String refreshToken,
  }) = _AuthSession;
}
