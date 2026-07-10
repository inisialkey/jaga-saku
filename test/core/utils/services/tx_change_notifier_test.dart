import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';

void main() {
  group('TxChangeNotifier', () {
    test('ping emits an event on changes', () async {
      final notifier = TxChangeNotifier();
      final events = <void>[];
      final sub = notifier.changes.listen(events.add);

      notifier.ping();
      await pumpEventQueue();

      expect(events, hasLength(1));
      await sub.cancel();
      notifier.dispose();
    });

    test('broadcast: every listener receives every ping', () async {
      final notifier = TxChangeNotifier();
      var a = 0;
      var b = 0;
      final subA = notifier.changes.listen((_) => a++);
      final subB = notifier.changes.listen((_) => b++);

      notifier
        ..ping()
        ..ping();
      await pumpEventQueue();

      expect(a, 2);
      expect(b, 2);
      await subA.cancel();
      await subB.cancel();
      notifier.dispose();
    });

    test('ping after dispose is a no-op (never throws)', () {
      final notifier = TxChangeNotifier()..dispose();
      expect(notifier.ping, returnsNormally);
    });
  });
}
