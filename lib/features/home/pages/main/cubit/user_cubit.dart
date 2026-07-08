import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';
part 'user_cubit.freezed.dart';

/// Loads the currently-authenticated account (`GET /auth/me`) for the home
/// shell. Uses the auth feature's [AuthUser] / [GetCurrentUser]; it is
/// intentionally decoupled from the `features/users` CRUD feature (which owns
/// its own list-oriented `User` entity).
class UserCubit extends Cubit<UserState> {
  final GetCurrentUser _getCurrentUser;

  UserCubit(this._getCurrentUser) : super(const UserStateLoading());

  Future<void> getUser() async {
    emit(const UserStateLoading());
    final data = await _getCurrentUser.call(NoParams());
    if (isClosed) return;

    data.fold(
      // Carry the Failure; the presentation layer localizes it (see
      // Failure.localize). Keeps raw backend strings out of the UI contract.
      (l) => emit(UserStateFailure(l)),
      (r) => emit(UserStateSuccess(r)),
    );
  }
}

@freezed
sealed class UserState with _$UserState {
  const factory UserState.loading() = UserStateLoading;
  const factory UserState.failure(Failure failure) = UserStateFailure;
  const factory UserState.success(AuthUser? data) = UserStateSuccess;
}
