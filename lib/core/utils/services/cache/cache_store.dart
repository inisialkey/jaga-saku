import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';

/// Tiny JSON cache over a dedicated Hive box, used for offline fallback of GET
/// responses.
///
/// Values are stored as JSON strings (not raw maps) so nested objects
/// round-trip as `Map<String, dynamic>` — Hive otherwise returns
/// `Map<dynamic, dynamic>`, which breaks `as Map<String, dynamic>` casts in
/// the model decoders. Each entry carries a timestamp for an optional TTL.
class CacheStore {
  CacheStore(this._box);

  final Box _box;

  static const String _boxName = 'cache';

  /// Opens the cache box (optionally [prefix]ed for test isolation) and returns
  /// a store. Call once from the DI bootstrap.
  static Future<CacheStore> open([String prefix = '']) async {
    final box = await Hive.openBox('$prefix$_boxName');
    return CacheStore(box);
  }

  /// Caches [value] under [key] with the current timestamp.
  Future<void> write(String key, Map<String, dynamic> value) {
    final entry = jsonEncode({
      '_cachedAt': DateTime.now().millisecondsSinceEpoch,
      'data': value,
    });
    return _box.put(key, entry);
  }

  /// Returns the cached value for [key], or `null` when absent, unparseable, or
  /// (when [maxAge] is given) older than [maxAge].
  Map<String, dynamic>? read(String key, {Duration? maxAge}) {
    final raw = _box.get(key);
    if (raw is! String) return null;

    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      return null;
    }
    if (decoded is! Map<String, dynamic>) return null;

    if (maxAge != null) {
      final cachedAt = decoded['_cachedAt'];
      if (cachedAt is! int) return null;
      final age = DateTime.now().millisecondsSinceEpoch - cachedAt;
      if (age > maxAge.inMilliseconds) return null;
    }

    final data = decoded['data'];
    return data is Map<String, dynamic> ? data : null;
  }

  /// Drops everything (e.g. on logout).
  Future<void> clear() => _box.clear();
}
