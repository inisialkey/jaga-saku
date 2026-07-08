import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

import 'package:jaga_saku/features/users/users.dart';

// ignore: avoid_implementing_value_types
class _MockGoRouterState extends Mock implements GoRouterState {}

void main() {
  group('UserRouteArgs', () {
    test('toPathParameters maps id', () {
      expect(const UserRouteArgs(id: '42').toPathParameters(), {'id': '42'});
    });

    test('fromState reads id and User extra', () {
      const user = User(
        id: '42',
        name: 'Ada',
        email: 'ada@mock.com',
        role: 'user',
        isActive: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final state = _MockGoRouterState();
      when(() => state.pathParameters).thenReturn({'id': '42'});
      when(() => state.extra).thenReturn(user);

      final args = UserRouteArgs.fromState(state);
      expect(args.id, '42');
      expect(args.user, user);
    });

    test('fromState leaves user null when extra is not a User', () {
      final state = _MockGoRouterState();
      when(() => state.pathParameters).thenReturn({'id': '7'});
      when(() => state.extra).thenReturn('not-a-user');

      final args = UserRouteArgs.fromState(state);
      expect(args.id, '7');
      expect(args.user, isNull);
    });
  });
}
