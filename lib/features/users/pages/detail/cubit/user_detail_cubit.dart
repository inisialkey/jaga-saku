import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';
part 'user_detail_cubit.freezed.dart';

/// Loads a single user by id for the detail page.
class UserDetailCubit extends Cubit<UserDetailState> {
  UserDetailCubit(this._getUser) : super(const UserDetailState.loading());

  final GetUser _getUser;

  Future<void> load(String id) async {
    emit(const UserDetailState.loading());
    final result = await _getUser.call(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(UserDetailState.failure(failure)),
      (user) => emit(UserDetailState.loaded(user)),
    );
  }
}

@freezed
sealed class UserDetailState with _$UserDetailState {
  const factory UserDetailState.loading() = UserDetailStateLoading;
  const factory UserDetailState.loaded(User user) = UserDetailStateLoaded;
  const factory UserDetailState.failure(Failure failure) =
      UserDetailStateFailure;
}
