import 'package:jaga_saku/features/auth/domain/repositories/repositories.dart';

/// Clears the local session (auth flag, cached box data, secure tokens).
/// Local + infallible, so it does not use the `Either<Failure, T>` contract.
/// Shared by [LogoutCubit] and the 401 path in DioInterceptor so session
/// teardown lives in exactly one place.
class ClearSession {
  final AuthRepository _repo;

  ClearSession(this._repo);

  Future<void> call() => _repo.clearSession();
}
