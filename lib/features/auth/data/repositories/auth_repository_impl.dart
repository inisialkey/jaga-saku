import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final MainBoxMixin mainBoxMixin;
  final AuthTokenService authTokenService;

  const AuthRepositoryImpl(
    this.authRemoteDatasource,
    this.mainBoxMixin,
    this.authTokenService,
  );

  @override
  Future<Either<Failure, AuthSession>> login(LoginParams params) =>
      _persistSession(authRemoteDatasource.login(params));

  @override
  Future<Either<Failure, AuthSession>> register(RegisterParams params) =>
      _persistSession(authRemoteDatasource.register(params));

  /// Shared success path for login/register: on a successful auth response,
  /// store the token pair + set the `isLogin` flag, then return the session.
  Future<Either<Failure, AuthSession>> _persistSession(
    Future<Either<Failure, AuthResponseModel>> request,
  ) async {
    final response = await request;

    return response.fold((failure) => Left(failure), (model) async {
      await mainBoxMixin.addData(MainBoxKeys.isLogin, true);
      await authTokenService.saveTokens(
        accessToken: model.accessToken,
        refreshToken: model.refreshToken,
      );

      return Right(model.toEntity());
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    // Best-effort server revoke: clear the local session regardless of the
    // remote outcome so the user is always logged out locally.
    await authRemoteDatasource.logout();
    await clearSession();
    return const Right(null);
  }

  @override
  Future<Either<Failure, AuthUser>> getCurrentUser() async {
    final response = await authRemoteDatasource.getCurrentUser();
    return response.map((model) => model.toEntity());
  }

  @override
  Future<void> clearSession() async {
    await Future.wait([
      mainBoxMixin.logoutBox(),
      authTokenService.clearTokens(),
    ]);
  }
}
