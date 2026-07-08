import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/core/models/models.dart';
import 'package:jaga_saku/features/users/domain/entities/entities.dart';
import 'package:jaga_saku/features/users/domain/repositories/repositories.dart';

part 'get_users.freezed.dart';

/// `GET /users` — a paginated page of users.
class GetUsers extends UseCase<Page<User>, GetUsersParams> {
  final UsersRepository _repo;

  GetUsers(this._repo);

  @override
  Future<Either<Failure, Page<User>>> call(GetUsersParams params) => _repo
      .getUsers(page: params.page, limit: params.limit, search: params.search);
}

@freezed
sealed class GetUsersParams with _$GetUsersParams {
  const factory GetUsersParams({
    @Default(1) int page,
    @Default(20) int limit,
    String? search,
  }) = _GetUsersParams;
}
