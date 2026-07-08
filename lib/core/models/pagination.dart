import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

/// List-endpoint pagination block from the response envelope's `meta`.
///
/// Wire shape (snake_case): `{ page, limit, total, total_pages, has_next,
/// has_prev }`.
@freezed
sealed class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    @JsonKey(name: 'page') @Default(1) int page,
    @JsonKey(name: 'limit') @Default(20) int limit,
    @JsonKey(name: 'total') @Default(0) int total,
    @JsonKey(name: 'total_pages') @Default(0) int totalPages,
    @JsonKey(name: 'has_next') @Default(false) bool hasNext,
    @JsonKey(name: 'has_prev') @Default(false) bool hasPrev,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
}

/// A page of `T` items plus its [PaginationMeta].
///
/// Hand-written (not freezed) so it can stay generic without freezed's
/// generic-argument-factory boilerplate; items are decoded by the caller.
class Page<T> {
  final List<T> items;
  final PaginationMeta meta;

  const Page({required this.items, required this.meta});

  /// Builds a [Page] from a success envelope whose `data` is a `T[]` and whose
  /// `meta` is the pagination block. [fromJsonT] decodes each item.
  factory Page.fromEnvelope(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawData = json['data'];
    final items = rawData is List ? rawData.map(fromJsonT).toList() : <T>[];
    final rawMeta = json['meta'];
    final meta = rawMeta is Map<String, dynamic>
        ? PaginationMeta.fromJson(rawMeta)
        : const PaginationMeta();
    return Page<T>(items: items, meta: meta);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Page<T>) return false;
    if (other.meta != meta || other.items.length != items.length) return false;
    for (var i = 0; i < items.length; i++) {
      if (items[i] != other.items[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(items), meta);
}
