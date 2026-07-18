// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReminderState {

 bool get dailyEnabled;/// Hour/minute of the daily nudge (default 20:00).
 int get dailyHour; int get dailyMinute; bool get recurringDueEnabled; bool get budgetWarningEnabled;/// Set true when the last enable was blocked by an OS permission denial;
/// cleared on the next successful toggle.
 bool get permissionDenied;
/// Create a copy of ReminderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderStateCopyWith<ReminderState> get copyWith => _$ReminderStateCopyWithImpl<ReminderState>(this as ReminderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderState&&(identical(other.dailyEnabled, dailyEnabled) || other.dailyEnabled == dailyEnabled)&&(identical(other.dailyHour, dailyHour) || other.dailyHour == dailyHour)&&(identical(other.dailyMinute, dailyMinute) || other.dailyMinute == dailyMinute)&&(identical(other.recurringDueEnabled, recurringDueEnabled) || other.recurringDueEnabled == recurringDueEnabled)&&(identical(other.budgetWarningEnabled, budgetWarningEnabled) || other.budgetWarningEnabled == budgetWarningEnabled)&&(identical(other.permissionDenied, permissionDenied) || other.permissionDenied == permissionDenied));
}


@override
int get hashCode => Object.hash(runtimeType,dailyEnabled,dailyHour,dailyMinute,recurringDueEnabled,budgetWarningEnabled,permissionDenied);

@override
String toString() {
  return 'ReminderState(dailyEnabled: $dailyEnabled, dailyHour: $dailyHour, dailyMinute: $dailyMinute, recurringDueEnabled: $recurringDueEnabled, budgetWarningEnabled: $budgetWarningEnabled, permissionDenied: $permissionDenied)';
}


}

/// @nodoc
abstract mixin class $ReminderStateCopyWith<$Res>  {
  factory $ReminderStateCopyWith(ReminderState value, $Res Function(ReminderState) _then) = _$ReminderStateCopyWithImpl;
@useResult
$Res call({
 bool dailyEnabled, int dailyHour, int dailyMinute, bool recurringDueEnabled, bool budgetWarningEnabled, bool permissionDenied
});




}
/// @nodoc
class _$ReminderStateCopyWithImpl<$Res>
    implements $ReminderStateCopyWith<$Res> {
  _$ReminderStateCopyWithImpl(this._self, this._then);

  final ReminderState _self;
  final $Res Function(ReminderState) _then;

/// Create a copy of ReminderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dailyEnabled = null,Object? dailyHour = null,Object? dailyMinute = null,Object? recurringDueEnabled = null,Object? budgetWarningEnabled = null,Object? permissionDenied = null,}) {
  return _then(_self.copyWith(
dailyEnabled: null == dailyEnabled ? _self.dailyEnabled : dailyEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailyHour: null == dailyHour ? _self.dailyHour : dailyHour // ignore: cast_nullable_to_non_nullable
as int,dailyMinute: null == dailyMinute ? _self.dailyMinute : dailyMinute // ignore: cast_nullable_to_non_nullable
as int,recurringDueEnabled: null == recurringDueEnabled ? _self.recurringDueEnabled : recurringDueEnabled // ignore: cast_nullable_to_non_nullable
as bool,budgetWarningEnabled: null == budgetWarningEnabled ? _self.budgetWarningEnabled : budgetWarningEnabled // ignore: cast_nullable_to_non_nullable
as bool,permissionDenied: null == permissionDenied ? _self.permissionDenied : permissionDenied // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderState].
extension ReminderStatePatterns on ReminderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderState value)  $default,){
final _that = this;
switch (_that) {
case _ReminderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderState value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool dailyEnabled,  int dailyHour,  int dailyMinute,  bool recurringDueEnabled,  bool budgetWarningEnabled,  bool permissionDenied)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderState() when $default != null:
return $default(_that.dailyEnabled,_that.dailyHour,_that.dailyMinute,_that.recurringDueEnabled,_that.budgetWarningEnabled,_that.permissionDenied);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool dailyEnabled,  int dailyHour,  int dailyMinute,  bool recurringDueEnabled,  bool budgetWarningEnabled,  bool permissionDenied)  $default,) {final _that = this;
switch (_that) {
case _ReminderState():
return $default(_that.dailyEnabled,_that.dailyHour,_that.dailyMinute,_that.recurringDueEnabled,_that.budgetWarningEnabled,_that.permissionDenied);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool dailyEnabled,  int dailyHour,  int dailyMinute,  bool recurringDueEnabled,  bool budgetWarningEnabled,  bool permissionDenied)?  $default,) {final _that = this;
switch (_that) {
case _ReminderState() when $default != null:
return $default(_that.dailyEnabled,_that.dailyHour,_that.dailyMinute,_that.recurringDueEnabled,_that.budgetWarningEnabled,_that.permissionDenied);case _:
  return null;

}
}

}

