import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/auth/auth.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

/// Wire model for the `data` payload of `/auth/login` and `/auth/register`:
/// `{ user, access_token, refresh_token, token_type, expires_in }`.
///
/// Decoded from the envelope's `data` via
/// `ApiResponse<AuthResponseModel>.fromJson(json, AuthResponseModel.fromJson)`
/// in the datasource, then mapped to the [AuthSession] domain entity.
@freezed
sealed class AuthResponseModel with _$AuthResponseModel {
  @JsonSerializable(explicitToJson: true)
  const factory AuthResponseModel({
    @JsonKey(name: 'user') required UserModel user,
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') required String tokenType,
    @JsonKey(name: 'expires_in') required int expiresIn,
  }) = _AuthResponseModel;

  const AuthResponseModel._();

  AuthSession toEntity() => AuthSession(
    user: user.toEntity(),
    accessToken: accessToken,
    refreshToken: refreshToken,
  );

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}
