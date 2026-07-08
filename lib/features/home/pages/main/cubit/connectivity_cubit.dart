import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/utils/utils.dart';

part 'connectivity_cubit.freezed.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityService _service;
  late final StreamSubscription<bool> _subscription;

  ConnectivityCubit(this._service)
    : super(const ConnectivityState.connected()) {
    _subscription = _service.stream.listen((isConnected) {
      emit(
        isConnected
            ? const ConnectivityState.connected()
            : const ConnectivityState.disconnected(),
      );
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

@freezed
sealed class ConnectivityState with _$ConnectivityState {
  const factory ConnectivityState.connected() = ConnectivityStateConnected;

  const factory ConnectivityState.disconnected() =
      ConnectivityStateDisconnected;
}
