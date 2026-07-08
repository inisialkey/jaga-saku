import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/models/pagination.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// Generic success envelope: `{ success, message, data, meta? }`.
///
/// `data` is decoded with a caller-supplied [fromJsonT] so the same envelope
/// type serves single objects, lists, and `null` payloads (logout). `meta` is
/// present only on list endpoints and carries [PaginationMeta].
@Freezed(genericArgumentFactories: true)
sealed class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') T? data,
    @JsonKey(name: 'meta') PaginationMeta? meta,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
}

/// Error envelope sibling: `{ success:false, message, errors?, error_code, request_id }`.
///
/// Read straight off a raw error body (e.g. `DioException.response.data`) so
/// the interceptor / failure mapper can branch on [errorCode] and surface
/// [errors] (the per-field `422` map) without depending on a success-typed
/// [ApiResponse].
@freezed
sealed class ApiErrorResponse with _$ApiErrorResponse {
  const factory ApiErrorResponse({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'errors') Map<String, List<String>>? errors,
    @JsonKey(name: 'error_code') String? errorCode,
    @JsonKey(name: 'request_id') String? requestId,
  }) = _ApiErrorResponse;

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);
}
