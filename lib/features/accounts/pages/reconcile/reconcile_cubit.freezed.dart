// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reconcile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReconcileState {

 int get currentBalance; int? get counted; ReconcileStatus get status; Failure? get error;/// False until [ReconcileCubit.load] resolves BOTH reserved ids. When false
/// (a botched migration) confirm is disabled and confirm() is a no-op + log
/// (C5) — the sheet never writes an untagged correction.
 bool get systemReady;
/// Create a copy of ReconcileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReconcileStateCopyWith<ReconcileState> get copyWith => _$ReconcileStateCopyWithImpl<ReconcileState>(this as ReconcileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReconcileState&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.counted, counted) || other.counted == counted)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.systemReady, systemReady) || other.systemReady == systemReady));
}


@override
int get hashCode => Object.hash(runtimeType,currentBalance,counted,status,error,systemReady);

@override
String toString() {
  return 'ReconcileState(currentBalance: $currentBalance, counted: $counted, status: $status, error: $error, systemReady: $systemReady)';
}


}

/// @nodoc
abstract mixin class $ReconcileStateCopyWith<$Res>  {
  factory $ReconcileStateCopyWith(ReconcileState value, $Res Function(ReconcileState) _then) = _$ReconcileStateCopyWithImpl;
@useResult
$Res call({
 int currentBalance, int? counted, ReconcileStatus status, Failure? error, bool systemReady
});




}
/// @nodoc
class _$ReconcileStateCopyWithImpl<$Res>
    implements $ReconcileStateCopyWith<$Res> {
  _$ReconcileStateCopyWithImpl(this._self, this._then);

  final ReconcileState _self;
  final $Res Function(ReconcileState) _then;

/// Create a copy of ReconcileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentBalance = null,Object? counted = freezed,Object? status = null,Object? error = freezed,Object? systemReady = null,}) {
  return _then(_self.copyWith(
currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as int,counted: freezed == counted ? _self.counted : counted // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReconcileStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,systemReady: null == systemReady ? _self.systemReady : systemReady // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReconcileState].
extension ReconcileStatePatterns on ReconcileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReconcileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReconcileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReconcileState value)  $default,){
final _that = this;
switch (_that) {
case _ReconcileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReconcileState value)?  $default,){
final _that = this;
switch (_that) {
case _ReconcileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentBalance,  int? counted,  ReconcileStatus status,  Failure? error,  bool systemReady)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReconcileState() when $default != null:
return $default(_that.currentBalance,_that.counted,_that.status,_that.error,_that.systemReady);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentBalance,  int? counted,  ReconcileStatus status,  Failure? error,  bool systemReady)  $default,) {final _that = this;
switch (_that) {
case _ReconcileState():
return $default(_that.currentBalance,_that.counted,_that.status,_that.error,_that.systemReady);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentBalance,  int? counted,  ReconcileStatus status,  Failure? error,  bool systemReady)?  $default,) {final _that = this;
switch (_that) {
case _ReconcileState() when $default != null:
return $default(_that.currentBalance,_that.counted,_that.status,_that.error,_that.systemReady);case _:
  return null;

}
}

}

/// @nodoc


class _ReconcileState extends ReconcileState {
  const _ReconcileState({required this.currentBalance, this.counted, this.status = ReconcileStatus.editing, this.error, this.systemReady = false}): super._();
  

@override final  int currentBalance;
@override final  int? counted;
@override@JsonKey() final  ReconcileStatus status;
@override final  Failure? error;
/// False until [ReconcileCubit.load] resolves BOTH reserved ids. When false
/// (a botched migration) confirm is disabled and confirm() is a no-op + log
/// (C5) — the sheet never writes an untagged correction.
@override@JsonKey() final  bool systemReady;

/// Create a copy of ReconcileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReconcileStateCopyWith<_ReconcileState> get copyWith => __$ReconcileStateCopyWithImpl<_ReconcileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReconcileState&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.counted, counted) || other.counted == counted)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.systemReady, systemReady) || other.systemReady == systemReady));
}


@override
int get hashCode => Object.hash(runtimeType,currentBalance,counted,status,error,systemReady);

@override
String toString() {
  return 'ReconcileState(currentBalance: $currentBalance, counted: $counted, status: $status, error: $error, systemReady: $systemReady)';
}


}

/// @nodoc
abstract mixin class _$ReconcileStateCopyWith<$Res> implements $ReconcileStateCopyWith<$Res> {
  factory _$ReconcileStateCopyWith(_ReconcileState value, $Res Function(_ReconcileState) _then) = __$ReconcileStateCopyWithImpl;
@override @useResult
$Res call({
 int currentBalance, int? counted, ReconcileStatus status, Failure? error, bool systemReady
});




}
/// @nodoc
class __$ReconcileStateCopyWithImpl<$Res>
    implements _$ReconcileStateCopyWith<$Res> {
  __$ReconcileStateCopyWithImpl(this._self, this._then);

  final _ReconcileState _self;
  final $Res Function(_ReconcileState) _then;

/// Create a copy of ReconcileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentBalance = null,Object? counted = freezed,Object? status = null,Object? error = freezed,Object? systemReady = null,}) {
  return _then(_ReconcileState(
currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as int,counted: freezed == counted ? _self.counted : counted // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReconcileStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,systemReady: null == systemReady ? _self.systemReady : systemReady // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
