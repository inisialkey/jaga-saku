import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/auth/domain/entities/entities.dart';
import 'package:jaga_saku/features/auth/domain/repositories/repositories.dart';

/// `GET /auth/me` — fetch the currently authenticated user.
class GetCurrentUser extends UseCase<AuthUser, NoParams> {
  final AuthRepository _repo;

  GetCurrentUser(this._repo);

  @override
  Future<Either<Failure, AuthUser>> call(NoParams _) => _repo.getCurrentUser();
}
