import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/auth/domain/repositories/repositories.dart';

/// `POST /auth/logout` — revoke the session server-side, then the repository
/// clears local tokens. Remote failures are swallowed by the repository so the
/// local session is always torn down.
class Logout extends UseCase<void, NoParams> {
  final AuthRepository _repo;

  Logout(this._repo);

  @override
  Future<Either<Failure, void>> call(NoParams _) => _repo.logout();
}
