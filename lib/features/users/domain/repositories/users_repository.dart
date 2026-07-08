import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/models/models.dart';
import 'package:jaga_saku/features/users/domain/entities/entities.dart';

abstract class UsersRepository {
  /// `GET /users` — a single page of users plus pagination [PaginationMeta].
  Future<Either<Failure, Page<User>>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  });

  /// `GET /users/{id}` — a single user.
  Future<Either<Failure, User>> getUser(String id);

  /// `PUT /users/{id}` — update mutable fields; null fields are omitted from
  /// the request body. Returns the updated [User].
  Future<Either<Failure, User>> updateUser(
    String id, {
    String? name,
    String? phone,
    String? avatarUrl,
  });

  /// `DELETE /users/{id}` — soft delete. Response `data` is null.
  Future<Either<Failure, void>> deleteUser(String id);
}
