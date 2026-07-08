import 'package:freezed_annotation/freezed_annotation.dart';

/// Decodes a boolean flag that the backend may send either as a JSON boolean
/// (`true` / `false`) or as a SQLite-style integer (`1` / `0`). SQLite stores
/// boolean columns as INTEGER, and the mock API returns those rows verbatim, so
/// `is_active` arrives as `1` / `0` from the live server while test stubs use
/// `true` / `false`. Decoding an `int` into a `bool` field otherwise throws
/// `type 'int' is not a subtype of type 'bool'`.
///
/// Serializes back to a plain `bool`.
class BoolFromIntConverter implements JsonConverter<bool, Object?> {
  const BoolFromIntConverter();

  @override
  bool fromJson(Object? json) {
    if (json is bool) return json;
    if (json is num) return json != 0;
    if (json is String) return json == '1' || json.toLowerCase() == 'true';
    return false;
  }

  @override
  Object? toJson(bool object) => object;
}
