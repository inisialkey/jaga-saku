// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_users.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetUsersParams {

 int get page; int get limit; String? get search;
/// Create a copy of GetUsersParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetUsersParamsCopyWith<GetUsersParams> get copyWith => _$GetUsersParamsCopyWithImpl<GetUsersParams>(this as GetUsersParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetUsersParams&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,page,limit,search);

@override
String toString() {
  return 'GetUsersParams(page: $page, limit: $limit, search: $search)';
}


}

/// @nodoc
abstract mixin class $GetUsersParamsCopyWith<$Res>  {
  factory $GetUsersParamsCopyWith(GetUsersParams value, $Res Function(GetUsersParams) _then) = _$GetUsersParamsCopyWithImpl;
@useResult
$Res call({
 int page, int limit, String? search
});




}
/// @nodoc
class _$GetUsersParamsCopyWithImpl<$Res>
    implements $GetUsersParamsCopyWith<$Res> {
  _$GetUsersParamsCopyWithImpl(this._self, this._then);

  final GetUsersParams _self;
  final $Res Function(GetUsersParams) _then;

/// Create a copy of GetUsersParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? limit = null,Object? search = freezed,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetUsersParams].
extension GetUsersParamsPatterns on GetUsersParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetUsersParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetUsersParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetUsersParams value)  $default,){
final _that = this;
switch (_that) {
case _GetUsersParams():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetUsersParams value)?  $default,){
final _that = this;
switch (_that) {
case _GetUsersParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int limit,  String? search)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetUsersParams() when $default != null:
return $default(_that.page,_that.limit,_that.search);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int limit,  String? search)  $default,) {final _that = this;
switch (_that) {
case _GetUsersParams():
return $default(_that.page,_that.limit,_that.search);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int limit,  String? search)?  $default,) {final _that = this;
switch (_that) {
case _GetUsersParams() when $default != null:
return $default(_that.page,_that.limit,_that.search);case _:
  return null;

}
}

}

/// @nodoc


class _GetUsersParams implements GetUsersParams {
  const _GetUsersParams({this.page = 1, this.limit = 20, this.search});
  

@override@JsonKey() final  int page;
@override@JsonKey() final  int limit;
@override final  String? search;

/// Create a copy of GetUsersParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetUsersParamsCopyWith<_GetUsersParams> get copyWith => __$GetUsersParamsCopyWithImpl<_GetUsersParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetUsersParams&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,page,limit,search);

@override
String toString() {
  return 'GetUsersParams(page: $page, limit: $limit, search: $search)';
}


}

/// @nodoc
abstract mixin class _$GetUsersParamsCopyWith<$Res> implements $GetUsersParamsCopyWith<$Res> {
  factory _$GetUsersParamsCopyWith(_GetUsersParams value, $Res Function(_GetUsersParams) _then) = __$GetUsersParamsCopyWithImpl;
@override @useResult
$Res call({
 int page, int limit, String? search
});




}
/// @nodoc
class __$GetUsersParamsCopyWithImpl<$Res>
    implements _$GetUsersParamsCopyWith<$Res> {
  __$GetUsersParamsCopyWithImpl(this._self, this._then);

  final _GetUsersParams _self;
  final $Res Function(_GetUsersParams) _then;

/// Create a copy of GetUsersParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? limit = null,Object? search = freezed,}) {
  return _then(_GetUsersParams(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
