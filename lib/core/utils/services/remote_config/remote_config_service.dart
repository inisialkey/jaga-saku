import 'package:flutter/foundation.dart';
import 'package:jaga_saku/core/api/api.dart';

/// Extracts the `{ key: bool }` feature-flag map from the `/config` envelope
/// (`{ data: { feature_flags: {...} } }`), keeping only String→bool entries.
/// Pure + [visibleForTesting].
@visibleForTesting
Map<String, bool> featureFlagsFrom(Object? body) {
  if (body is! Map<String, dynamic>) return const {};
  final data = body['data'];
  if (data is! Map<String, dynamic>) return const {};
  final flags = data['feature_flags'];
  if (flags is! Map) return const {};
  final result = <String, bool>{};
  flags.forEach((key, value) {
    if (key is String && value is bool) result[key] = value;
  });
  return result;
}

/// Remote config / feature flags, fetched from `GET /config`.
///
/// Call [load] once at startup; gate features with [isEnabled]:
/// ```dart
/// if (sl<RemoteConfigService>().isEnabled('new_checkout_flow')) { ... }
/// ```
/// (read it from a Cubit/UseCase, not directly in a widget). [load] is
/// offline-safe — a fetch failure keeps the last-known flags, and every flag
/// defaults to its [isEnabled] fallback until the first successful load.
class RemoteConfigService {
  RemoteConfigService(this._client, {Map<String, bool>? initialFlags})
    : _flags = initialFlags ?? const {};

  final DioClient _client;
  Map<String, bool> _flags;

  Future<void> load() async {
    final result = await _client.getRequest<Map<String, bool>>(
      ListAPI.config,
      converter: featureFlagsFrom,
    );
    // Keep the last-known flags on failure (offline-safe).
    result.fold((_) {}, (flags) => _flags = flags);
  }

  /// Whether [key] is enabled. Returns [fallback] when the flag is unknown
  /// (e.g. config not yet loaded, or the key isn't published).
  bool isEnabled(String key, {bool fallback = false}) =>
      _flags[key] ?? fallback;

  /// All currently-known flags (read-only snapshot).
  Map<String, bool> get all => Map.unmodifiable(_flags);
}
