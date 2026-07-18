// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_check.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinCheck {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinCheck);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinCheck()';
}


}

/// @nodoc
class $PinCheckCopyWith<$Res>  {
$PinCheckCopyWith(PinCheck _, $Res Function(PinCheck) __);
}


/// Adds pattern-matching-related methods to [PinCheck].
extension PinCheckPatterns on PinCheck {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PinCheckOk value)?  ok,TResult Function( PinCheckWrong value)?  wrong,TResult Function( PinCheckLockedOut value)?  lockedOut,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PinCheckOk() when ok != null:
return ok(_that);case PinCheckWrong() when wrong != null:
return wrong(_that);case PinCheckLockedOut() when lockedOut != null:
return lockedOut(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PinCheckOk value)  ok,required TResult Function( PinCheckWrong value)  wrong,required TResult Function( PinCheckLockedOut value)  lockedOut,}){
final _that = this;
switch (_that) {
case PinCheckOk():
return ok(_that);case PinCheckWrong():
return wrong(_that);case PinCheckLockedOut():
return lockedOut(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PinCheckOk value)?  ok,TResult? Function( PinCheckWrong value)?  wrong,TResult? Function( PinCheckLockedOut value)?  lockedOut,}){
final _that = this;
switch (_that) {
case PinCheckOk() when ok != null:
return ok(_that);case PinCheckWrong() when wrong != null:
return wrong(_that);case PinCheckLockedOut() when lockedOut != null:
return lockedOut(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  ok,TResult Function( int failedAttempts,  int? cooldownUntilMs)?  wrong,TResult Function( int cooldownUntilMs)?  lockedOut,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PinCheckOk() when ok != null:
return ok();case PinCheckWrong() when wrong != null:
return wrong(_that.failedAttempts,_that.cooldownUntilMs);case PinCheckLockedOut() when lockedOut != null:
return lockedOut(_that.cooldownUntilMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  ok,required TResult Function( int failedAttempts,  int? cooldownUntilMs)  wrong,required TResult Function( int cooldownUntilMs)  lockedOut,}) {final _that = this;
switch (_that) {
case PinCheckOk():
return ok();case PinCheckWrong():
return wrong(_that.failedAttempts,_that.cooldownUntilMs);case PinCheckLockedOut():
return lockedOut(_that.cooldownUntilMs);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  ok,TResult? Function( int failedAttempts,  int? cooldownUntilMs)?  wrong,TResult? Function( int cooldownUntilMs)?  lockedOut,}) {final _that = this;
switch (_that) {
case PinCheckOk() when ok != null:
return ok();case PinCheckWrong() when wrong != null:
return wrong(_that.failedAttempts,_that.cooldownUntilMs);case PinCheckLockedOut() when lockedOut != null:
return lockedOut(_that.cooldownUntilMs);case _:
  return null;

}
}

}

/// @nodoc


class PinCheckOk implements PinCheck {
  const PinCheckOk();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinCheckOk);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinCheck.ok()';
}


}




/// @nodoc


class PinCheckWrong implements PinCheck {
  const PinCheckWrong({required this.failedAttempts, this.cooldownUntilMs});
  

 final  int failedAttempts;
 final  int? cooldownUntilMs;

/// Create a copy of PinCheck
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinCheckWrongCopyWith<PinCheckWrong> get copyWith => _$PinCheckWrongCopyWithImpl<PinCheckWrong>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinCheckWrong&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts)&&(identical(other.cooldownUntilMs, cooldownUntilMs) || other.cooldownUntilMs == cooldownUntilMs));
}


@override
int get hashCode => Object.hash(runtimeType,failedAttempts,cooldownUntilMs);

@override
String toString() {
  return 'PinCheck.wrong(failedAttempts: $failedAttempts, cooldownUntilMs: $cooldownUntilMs)';
}


}

/// @nodoc
abstract mixin class $PinCheckWrongCopyWith<$Res> implements $PinCheckCopyWith<$Res> {
  factory $PinCheckWrongCopyWith(PinCheckWrong value, $Res Function(PinCheckWrong) _then) = _$PinCheckWrongCopyWithImpl;
@useResult
$Res call({
 int failedAttempts, int? cooldownUntilMs
});




}
/// @nodoc
class _$PinCheckWrongCopyWithImpl<$Res>
    implements $PinCheckWrongCopyWith<$Res> {
  _$PinCheckWrongCopyWithImpl(this._self, this._then);

  final PinCheckWrong _self;
  final $Res Function(PinCheckWrong) _then;

/// Create a copy of PinCheck
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failedAttempts = null,Object? cooldownUntilMs = freezed,}) {
  return _then(PinCheckWrong(
failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,cooldownUntilMs: freezed == cooldownUntilMs ? _self.cooldownUntilMs : cooldownUntilMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class PinCheckLockedOut implements PinCheck {
  const PinCheckLockedOut({required this.cooldownUntilMs});
  

 final  int cooldownUntilMs;

/// Create a copy of PinCheck
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinCheckLockedOutCopyWith<PinCheckLockedOut> get copyWith => _$PinCheckLockedOutCopyWithImpl<PinCheckLockedOut>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinCheckLockedOut&&(identical(other.cooldownUntilMs, cooldownUntilMs) || other.cooldownUntilMs == cooldownUntilMs));
}


@override
int get hashCode => Object.hash(runtimeType,cooldownUntilMs);

@override
String toString() {
  return 'PinCheck.lockedOut(cooldownUntilMs: $cooldownUntilMs)';
}


}

/// @nodoc
abstract mixin class $PinCheckLockedOutCopyWith<$Res> implements $PinCheckCopyWith<$Res> {
  factory $PinCheckLockedOutCopyWith(PinCheckLockedOut value, $Res Function(PinCheckLockedOut) _then) = _$PinCheckLockedOutCopyWithImpl;
@useResult
$Res call({
 int cooldownUntilMs
});




}
/// @nodoc
class _$PinCheckLockedOutCopyWithImpl<$Res>
    implements $PinCheckLockedOutCopyWith<$Res> {
  _$PinCheckLockedOutCopyWithImpl(this._self, this._then);

  final PinCheckLockedOut _self;
  final $Res Function(PinCheckLockedOut) _then;

/// Create a copy of PinCheck
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cooldownUntilMs = null,}) {
  return _then(PinCheckLockedOut(
cooldownUntilMs: null == cooldownUntilMs ? _self.cooldownUntilMs : cooldownUntilMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
