// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_csv_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportCsvResult {

 String get content; int get rowCount;
/// Create a copy of ExportCsvResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportCsvResultCopyWith<ExportCsvResult> get copyWith => _$ExportCsvResultCopyWithImpl<ExportCsvResult>(this as ExportCsvResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportCsvResult&&(identical(other.content, content) || other.content == content)&&(identical(other.rowCount, rowCount) || other.rowCount == rowCount));
}


@override
int get hashCode => Object.hash(runtimeType,content,rowCount);

@override
String toString() {
  return 'ExportCsvResult(content: $content, rowCount: $rowCount)';
}


}

/// @nodoc
abstract mixin class $ExportCsvResultCopyWith<$Res>  {
  factory $ExportCsvResultCopyWith(ExportCsvResult value, $Res Function(ExportCsvResult) _then) = _$ExportCsvResultCopyWithImpl;
@useResult
$Res call({
 String content, int rowCount
});




}
/// @nodoc
class _$ExportCsvResultCopyWithImpl<$Res>
    implements $ExportCsvResultCopyWith<$Res> {
  _$ExportCsvResultCopyWithImpl(this._self, this._then);

  final ExportCsvResult _self;
  final $Res Function(ExportCsvResult) _then;

/// Create a copy of ExportCsvResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? rowCount = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,rowCount: null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportCsvResult].
extension ExportCsvResultPatterns on ExportCsvResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportCsvResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportCsvResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportCsvResult value)  $default,){
final _that = this;
switch (_that) {
case _ExportCsvResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportCsvResult value)?  $default,){
final _that = this;
switch (_that) {
case _ExportCsvResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content,  int rowCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportCsvResult() when $default != null:
return $default(_that.content,_that.rowCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content,  int rowCount)  $default,) {final _that = this;
switch (_that) {
case _ExportCsvResult():
return $default(_that.content,_that.rowCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content,  int rowCount)?  $default,) {final _that = this;
switch (_that) {
case _ExportCsvResult() when $default != null:
return $default(_that.content,_that.rowCount);case _:
  return null;

}
}

}

/// @nodoc


class _ExportCsvResult implements ExportCsvResult {
  const _ExportCsvResult({required this.content, required this.rowCount});
  

@override final  String content;
@override final  int rowCount;

/// Create a copy of ExportCsvResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportCsvResultCopyWith<_ExportCsvResult> get copyWith => __$ExportCsvResultCopyWithImpl<_ExportCsvResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportCsvResult&&(identical(other.content, content) || other.content == content)&&(identical(other.rowCount, rowCount) || other.rowCount == rowCount));
}


@override
int get hashCode => Object.hash(runtimeType,content,rowCount);

@override
String toString() {
  return 'ExportCsvResult(content: $content, rowCount: $rowCount)';
}


}

/// @nodoc
abstract mixin class _$ExportCsvResultCopyWith<$Res> implements $ExportCsvResultCopyWith<$Res> {
  factory _$ExportCsvResultCopyWith(_ExportCsvResult value, $Res Function(_ExportCsvResult) _then) = __$ExportCsvResultCopyWithImpl;
@override @useResult
$Res call({
 String content, int rowCount
});




}
/// @nodoc
class __$ExportCsvResultCopyWithImpl<$Res>
    implements _$ExportCsvResultCopyWith<$Res> {
  __$ExportCsvResultCopyWithImpl(this._self, this._then);

  final _ExportCsvResult _self;
  final $Res Function(_ExportCsvResult) _then;

/// Create a copy of ExportCsvResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? rowCount = null,}) {
  return _then(_ExportCsvResult(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,rowCount: null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
