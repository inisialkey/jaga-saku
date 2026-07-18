// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_entry_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinEntryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinEntryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinEntryState()';
}


}

/// @nodoc
class $PinEntryStateCopyWith<$Res>  {
$PinEntryStateCopyWith(PinEntryState _, $Res Function(PinEntryState) __);
}


/// Adds pattern-matching-related methods to [PinEntryState].
extension PinEntryStatePatterns on PinEntryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PinEntryVerifyCurrent value)?  verifyCurrent,TResult Function( PinEntryEnterNew value)?  enterNew,TResult Function( PinEntryConfirm value)?  confirm,TResult Function( PinEntrySubmitting value)?  submitting,TResult Function( PinEntryMismatch value)?  mismatch,TResult Function( PinEntryWrong value)?  wrong,TResult Function( PinEntryDone value)?  done,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PinEntryVerifyCurrent() when verifyCurrent != null:
return verifyCurrent(_that);case PinEntryEnterNew() when enterNew != null:
return enterNew(_that);case PinEntryConfirm() when confirm != null:
return confirm(_that);case PinEntrySubmitting() when submitting != null:
return submitting(_that);case PinEntryMismatch() when mismatch != null:
return mismatch(_that);case PinEntryWrong() when wrong != null:
return wrong(_that);case PinEntryDone() when done != null:
return done(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PinEntryVerifyCurrent value)  verifyCurrent,required TResult Function( PinEntryEnterNew value)  enterNew,required TResult Function( PinEntryConfirm value)  confirm,required TResult Function( PinEntrySubmitting value)  submitting,required TResult Function( PinEntryMismatch value)  mismatch,required TResult Function( PinEntryWrong value)  wrong,required TResult Function( PinEntryDone value)  done,}){
final _that = this;
switch (_that) {
case PinEntryVerifyCurrent():
return verifyCurrent(_that);case PinEntryEnterNew():
return enterNew(_that);case PinEntryConfirm():
return confirm(_that);case PinEntrySubmitting():
return submitting(_that);case PinEntryMismatch():
return mismatch(_that);case PinEntryWrong():
return wrong(_that);case PinEntryDone():
return done(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PinEntryVerifyCurrent value)?  verifyCurrent,TResult? Function( PinEntryEnterNew value)?  enterNew,TResult? Function( PinEntryConfirm value)?  confirm,TResult? Function( PinEntrySubmitting value)?  submitting,TResult? Function( PinEntryMismatch value)?  mismatch,TResult? Function( PinEntryWrong value)?  wrong,TResult? Function( PinEntryDone value)?  done,}){
final _that = this;
switch (_that) {
case PinEntryVerifyCurrent() when verifyCurrent != null:
return verifyCurrent(_that);case PinEntryEnterNew() when enterNew != null:
return enterNew(_that);case PinEntryConfirm() when confirm != null:
return confirm(_that);case PinEntrySubmitting() when submitting != null:
return submitting(_that);case PinEntryMismatch() when mismatch != null:
return mismatch(_that);case PinEntryWrong() when wrong != null:
return wrong(_that);case PinEntryDone() when done != null:
return done(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int enteredCount)?  verifyCurrent,TResult Function( int enteredCount)?  enterNew,TResult Function( int enteredCount)?  confirm,TResult Function()?  submitting,TResult Function()?  mismatch,TResult Function( int? cooldownUntilMs)?  wrong,TResult Function()?  done,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PinEntryVerifyCurrent() when verifyCurrent != null:
return verifyCurrent(_that.enteredCount);case PinEntryEnterNew() when enterNew != null:
return enterNew(_that.enteredCount);case PinEntryConfirm() when confirm != null:
return confirm(_that.enteredCount);case PinEntrySubmitting() when submitting != null:
return submitting();case PinEntryMismatch() when mismatch != null:
return mismatch();case PinEntryWrong() when wrong != null:
return wrong(_that.cooldownUntilMs);case PinEntryDone() when done != null:
return done();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int enteredCount)  verifyCurrent,required TResult Function( int enteredCount)  enterNew,required TResult Function( int enteredCount)  confirm,required TResult Function()  submitting,required TResult Function()  mismatch,required TResult Function( int? cooldownUntilMs)  wrong,required TResult Function()  done,}) {final _that = this;
switch (_that) {
case PinEntryVerifyCurrent():
return verifyCurrent(_that.enteredCount);case PinEntryEnterNew():
return enterNew(_that.enteredCount);case PinEntryConfirm():
return confirm(_that.enteredCount);case PinEntrySubmitting():
return submitting();case PinEntryMismatch():
return mismatch();case PinEntryWrong():
return wrong(_that.cooldownUntilMs);case PinEntryDone():
return done();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int enteredCount)?  verifyCurrent,TResult? Function( int enteredCount)?  enterNew,TResult? Function( int enteredCount)?  confirm,TResult? Function()?  submitting,TResult? Function()?  mismatch,TResult? Function( int? cooldownUntilMs)?  wrong,TResult? Function()?  done,}) {final _that = this;
switch (_that) {
case PinEntryVerifyCurrent() when verifyCurrent != null:
return verifyCurrent(_that.enteredCount);case PinEntryEnterNew() when enterNew != null:
return enterNew(_that.enteredCount);case PinEntryConfirm() when confirm != null:
return confirm(_that.enteredCount);case PinEntrySubmitting() when submitting != null:
return submitting();case PinEntryMismatch() when mismatch != null:
return mismatch();case PinEntryWrong() when wrong != null:
return wrong(_that.cooldownUntilMs);case PinEntryDone() when done != null:
return done();case _:
  return null;

}
}

}

