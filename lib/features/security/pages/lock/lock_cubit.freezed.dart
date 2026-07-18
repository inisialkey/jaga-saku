// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lock_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LockState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LockState()';
}


}

/// @nodoc
class $LockStateCopyWith<$Res>  {
$LockStateCopyWith(LockState _, $Res Function(LockState) __);
}


/// Adds pattern-matching-related methods to [LockState].
extension LockStatePatterns on LockState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LockInput value)?  input,TResult Function( LockVerifying value)?  verifying,TResult Function( LockError value)?  error,TResult Function( LockCooldown value)?  cooldown,TResult Function( LockUnlocked value)?  unlocked,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LockInput() when input != null:
return input(_that);case LockVerifying() when verifying != null:
return verifying(_that);case LockError() when error != null:
return error(_that);case LockCooldown() when cooldown != null:
return cooldown(_that);case LockUnlocked() when unlocked != null:
return unlocked(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LockInput value)  input,required TResult Function( LockVerifying value)  verifying,required TResult Function( LockError value)  error,required TResult Function( LockCooldown value)  cooldown,required TResult Function( LockUnlocked value)  unlocked,}){
final _that = this;
switch (_that) {
case LockInput():
return input(_that);case LockVerifying():
return verifying(_that);case LockError():
return error(_that);case LockCooldown():
return cooldown(_that);case LockUnlocked():
return unlocked(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LockInput value)?  input,TResult? Function( LockVerifying value)?  verifying,TResult? Function( LockError value)?  error,TResult? Function( LockCooldown value)?  cooldown,TResult? Function( LockUnlocked value)?  unlocked,}){
final _that = this;
switch (_that) {
case LockInput() when input != null:
return input(_that);case LockVerifying() when verifying != null:
return verifying(_that);case LockError() when error != null:
return error(_that);case LockCooldown() when cooldown != null:
return cooldown(_that);case LockUnlocked() when unlocked != null:
return unlocked(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int enteredCount,  int failedAttempts)?  input,TResult Function()?  verifying,TResult Function( int failedAttempts)?  error,TResult Function( int untilMs,  int remainingSeconds)?  cooldown,TResult Function()?  unlocked,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LockInput() when input != null:
return input(_that.enteredCount,_that.failedAttempts);case LockVerifying() when verifying != null:
return verifying();case LockError() when error != null:
return error(_that.failedAttempts);case LockCooldown() when cooldown != null:
return cooldown(_that.untilMs,_that.remainingSeconds);case LockUnlocked() when unlocked != null:
return unlocked();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int enteredCount,  int failedAttempts)  input,required TResult Function()  verifying,required TResult Function( int failedAttempts)  error,required TResult Function( int untilMs,  int remainingSeconds)  cooldown,required TResult Function()  unlocked,}) {final _that = this;
switch (_that) {
case LockInput():
return input(_that.enteredCount,_that.failedAttempts);case LockVerifying():
return verifying();case LockError():
return error(_that.failedAttempts);case LockCooldown():
return cooldown(_that.untilMs,_that.remainingSeconds);case LockUnlocked():
return unlocked();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int enteredCount,  int failedAttempts)?  input,TResult? Function()?  verifying,TResult? Function( int failedAttempts)?  error,TResult? Function( int untilMs,  int remainingSeconds)?  cooldown,TResult? Function()?  unlocked,}) {final _that = this;
switch (_that) {
case LockInput() when input != null:
return input(_that.enteredCount,_that.failedAttempts);case LockVerifying() when verifying != null:
return verifying();case LockError() when error != null:
return error(_that.failedAttempts);case LockCooldown() when cooldown != null:
return cooldown(_that.untilMs,_that.remainingSeconds);case LockUnlocked() when unlocked != null:
return unlocked();case _:
  return null;

}
}

}

/// @nodoc


class LockInput implements LockState {
  const LockInput({this.enteredCount = 0, this.failedAttempts = 0});
  

@JsonKey() final  int enteredCount;
@JsonKey() final  int failedAttempts;

/// Create a copy of LockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LockInputCopyWith<LockInput> get copyWith => _$LockInputCopyWithImpl<LockInput>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockInput&&(identical(other.enteredCount, enteredCount) || other.enteredCount == enteredCount)&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts));
}


