// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateUserParams {

 String get id; String? get name; String? get phone; String? get avatarUrl;
/// Create a copy of UpdateUserParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateUserParamsCopyWith<UpdateUserParams> get copyWith => _$UpdateUserParamsCopyWithImpl<UpdateUserParams>(this as UpdateUserParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateUserParams&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,phone,avatarUrl);

@override
String toString() {
  return 'UpdateUserParams(id: $id, name: $name, phone: $phone, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $UpdateUserParamsCopyWith<$Res>  {
  factory $UpdateUserParamsCopyWith(UpdateUserParams value, $Res Function(UpdateUserParams) _then) = _$UpdateUserParamsCopyWithImpl;
@useResult
$Res call({
 String id, String? name, String? phone, String? avatarUrl
});




}
/// @nodoc
class _$UpdateUserParamsCopyWithImpl<$Res>
    implements $UpdateUserParamsCopyWith<$Res> {
  _$UpdateUserParamsCopyWithImpl(this._self, this._then);

  final UpdateUserParams _self;
  final $Res Function(UpdateUserParams) _then;

/// Create a copy of UpdateUserParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? phone = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateUserParams].
extension UpdateUserParamsPatterns on UpdateUserParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateUserParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateUserParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateUserParams value)  $default,){
final _that = this;
switch (_that) {
case _UpdateUserParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateUserParams value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateUserParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name,  String? phone,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateUserParams() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name,  String? phone,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _UpdateUserParams():
return $default(_that.id,_that.name,_that.phone,_that.avatarUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name,  String? phone,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _UpdateUserParams() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc


class _UpdateUserParams implements UpdateUserParams {
  const _UpdateUserParams({required this.id, this.name, this.phone, this.avatarUrl});
  

@override final  String id;
@override final  String? name;
@override final  String? phone;
@override final  String? avatarUrl;

/// Create a copy of UpdateUserParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateUserParamsCopyWith<_UpdateUserParams> get copyWith => __$UpdateUserParamsCopyWithImpl<_UpdateUserParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateUserParams&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,phone,avatarUrl);

@override
String toString() {
  return 'UpdateUserParams(id: $id, name: $name, phone: $phone, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$UpdateUserParamsCopyWith<$Res> implements $UpdateUserParamsCopyWith<$Res> {
  factory _$UpdateUserParamsCopyWith(_UpdateUserParams value, $Res Function(_UpdateUserParams) _then) = __$UpdateUserParamsCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name, String? phone, String? avatarUrl
});




}
/// @nodoc
class __$UpdateUserParamsCopyWithImpl<$Res>
    implements _$UpdateUserParamsCopyWith<$Res> {
  __$UpdateUserParamsCopyWithImpl(this._self, this._then);

  final _UpdateUserParams _self;
  final $Res Function(_UpdateUserParams) _then;

/// Create a copy of UpdateUserParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? phone = freezed,Object? avatarUrl = freezed,}) {
  return _then(_UpdateUserParams(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
