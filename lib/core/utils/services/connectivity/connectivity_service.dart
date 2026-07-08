import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  final _controller = StreamController<bool>.broadcast();

  bool _isConnected = true;

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);
  }

  void _onChanged(List<ConnectivityResult> results) {
    _isConnected = results.any((r) => r != ConnectivityResult.none);
    _controller.add(_isConnected);
  }

  Stream<bool> get stream => _controller.stream;

  bool get isConnected => _isConnected;

  Future<void> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _onChanged(results);
  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