/// @nodoc


class PinEntryVerifyCurrent implements PinEntryState {
  const PinEntryVerifyCurrent({this.enteredCount = 0});
  

@JsonKey() final  int enteredCount;

/// Create a copy of PinEntryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinEntryVerifyCurrentCopyWith<PinEntryVerifyCurrent> get copyWith => _$PinEntryVerifyCurrentCopyWithImpl<PinEntryVerifyCurrent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinEntryVerifyCurrent&&(identical(other.enteredCount, enteredCount) || other.enteredCount == enteredCount));
}


@override
int get hashCode => Object.hash(runtimeType,enteredCount);

@override
String toString() {
  return 'PinEntryState.verifyCurrent(enteredCount: $enteredCount)';
}


}

/// @nodoc
abstract mixin class $PinEntryVerifyCurrentCopyWith<$Res> implements $PinEntryStateCopyWith<$Res> {
  factory $PinEntryVerifyCurrentCopyWith(PinEntryVerifyCurrent value, $Res Function(PinEntryVerifyCurrent) _then) = _$PinEntryVerifyCurrentCopyWithImpl;
@useResult
$Res call({
 int enteredCount
});




}
/// @nodoc
class _$PinEntryVerifyCurrentCopyWithImpl<$Res>
    implements $PinEntryVerifyCurrentCopyWith<$Res> {
  _$PinEntryVerifyCurrentCopyWithImpl(this._self, this._then);

  final PinEntryVerifyCurrent _self;
  final $Res Function(PinEntryVerifyCurrent) _then;

/// Create a copy of PinEntryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enteredCount = null,}) {
  return _then(PinEntryVerifyCurrent(
enteredCount: null == enteredCount ? _self.enteredCount : enteredCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PinEntryEnterNew implements PinEntryState {
  const PinEntryEnterNew({this.enteredCount = 0});
  

@JsonKey() final  int enteredCount;

/// Create a copy of PinEntryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinEntryEnterNewCopyWith<PinEntryEnterNew> get copyWith => _$PinEntryEnterNewCopyWithImpl<PinEntryEnterNew>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinEntryEnterNew&&(identical(other.enteredCount, enteredCount) || other.enteredCount == enteredCount));
}


@override
int get hashCode => Object.hash(runtimeType,enteredCount);

@override
String toString() {
  return 'PinEntryState.enterNew(enteredCount: $enteredCount)';
}


}

/// @nodoc
abstract mixin class $PinEntryEnterNewCopyWith<$Res> implements $PinEntryStateCopyWith<$Res> {
  factory $PinEntryEnterNewCopyWith(PinEntryEnterNew value, $Res Function(PinEntryEnterNew) _then) = _$PinEntryEnterNewCopyWithImpl;
@useResult
$Res call({
 int enteredCount
});




}
/// @nodoc
class _$PinEntryEnterNewCopyWithImpl<$Res>
    implements $PinEntryEnterNewCopyWith<$Res> {
  _$PinEntryEnterNewCopyWithImpl(this._self, this._then);

  final PinEntryEnterNew _self;
  final $Res Function(PinEntryEnterNew) _then;

/// Create a copy of PinEntryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enteredCount = null,}) {
  return _then(PinEntryEnterNew(
enteredCount: null == enteredCount ? _self.enteredCount : enteredCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PinEntryConfirm implements PinEntryState {
  const PinEntryConfirm({this.enteredCount = 0});
  

@JsonKey() final  int enteredCount;

/// Create a copy of PinEntryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinEntryConfirmCopyWith<PinEntryConfirm> get copyWith => _$PinEntryConfirmCopyWithImpl<PinEntryConfirm>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinEntryConfirm&&(identical(other.enteredCount, enteredCount) || other.enteredCount == enteredCount));
}


@override
int get hashCode => Object.hash(runtimeType,enteredCount);

@override
String toString() {
  return 'PinEntryState.confirm(enteredCount: $enteredCount)';
}


}

/// @nodoc
abstract mixin class $PinEntryConfirmCopyWith<$Res> implements $PinEntryStateCopyWith<$Res> {
  factory $PinEntryConfirmCopyWith(PinEntryConfirm value, $Res Function(PinEntryConfirm) _then) = _$PinEntryConfirmCopyWithImpl;
@useResult
$Res call({
 int enteredCount
});




}
/// @nodoc
class _$PinEntryConfirmCopyWithImpl<$Res>
    implements $PinEntryConfirmCopyWith<$Res> {
  _$PinEntryConfirmCopyWithImpl(this._self, this._then);

  final PinEntryConfirm _self;
  final $Res Function(PinEntryConfirm) _then;

/// Create a copy of PinEntryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enteredCount = null,}) {
  return _then(PinEntryConfirm(
enteredCount: null == enteredCount ? _self.enteredCount : enteredCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PinEntrySubmitting implements PinEntryState {
  const PinEntrySubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinEntrySubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinEntryState.submitting()';
}


}




/// @nodoc


class PinEntryMismatch implements PinEntryState {
  const PinEntryMismatch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinEntryMismatch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinEntryState.mismatch()';
}


}




/// @nodoc


class PinEntryWrong implements PinEntryState {
  const PinEntryWrong({this.cooldownUntilMs});
  

 final  int? cooldownUntilMs;

/// Create a copy of PinEntryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinEntryWrongCopyWith<PinEntryWrong> get copyWith => _$PinEntryWrongCopyWithImpl<PinEntryWrong>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinEntryWrong&&(identical(other.cooldownUntilMs, cooldownUntilMs) || other.cooldownUntilMs == cooldownUntilMs));
}


@override
int get hashCode => Object.hash(runtimeType,cooldownUntilMs);

@override
String toString() {
  return 'PinEntryState.wrong(cooldownUntilMs: $cooldownUntilMs)';
}


}

/// @nodoc
abstract mixin class $PinEntryWrongCopyWith<$Res> implements $PinEntryStateCopyWith<$Res> {
  factory $PinEntryWrongCopyWith(PinEntryWrong value, $Res Function(PinEntryWrong) _then) = _$PinEntryWrongCopyWithImpl;
@useResult
$Res call({
 int? cooldownUntilMs
});




}
/// @nodoc
class _$PinEntryWrongCopyWithImpl<$Res>
    implements $PinEntryWrongCopyWith<$Res> {
  _$PinEntryWrongCopyWithImpl(this._self, this._then);

  final PinEntryWrong _self;
  final $Res Function(PinEntryWrong) _then;

/// Create a copy of PinEntryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cooldownUntilMs = freezed,}) {
  return _then(PinEntryWrong(
cooldownUntilMs: freezed == cooldownUntilMs ? _self.cooldownUntilMs : cooldownUntilMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class PinEntryDone implements PinEntryState {
  const PinEntryDone();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinEntryDone);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinEntryState.done()';
}


}




// dart format on
