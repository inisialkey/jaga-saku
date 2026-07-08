import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/users/domain/entities/entities.dart';
import 'package:jaga_saku/features/users/domain/repositories/repositories.dart';

part 'update_user.freezed.dart';

/// `PUT /users/{id}` — update mutable user fields. Null fields are omitted by
/// the datasource so a partial update only sends the changed keys.
class UpdateUser extends UseCase<User, UpdateUserParams> {
  final UsersRepository _repo;

  UpdateUser(this._repo);

  @override
  Future<Either<Failure, User>> call(UpdateUserParams params) =>
      _repo.updateUser(
        params.id,
        name: params.name,
        phone: params.phone,
        avatarUrl: params.avatarUrl,
      );
}

@freezed
sealed class UpdateUserParams with _$UpdateUserParams {
  const factory UpdateUserParams({
    required String id,
    String? name,
    String? phone,
    String? avatarUrl,
  }) = _UpdateUserParams;
}
