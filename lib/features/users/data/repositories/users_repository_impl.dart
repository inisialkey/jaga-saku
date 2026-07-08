import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDatasource usersRemoteDatasource;

  const UsersRepositoryImpl(this.usersRemoteDatasource);

  @override
  Future<Either<Failure, Page<User>>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  }) =>
      usersRemoteDatasource.getUsers(page: page, limit: limit, search: search);

  @override
  Future<Either<Failure, User>> getUser(String id) =>
      usersRemoteDatasource.getUser(id);

  @override
  Future<Either<Failure, User>> updateUser(
    String id, {
    String? name,
    String? phone,
    String? avatarUrl,
  }) => usersRemoteDatasource.updateUser(
    id,
    name: name,
    phone: phone,
    avatarUrl: avatarUrl,
  );

  @override
  Future<Either<Failure, void>> deleteUser(String id) =>
      usersRemoteDatasource.deleteUser(id);
}