/// @nodoc


class _ReminderState implements ReminderState {
  const _ReminderState({this.dailyEnabled = false, this.dailyHour = 20, this.dailyMinute = 0, this.recurringDueEnabled = false, this.budgetWarningEnabled = false, this.permissionDenied = false});
  

@override@JsonKey() final  bool dailyEnabled;
/// Hour/minute of the daily nudge (default 20:00).
@override@JsonKey() final  int dailyHour;
@override@JsonKey() final  int dailyMinute;
@override@JsonKey() final  bool recurringDueEnabled;
@override@JsonKey() final  bool budgetWarningEnabled;
/// Set true when the last enable was blocked by an OS permission denial;
/// cleared on the next successful toggle.
@override@JsonKey() final  bool permissionDenied;

/// Create a copy of ReminderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderStateCopyWith<_ReminderState> get copyWith => __$ReminderStateCopyWithImpl<_ReminderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderState&&(identical(other.dailyEnabled, dailyEnabled) || other.dailyEnabled == dailyEnabled)&&(identical(other.dailyHour, dailyHour) || other.dailyHour == dailyHour)&&(identical(other.dailyMinute, dailyMinute) || other.dailyMinute == dailyMinute)&&(identical(other.recurringDueEnabled, recurringDueEnabled) || other.recurringDueEnabled == recurringDueEnabled)&&(identical(other.budgetWarningEnabled, budgetWarningEnabled) || other.budgetWarningEnabled == budgetWarningEnabled)&&(identical(other.permissionDenied, permissionDenied) || other.permissionDenied == permissionDenied));
}


@override
int get hashCode => Object.hash(runtimeType,dailyEnabled,dailyHour,dailyMinute,recurringDueEnabled,budgetWarningEnabled,permissionDenied);

@override
String toString() {
  return 'ReminderState(dailyEnabled: $dailyEnabled, dailyHour: $dailyHour, dailyMinute: $dailyMinute, recurringDueEnabled: $recurringDueEnabled, budgetWarningEnabled: $budgetWarningEnabled, permissionDenied: $permissionDenied)';
}


}

/// @nodoc
abstract mixin class _$ReminderStateCopyWith<$Res> implements $ReminderStateCopyWith<$Res> {
  factory _$ReminderStateCopyWith(_ReminderState value, $Res Function(_ReminderState) _then) = __$ReminderStateCopyWithImpl;
@override @useResult
$Res call({
 bool dailyEnabled, int dailyHour, int dailyMinute, bool recurringDueEnabled, bool budgetWarningEnabled, bool permissionDenied
});




}
/// @nodoc
class __$ReminderStateCopyWithImpl<$Res>
    implements _$ReminderStateCopyWith<$Res> {
  __$ReminderStateCopyWithImpl(this._self, this._then);

  final _ReminderState _self;
  final $Res Function(_ReminderState) _then;

/// Create a copy of ReminderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dailyEnabled = null,Object? dailyHour = null,Object? dailyMinute = null,Object? recurringDueEnabled = null,Object? budgetWarningEnabled = null,Object? permissionDenied = null,}) {
  return _then(_ReminderState(
dailyEnabled: null == dailyEnabled ? _self.dailyEnabled : dailyEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailyHour: null == dailyHour ? _self.dailyHour : dailyHour // ignore: cast_nullable_to_non_nullable
as int,dailyMinute: null == dailyMinute ? _self.dailyMinute : dailyMinute // ignore: cast_nullable_to_non_nullable
as int,recurringDueEnabled: null == recurringDueEnabled ? _self.recurringDueEnabled : recurringDueEnabled // ignore: cast_nullable_to_non_nullable
as bool,budgetWarningEnabled: null == budgetWarningEnabled ? _self.budgetWarningEnabled : budgetWarningEnabled // ignore: cast_nullable_to_non_nullable
as bool,permissionDenied: null == permissionDenied ? _self.permissionDenied : permissionDenied // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
