import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

abstract class UsersRemoteDatasource {
  Future<Either<Failure, Page<User>>> getUsers({
    int page,
    int limit,
    String? search,
  });

  Future<Either<Failure, User>> getUser(String id);

  Future<Either<Failure, User>> updateUser(
    String id, {
    String? name,
    String? phone,
    String? avatarUrl,
  });

  Future<Either<Failure, void>> deleteUser(String id);
}

class UsersRemoteDatasourceImpl implements UsersRemoteDatasource {
  final DioClient _client;
  final CacheStore _cache;

  UsersRemoteDatasourceImpl(this._client, this._cache);

  /// Cache key for the default (page 1, no search) users list — the page shown
  /// offline. Other pages / searches are not cached.
  static const String _usersCacheKey = 'users_page_1';

  @override
  Future<Either<Failure, Page<User>>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final isDefaultPage = page == 1 && (search == null || search.isEmpty);

    Page<User> parse(Map<String, dynamic> envelope) => Page<User>.fromEnvelope(
      envelope,
      (json) => UserModel.fromJson(json! as Map<String, dynamic>).toEntity(),
    );

    final result = await _client.getRequest<Page<User>>(
      ListAPI.users,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
      converter: (response) {
        final envelope = response! as Map<String, dynamic>;
        // Network-first: cache the default page for later offline fallback.
        if (isDefaultPage) unawaited(_cache.write(_usersCacheKey, envelope));
        return parse(envelope);
      },
    );

    // Network failed (offline / server) — serve the cached list if present.
    return result.fold((failure) {
      if (isDefaultPage) {
        final cached = _cache.read(_usersCacheKey);
        if (cached != null) return Right(parse(cached));
      }
      return Left(failure);
    }, Right.new);
  }

  @override
  Future<Either<Failure, User>> getUser(String id) =>
      _client.getRequest(ListAPI.userById(id), converter: _userConverter);

  @override
  Future<Either<Failure, User>> updateUser(
    String id, {
    String? name,
    String? phone,
    String? avatarUrl,
  }) => _client.putRequest(
    ListAPI.userById(id),
    data: {
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    },
    converter: _userConverter,
  );

  @override
  Future<Either<Failure, void>> deleteUser(String id) =>
      _client.deleteRequest<void>(
        ListAPI.userById(id),
        // DELETE returns `data: null`; nothing to decode.
        converter: (_) {},
      );

  /// Parses the success envelope for a single user and returns its `data` as
  /// a [User] entity. Falls back to a [ServerFailure] (caught by DioClient)
  /// when `data` is missing.
  User _userConverter(Object? response) {
    final envelope = ApiResponse<UserModel>.fromJson(
      response! as Map<String, dynamic>,
      (data) => UserModel.fromJson(data! as Map<String, dynamic>),
    );
    final data = envelope.data;
    if (data == null) {
      throw const ServerFailure('User response missing data');
    }
    return data.toEntity();
  }
}
