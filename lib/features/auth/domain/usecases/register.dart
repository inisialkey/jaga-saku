import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/auth/domain/entities/entities.dart';
import 'package:jaga_saku/features/auth/domain/repositories/repositories.dart';
part 'register.freezed.dart';

/// `POST /auth/register` — create an account and return its [AuthSession].
class Register extends UseCase<AuthSession, RegisterParams> {
  final AuthRepository _repo;

  Register(this._repo);

  @override
  Future<Either<Failure, AuthSession>> call(RegisterParams params) =>
      _repo.register(params);
}

@freezed
sealed class RegisterParams with _$RegisterParams {
  const factory RegisterParams({
    @Default('') String name,
    @Default('') String email,
    @Default('') String password,
    String? phone,
  }) = _RegisterParams;
}