@override
int get hashCode => Object.hash(runtimeType,enteredCount,failedAttempts);

@override
String toString() {
  return 'LockState.input(enteredCount: $enteredCount, failedAttempts: $failedAttempts)';
}


}

/// @nodoc
abstract mixin class $LockInputCopyWith<$Res> implements $LockStateCopyWith<$Res> {
  factory $LockInputCopyWith(LockInput value, $Res Function(LockInput) _then) = _$LockInputCopyWithImpl;
@useResult
$Res call({
 int enteredCount, int failedAttempts
});




}
/// @nodoc
class _$LockInputCopyWithImpl<$Res>
    implements $LockInputCopyWith<$Res> {
  _$LockInputCopyWithImpl(this._self, this._then);

  final LockInput _self;
  final $Res Function(LockInput) _then;

/// Create a copy of LockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enteredCount = null,Object? failedAttempts = null,}) {
  return _then(LockInput(
enteredCount: null == enteredCount ? _self.enteredCount : enteredCount // ignore: cast_nullable_to_non_nullable
as int,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class LockVerifying implements LockState {
  const LockVerifying();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockVerifying);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LockState.verifying()';
}


}




/// @nodoc


class LockError implements LockState {
  const LockError({this.failedAttempts = 0});
  

@JsonKey() final  int failedAttempts;

/// Create a copy of LockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LockErrorCopyWith<LockError> get copyWith => _$LockErrorCopyWithImpl<LockError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockError&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts));
}


@override
int get hashCode => Object.hash(runtimeType,failedAttempts);

@override
String toString() {
  return 'LockState.error(failedAttempts: $failedAttempts)';
}


}

/// @nodoc
abstract mixin class $LockErrorCopyWith<$Res> implements $LockStateCopyWith<$Res> {
  factory $LockErrorCopyWith(LockError value, $Res Function(LockError) _then) = _$LockErrorCopyWithImpl;
@useResult
$Res call({
 int failedAttempts
});




}
/// @nodoc
class _$LockErrorCopyWithImpl<$Res>
    implements $LockErrorCopyWith<$Res> {
  _$LockErrorCopyWithImpl(this._self, this._then);

  final LockError _self;
  final $Res Function(LockError) _then;

/// Create a copy of LockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failedAttempts = null,}) {
  return _then(LockError(
failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class LockCooldown implements LockState {
  const LockCooldown({required this.untilMs, required this.remainingSeconds});
  

 final  int untilMs;
 final  int remainingSeconds;

/// Create a copy of LockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LockCooldownCopyWith<LockCooldown> get copyWith => _$LockCooldownCopyWithImpl<LockCooldown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockCooldown&&(identical(other.untilMs, untilMs) || other.untilMs == untilMs)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,untilMs,remainingSeconds);

@override
String toString() {
  return 'LockState.cooldown(untilMs: $untilMs, remainingSeconds: $remainingSeconds)';
}


}

/// @nodoc
abstract mixin class $LockCooldownCopyWith<$Res> implements $LockStateCopyWith<$Res> {
  factory $LockCooldownCopyWith(LockCooldown value, $Res Function(LockCooldown) _then) = _$LockCooldownCopyWithImpl;
@useResult
$Res call({
 int untilMs, int remainingSeconds
});




}
/// @nodoc
class _$LockCooldownCopyWithImpl<$Res>
    implements $LockCooldownCopyWith<$Res> {
  _$LockCooldownCopyWithImpl(this._self, this._then);

  final LockCooldown _self;
  final $Res Function(LockCooldown) _then;

/// Create a copy of LockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? untilMs = null,Object? remainingSeconds = null,}) {
  return _then(LockCooldown(
untilMs: null == untilMs ? _self.untilMs : untilMs // ignore: cast_nullable_to_non_nullable
as int,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class LockUnlocked implements LockState {
  const LockUnlocked();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockUnlocked);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LockState.unlocked()';
}


}




// dart format on
