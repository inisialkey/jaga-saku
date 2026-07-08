class ListAPI {
  ListAPI._(); // coverage:ignore-line

  /// Auth (`/auth/*`)
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  /// Users (`/users`, Bearer required)
  static const String users = '/users';

  /// Detail / update / delete for a single user: `/users/{id}`.
  static String userById(String id) => '/users/$id';

  /// Multipart file upload (`POST /upload`, Bearer required, field name `file`).
  static const String upload = '/upload';

  /// App remote config + feature flags (`GET /config`, public). Response
  /// `data.feature_flags` is a `{ key: bool }` map evaluated for the caller.
  static const String config = '/config';
}
