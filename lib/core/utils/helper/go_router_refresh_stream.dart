import 'dart:async';

import 'package:flutter/material.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(List<Stream<dynamic>> streams) : _subscriptions = [] {
    notifyListeners();
    for (final stream in streams) {
      _subscriptions.add(stream.listen((dynamic _) => notifyListeners()));
    }
  }

  final List<StreamSubscription<dynamic>> _subscriptions;

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel(); //coverage:ignore-line
    }
    super.dispose();
  }
}
