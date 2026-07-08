import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  group('notificationRouteFor', () {
    test('returns the route when present', () {
      expect(notificationRouteFor({'route': '/users/123'}), '/users/123');
    });

    test('null when route is absent', () {
      expect(notificationRouteFor({'type': 'user', 'id': '1'}), isNull);
      expect(notificationRouteFor(<String, dynamic>{}), isNull);
    });

    test('null when route is empty or not a string', () {
      expect(notificationRouteFor({'route': ''}), isNull);
      expect(notificationRouteFor({'route': 123}), isNull);
    });
  });
}
