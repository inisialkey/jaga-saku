import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/users/domain/entities/entities.dart';
import 'package:jaga_saku/features/users/domain/repositories/repositories.dart';

/// `GET /users/{id}` — fetch a single user. The user id is the [String] param.
class GetUser extends UseCase<User, String> {
  final UsersRepository _repo;

  GetUser(this._repo);

  @override
  Future<Either<Failure, User>> call(String id) => _repo.getUser(id);
}
