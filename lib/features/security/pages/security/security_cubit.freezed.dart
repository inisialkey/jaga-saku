// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SecurityState {

 LockConfig get config; bool get biometricAvailable; bool get busy;
/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecurityStateCopyWith<SecurityState> get copyWith => _$SecurityStateCopyWithImpl<SecurityState>(this as SecurityState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecurityState&&(identical(other.config, config) || other.config == config)&&(identical(other.biometricAvailable, biometricAvailable) || other.biometricAvailable == biometricAvailable)&&(identical(other.busy, busy) || other.busy == busy));
}


@override
int get hashCode => Object.hash(runtimeType,config,biometricAvailable,busy);

@override
String toString() {
  return 'SecurityState(config: $config, biometricAvailable: $biometricAvailable, busy: $busy)';
}


}

/// @nodoc
abstract mixin class $SecurityStateCopyWith<$Res>  {
  factory $SecurityStateCopyWith(SecurityState value, $Res Function(SecurityState) _then) = _$SecurityStateCopyWithImpl;
@useResult
$Res call({
 LockConfig config, bool biometricAvailable, bool busy
});


$LockConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$SecurityStateCopyWithImpl<$Res>
    implements $SecurityStateCopyWith<$Res> {
  _$SecurityStateCopyWithImpl(this._self, this._then);

  final SecurityState _self;
  final $Res Function(SecurityState) _then;

/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? config = null,Object? biometricAvailable = null,Object? busy = null,}) {
  return _then(_self.copyWith(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as LockConfig,biometricAvailable: null == biometricAvailable ? _self.biometricAvailable : biometricAvailable // ignore: cast_nullable_to_non_nullable
as bool,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LockConfigCopyWith<$Res> get config {
  
  return $LockConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [SecurityState].
extension SecurityStatePatterns on SecurityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecurityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecurityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecurityState value)  $default,){
final _that = this;
switch (_that) {
case _SecurityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecurityState value)?  $default,){
final _that = this;
switch (_that) {
case _SecurityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LockConfig config,  bool biometricAvailable,  bool busy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecurityState() when $default != null:
return $default(_that.config,_that.biometricAvailable,_that.busy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LockConfig config,  bool biometricAvailable,  bool busy)  $default,) {final _that = this;
switch (_that) {
case _SecurityState():
return $default(_that.config,_that.biometricAvailable,_that.busy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LockConfig config,  bool biometricAvailable,  bool busy)?  $default,) {final _that = this;
switch (_that) {
case _SecurityState() when $default != null:
return $default(_that.config,_that.biometricAvailable,_that.busy);case _:
  return null;

}
}

}

/// @nodoc


class _SecurityState implements SecurityState {
  const _SecurityState({this.config = const LockConfig(), this.biometricAvailable = false, this.busy = false});
  

@override@JsonKey() final  LockConfig config;
@override@JsonKey() final  bool biometricAvailable;
@override@JsonKey() final  bool busy;

/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecurityStateCopyWith<_SecurityState> get copyWith => __$SecurityStateCopyWithImpl<_SecurityState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecurityState&&(identical(other.config, config) || other.config == config)&&(identical(other.biometricAvailable, biometricAvailable) || other.biometricAvailable == biometricAvailable)&&(identical(other.busy, busy) || other.busy == busy));
}


@override
int get hashCode => Object.hash(runtimeType,config,biometricAvailable,busy);

@override
String toString() {
  return 'SecurityState(config: $config, biometricAvailable: $biometricAvailable, busy: $busy)';
}


}

/// @nodoc
abstract mixin class _$SecurityStateCopyWith<$Res> implements $SecurityStateCopyWith<$Res> {
  factory _$SecurityStateCopyWith(_SecurityState value, $Res Function(_SecurityState) _then) = __$SecurityStateCopyWithImpl;
@override @useResult
$Res call({
 LockConfig config, bool biometricAvailable, bool busy
});


@override $LockConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$SecurityStateCopyWithImpl<$Res>
    implements _$SecurityStateCopyWith<$Res> {
  __$SecurityStateCopyWithImpl(this._self, this._then);

  final _SecurityState _self;
  final $Res Function(_SecurityState) _then;

/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? config = null,Object? biometricAvailable = null,Object? busy = null,}) {
  return _then(_SecurityState(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as LockConfig,biometricAvailable: null == biometricAvailable ? _self.biometricAvailable : biometricAvailable // ignore: cast_nullable_to_non_nullable
as bool,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LockConfigCopyWith<$Res> get config {
  
  return $LockConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
