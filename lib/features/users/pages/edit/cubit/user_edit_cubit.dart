import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';
part 'user_edit_cubit.freezed.dart';

/// Drives the edit form: [submit] (PUT) and [delete] (DELETE) for a user.
class UserEditCubit extends Cubit<UserEditState> {
  UserEditCubit(this._updateUser, this._deleteUser, this._uploadService)
    : super(const UserEditState.initial());

  final UpdateUser _updateUser;
  final DeleteUser _deleteUser;
  final UploadService _uploadService;

  /// Picks + uploads an avatar image; returns the stored URL, `null` if the
  /// user cancelled, or a [Failure]. One-shot helper — the page writes the URL
  /// into the form field and shows its own progress (no state emission).
  Future<Either<Failure, String?>> pickAndUploadAvatar() =>
      _uploadService.pickAndUploadImage();

  Future<void> submit(
    String id, {
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    emit(const UserEditState.submitting());
    final result = await _updateUser.call(
      UpdateUserParams(id: id, name: name, phone: phone, avatarUrl: avatarUrl),
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(UserEditState.failure(failure)),
      (user) => emit(UserEditState.success(user)),
    );
  }

  Future<void> delete(String id) async {
    emit(const UserEditState.submitting());
    final result = await _deleteUser.call(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(UserEditState.failure(failure)),
      (_) => emit(const UserEditState.deleted()),
    );
  }
}

@freezed
sealed class UserEditState with _$UserEditState {
  const factory UserEditState.initial() = UserEditStateInitial;
  const factory UserEditState.submitting() = UserEditStateSubmitting;
  const factory UserEditState.success(User user) = UserEditStateSuccess;
  const factory UserEditState.deleted() = UserEditStateDeleted;
  const factory UserEditState.failure(Failure failure) = UserEditStateFailure;
}
