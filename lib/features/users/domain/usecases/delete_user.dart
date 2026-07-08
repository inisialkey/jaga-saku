import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/users/domain/repositories/repositories.dart';

/// `DELETE /users/{id}` — soft delete a user. The user id is the [String] param.
class DeleteUser extends UseCase<void, String> {
  final UsersRepository _repo;

  DeleteUser(this._repo);

  @override
  Future<Either<Failure, void>> call(String id) => _repo.deleteUser(id);
}
