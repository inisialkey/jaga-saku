import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/home/home.dart';
import 'package:jaga_saku/core/utils/utils.dart';

class FakeConnectivityService implements ConnectivityService {
  final _controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> get stream => _controller.stream;

  @override
  bool get isConnected => true;

  @override
  Future<void> checkConnectivity() async {}

  void emitConnected() => _controller.add(true);
  void emitDisconnected() => _controller.add(false);

  @override
  void dispose() => _controller.close();
}

void main() {
  late ConnectivityCubit cubit;
  late FakeConnectivityService fakeService;

  setUp(() {
    fakeService = FakeConnectivityService();
    cubit = ConnectivityCubit(fakeService);
  });

  tearDown(() {
    cubit.close();
    fakeService.dispose();
  });

  test('initial state is connected', () {
    expect(cubit.state, const ConnectivityState.connected());
  });

  blocTest<ConnectivityCubit, ConnectivityState>(
    'emits disconnected when stream emits false',
    build: () => cubit,
    act: (_) => fakeService.emitDisconnected(),
    expect: () => const [ConnectivityState.disconnected()],
  );

  blocTest<ConnectivityCubit, ConnectivityState>(
    'emits connected when stream emits true',
    build: () => cubit,
    act: (_) {
      fakeService.emitDisconnected();
      fakeService.emitConnected();
    },
    expect: () => const [
      ConnectivityState.disconnected(),
      ConnectivityState.connected(),
    ],
  );
}
