import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/auth/domain/entities/entities.dart';
import 'package:jaga_saku/features/auth/domain/usecases/usecases.dart';

abstract class AuthRepository {
  /// `POST /auth/login` — on success, persists the token pair + `isLogin`
  /// flag, then returns the [AuthSession].
  Future<Either<Failure, AuthSession>> login(LoginParams params);

  /// `POST /auth/register` — same persistence side effects as [login].
  Future<Either<Failure, AuthSession>> register(RegisterParams params);

  /// `POST /auth/logout` — revoke the session server-side (failures are
  /// swallowed), then clear the local session.
  Future<Either<Failure, void>> logout();

  /// `GET /auth/me` — the currently authenticated user.
  Future<Either<Failure, AuthUser>> getCurrentUser();

  /// Clears the local session: auth flag + cached box data + secure tokens.
  /// Local and infallible, so it intentionally bypasses `Either<Failure, T>`.
  Future<void> clearSession();
}
