import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';
part 'logout_cubit.freezed.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final Logout _logout;
  final ClearSession _clearSession;

  LogoutCubit(this._logout, this._clearSession)
    : super(const LogoutStateLoading());

  Future<void> postLogout() async {
    emit(const LogoutStateLoading());
    // `Logout` revokes the session server-side and clears local tokens via the
    // repository. `ClearSession` is also invoked to guarantee local teardown
    // even on the (swallowed) remote-failure path; it is idempotent.
    final data = await _logout.call(NoParams());
    if (isClosed) return;

    data.fold(
      // Carry the Failure; presentation localizes via Failure.localize.
      (l) => emit(LogoutStateFailure(l)),
      (_) async {
        await _clearSession();
        if (isClosed) return;
        emit(const LogoutStateSuccess());
      },
    );
  }
}

@freezed
sealed class LogoutState with _$LogoutState {
  const factory LogoutState.loading() = LogoutStateLoading;
  const factory LogoutState.failure(Failure failure) = LogoutStateFailure;
  const factory LogoutState.success() = LogoutStateSuccess;
}
