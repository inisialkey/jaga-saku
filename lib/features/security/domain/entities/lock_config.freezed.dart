// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lock_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LockConfig {

 bool get isPinEnabled; bool get isBiometricEnabled; AutoLockDuration get autoLockDuration;
/// Create a copy of LockConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LockConfigCopyWith<LockConfig> get copyWith => _$LockConfigCopyWithImpl<LockConfig>(this as LockConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockConfig&&(identical(other.isPinEnabled, isPinEnabled) || other.isPinEnabled == isPinEnabled)&&(identical(other.isBiometricEnabled, isBiometricEnabled) || other.isBiometricEnabled == isBiometricEnabled)&&(identical(other.autoLockDuration, autoLockDuration) || other.autoLockDuration == autoLockDuration));
}


@override
int get hashCode => Object.hash(runtimeType,isPinEnabled,isBiometricEnabled,autoLockDuration);

@override
String toString() {
  return 'LockConfig(isPinEnabled: $isPinEnabled, isBiometricEnabled: $isBiometricEnabled, autoLockDuration: $autoLockDuration)';
}


}

/// @nodoc
abstract mixin class $LockConfigCopyWith<$Res>  {
  factory $LockConfigCopyWith(LockConfig value, $Res Function(LockConfig) _then) = _$LockConfigCopyWithImpl;
@useResult
$Res call({
 bool isPinEnabled, bool isBiometricEnabled, AutoLockDuration autoLockDuration
});




}
/// @nodoc
class _$LockConfigCopyWithImpl<$Res>
    implements $LockConfigCopyWith<$Res> {
  _$LockConfigCopyWithImpl(this._self, this._then);

  final LockConfig _self;
  final $Res Function(LockConfig) _then;

/// Create a copy of LockConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPinEnabled = null,Object? isBiometricEnabled = null,Object? autoLockDuration = null,}) {
  return _then(_self.copyWith(
isPinEnabled: null == isPinEnabled ? _self.isPinEnabled : isPinEnabled // ignore: cast_nullable_to_non_nullable
as bool,isBiometricEnabled: null == isBiometricEnabled ? _self.isBiometricEnabled : isBiometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,autoLockDuration: null == autoLockDuration ? _self.autoLockDuration : autoLockDuration // ignore: cast_nullable_to_non_nullable
as AutoLockDuration,
  ));
}

}


/// Adds pattern-matching-related methods to [LockConfig].
extension LockConfigPatterns on LockConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LockConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LockConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LockConfig value)  $default,){
final _that = this;
switch (_that) {
case _LockConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LockConfig value)?  $default,){
final _that = this;
switch (_that) {
case _LockConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPinEnabled,  bool isBiometricEnabled,  AutoLockDuration autoLockDuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LockConfig() when $default != null:
return $default(_that.isPinEnabled,_that.isBiometricEnabled,_that.autoLockDuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPinEnabled,  bool isBiometricEnabled,  AutoLockDuration autoLockDuration)  $default,) {final _that = this;
switch (_that) {
case _LockConfig():
return $default(_that.isPinEnabled,_that.isBiometricEnabled,_that.autoLockDuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPinEnabled,  bool isBiometricEnabled,  AutoLockDuration autoLockDuration)?  $default,) {final _that = this;
switch (_that) {
case _LockConfig() when $default != null:
return $default(_that.isPinEnabled,_that.isBiometricEnabled,_that.autoLockDuration);case _:
  return null;

}
}

}

/// @nodoc


class _LockConfig implements LockConfig {
  const _LockConfig({this.isPinEnabled = false, this.isBiometricEnabled = false, this.autoLockDuration = AutoLockDuration.immediately});
  

@override@JsonKey() final  bool isPinEnabled;
@override@JsonKey() final  bool isBiometricEnabled;
@override@JsonKey() final  AutoLockDuration autoLockDuration;

/// Create a copy of LockConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LockConfigCopyWith<_LockConfig> get copyWith => __$LockConfigCopyWithImpl<_LockConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LockConfig&&(identical(other.isPinEnabled, isPinEnabled) || other.isPinEnabled == isPinEnabled)&&(identical(other.isBiometricEnabled, isBiometricEnabled) || other.isBiometricEnabled == isBiometricEnabled)&&(identical(other.autoLockDuration, autoLockDuration) || other.autoLockDuration == autoLockDuration));
}


@override
int get hashCode => Object.hash(runtimeType,isPinEnabled,isBiometricEnabled,autoLockDuration);

@override
String toString() {
  return 'LockConfig(isPinEnabled: $isPinEnabled, isBiometricEnabled: $isBiometricEnabled, autoLockDuration: $autoLockDuration)';
}


}

/// @nodoc
abstract mixin class _$LockConfigCopyWith<$Res> implements $LockConfigCopyWith<$Res> {
  factory _$LockConfigCopyWith(_LockConfig value, $Res Function(_LockConfig) _then) = __$LockConfigCopyWithImpl;
@override @useResult
$Res call({
 bool isPinEnabled, bool isBiometricEnabled, AutoLockDuration autoLockDuration
});




}
/// @nodoc
class __$LockConfigCopyWithImpl<$Res>
    implements _$LockConfigCopyWith<$Res> {
  __$LockConfigCopyWithImpl(this._self, this._then);

  final _LockConfig _self;
  final $Res Function(_LockConfig) _then;

/// Create a copy of LockConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPinEnabled = null,Object? isBiometricEnabled = null,Object? autoLockDuration = null,}) {
  return _then(_LockConfig(
isPinEnabled: null == isPinEnabled ? _self.isPinEnabled : isPinEnabled // ignore: cast_nullable_to_non_nullable
as bool,isBiometricEnabled: null == isBiometricEnabled ? _self.isBiometricEnabled : isBiometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,autoLockDuration: null == autoLockDuration ? _self.autoLockDuration : autoLockDuration // ignore: cast_nullable_to_non_nullable
as AutoLockDuration,
  ));
}


}

// dart format on
