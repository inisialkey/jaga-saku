import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/auth/domain/entities/entities.dart';
import 'package:jaga_saku/features/auth/domain/repositories/repositories.dart';
part 'login.freezed.dart';

/// `POST /auth/login` — exchange credentials for an [AuthSession].
class Login extends UseCase<AuthSession, LoginParams> {
  final AuthRepository _repo;

  Login(this._repo);

  @override
  Future<Either<Failure, AuthSession>> call(LoginParams params) =>
      _repo.login(params);
}

@freezed
sealed class LoginParams with _$LoginParams {
  const factory LoginParams({
    @Default('') String email,
    @Default('') String password,
  }) = _LoginParams;
}
