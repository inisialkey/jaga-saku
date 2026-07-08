import 'package:go_router/go_router.dart';

import 'package:jaga_saku/features/users/domain/entities/user.dart';

/// Typed arguments for the `/users/:id` detail & edit routes. Centralizes the
/// `id` path parameter and the optional [User] passed via `extra`, so route
/// builders and navigation call sites never hand-roll a `pathParameters` map or
/// cast `state.extra` by hand.
class UserRouteArgs {
  const UserRouteArgs({required this.id, this.user});

  final String id;

  /// The pre-loaded entity, passed via `extra` so the edit page can render
  /// immediately without a refetch. Null when navigated to by deep link.
  final User? user;

  /// Path parameters for `context.goNamed` / `pushNamed`.
  Map<String, String> toPathParameters() => {'id': id};

  /// Reconstructs the args inside a route `builder` from [state].
  factory UserRouteArgs.fromState(GoRouterState state) => UserRouteArgs(
    id: state.pathParameters['id']!,
    user: state.extra is User ? state.extra! as User : null,
  );
}
