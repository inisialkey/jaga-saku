import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';

abstract class AuthRemoteDatasource {
  Future<Either<Failure, AuthResponseModel>> login(LoginParams params);

  Future<Either<Failure, AuthResponseModel>> register(RegisterParams params);

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserModel>> getCurrentUser();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _client;

  AuthRemoteDatasourceImpl(this._client);

  @override
  Future<Either<Failure, AuthResponseModel>> login(LoginParams params) =>
      _client.postRequest(
        ListAPI.login,
        data: {'email': params.email, 'password': params.password},
        converter: _authResponseConverter,
      );

  @override
  Future<Either<Failure, AuthResponseModel>> register(RegisterParams params) =>
      _client.postRequest(
        ListAPI.register,
        data: {
          'name': params.name,
          'email': params.email,
          'password': params.password,
          if (params.phone != null) 'phone': params.phone,
        },
        converter: _authResponseConverter,
      );

  @override
  Future<Either<Failure, void>> logout() => _client.postRequest<void>(
    ListAPI.logout,
    // Logout returns 204 No Content (no envelope body); nothing to decode.
    converter: (_) {},
  );

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() =>
      _client.getRequest(ListAPI.me, converter: _userConverter);

  /// Parses the success envelope for login/register and returns its `data`
  /// as an [AuthResponseModel]. Falls back to a [ServerFailure] (caught by
  /// DioClient) when `data` is missing.
  AuthResponseModel _authResponseConverter(Object? response) {
    final envelope = ApiResponse<AuthResponseModel>.fromJson(
      response! as Map<String, dynamic>,
      (data) => AuthResponseModel.fromJson(data! as Map<String, dynamic>),
    );
    final data = envelope.data;
    if (data == null) {
      throw const ServerFailure('Auth response missing data');
    }
    return data;
  }

  /// Parses the success envelope for `/auth/me` and returns its `data` as a
  /// [UserModel].
  UserModel _userConverter(Object? response) {
    final envelope = ApiResponse<UserModel>.fromJson(
      response! as Map<String, dynamic>,
      (data) => UserModel.fromJson(data! as Map<String, dynamic>),
    );
    final data = envelope.data;
    if (data == null) {
      throw const ServerFailure('User response missing data');
    }
    return data;
  }
}
