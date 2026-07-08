import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';
import 'package:jaga_saku/features/users/users.dart';

part 'edit_name_cubit.freezed.dart';

/// Reference wiring for a "edit my profile field" screen:
/// 1. [load] fetches the current user (`GET /auth/me`) to prefill the field
///    and capture the id, then
/// 2. [submit] performs `PUT /users/{id}` via the existing [UpdateUser] usecase.
///
/// The sibling edit_* pages (email/phone/age/…) are intentionally left as
/// stubs — clone this cubit + its page wiring to implement them.
class EditNameCubit extends Cubit<EditNameState> {
  EditNameCubit(this._getCurrentUser, this._updateUser)
    : super(const EditNameState.loading());

  final GetCurrentUser _getCurrentUser;
  final UpdateUser _updateUser;

  String? _userId;

  Future<void> load() async {
    emit(const EditNameState.loading());
    final result = await _getCurrentUser.call(NoParams());
    if (isClosed) return;
    result.fold((failure) => emit(EditNameState.failure(failure)), (user) {
      _userId = user.id;
      emit(EditNameState.loaded(user.name));
    });
  }

  Future<void> submit(String name) async {
    final id = _userId;
    if (id == null) return;
    emit(const EditNameState.submitting());
    final result = await _updateUser.call(UpdateUserParams(id: id, name: name));
    if (isClosed) return;
    result.fold(
      (failure) => emit(EditNameState.failure(failure)),
      (_) => emit(const EditNameState.success()),
    );
  }
}

@freezed
sealed class EditNameState with _$EditNameState {
  const factory EditNameState.loading() = EditNameStateLoading;
  const factory EditNameState.loaded(String name) = EditNameStateLoaded;
  const factory EditNameState.submitting() = EditNameStateSubmitting;
  const factory EditNameState.success() = EditNameStateSuccess;
  const factory EditNameState.failure(Failure failure) = EditNameStateFailure;
}
