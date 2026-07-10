import 'dart:async';

/// A lightweight cross-feature "derived-money-views changed" bus (M3, closes the
/// M2 W2 gap where the shell FAB's `/add` couldn't reach an already-built
/// [CalendarCubit]).
///
/// [ping]ed after any write that shifts a derived money view — a transaction
/// (add / edit / delete) or a budget write — and subscribed by Home, Calendar
/// and the Budget list so their derived views (balances, day lists, budget
/// spent / guard) refresh live.
///
/// Wraps a broadcast [StreamController] so any number of cubits can subscribe to
/// [changes] and refresh, while writers call [ping] after a successful save.
/// dart:async only — deliberately NOT a `flutter/foundation` `ChangeNotifier`,
/// so it stays dependency-light and trivially unit-testable. Registered as an
/// app-lifetime singleton in `dependencies_injection.dart`; every subscriber
/// MUST cancel its subscription in `close()` (rule 7).
class TxChangeNotifier {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  /// Fires once per [ping]. Broadcast, so every listener receives every event.
  Stream<void> get changes => _controller.stream;

  /// Signals that a derived money view changed — a transaction or budget write
  /// succeeded. No-op once [dispose]d so a late producer never throws.
  void ping() {
    if (_controller.isClosed) return;
    _controller.add(null);
  }

  /// Closes the underlying controller. Only the app-lifetime singleton owner
  /// (or a test tear-down) calls this.
  void dispose() => _controller.close();
}
