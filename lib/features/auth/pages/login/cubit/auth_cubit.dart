import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._login, this._register) : super(const AuthStateLoading());

  final Login _login;
  final Register _register;

  Future<void> login(LoginParams params) => _emitAuth(_login.call(params));

  Future<void> register(RegisterParams params) =>
      _emitAuth(_register.call(params));

  /// Shared emit path for login/register: tokens are persisted in the
  /// repository; the success state carries the authenticated user.
  Future<void> _emitAuth(Future<Either<Failure, AuthSession>> request) async {
    emit(const AuthStateLoading());
    final data = await request;
    if (isClosed) return;

    data.fold(
      // Carry the Failure; the presentation layer localizes it (see
      // Failure.localize). Keeps raw backend strings out of the UI contract.
      (l) => emit(AuthStateFailure(l)),
      (r) => emit(AuthStateSuccess(r.user)),
    );
  }
}

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.success(AuthUser? user) = AuthStateSuccess;
  const factory AuthState.failure(Failure failure) = AuthStateFailure;
}
