// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingState {

 OnboardingStep get step; List<Account> get accounts; OnboardingStatus get status; Failure? get error;/// One-shot §18 duplicate-name hint. Set when a just-saved account shares
/// its (trimmed, case-insensitive) name with an existing one; the page
/// fires an info toast and calls `clearDuplicateHint`. Never blocks a save.
 String? get duplicateName;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.step, step) || other.step == step)&&const DeepCollectionEquality().equals(other.accounts, accounts)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.duplicateName, duplicateName) || other.duplicateName == duplicateName));
}


@override
int get hashCode => Object.hash(runtimeType,step,const DeepCollectionEquality().hash(accounts),status,error,duplicateName);

@override
String toString() {
  return 'OnboardingState(step: $step, accounts: $accounts, status: $status, error: $error, duplicateName: $duplicateName)';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 OnboardingStep step, List<Account> accounts, OnboardingStatus status, Failure? error, String? duplicateName
});




}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? accounts = null,Object? status = null,Object? error = freezed,Object? duplicateName = freezed,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as OnboardingStep,accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Account>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OnboardingStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,duplicateName: freezed == duplicateName ? _self.duplicateName : duplicateName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OnboardingStep step,  List<Account> accounts,  OnboardingStatus status,  Failure? error,  String? duplicateName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.step,_that.accounts,_that.status,_that.error,_that.duplicateName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OnboardingStep step,  List<Account> accounts,  OnboardingStatus status,  Failure? error,  String? duplicateName)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.step,_that.accounts,_that.status,_that.error,_that.duplicateName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OnboardingStep step,  List<Account> accounts,  OnboardingStatus status,  Failure? error,  String? duplicateName)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.step,_that.accounts,_that.status,_that.error,_that.duplicateName);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState extends OnboardingState {
  const _OnboardingState({this.step = OnboardingStep.welcome, final  List<Account> accounts = const <Account>[], this.status = OnboardingStatus.editing, this.error, this.duplicateName}): _accounts = accounts,super._();
  

@override@JsonKey() final  OnboardingStep step;
 final  List<Account> _accounts;
@override@JsonKey() List<Account> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

@override@JsonKey() final  OnboardingStatus status;
@override final  Failure? error;
/// One-shot §18 duplicate-name hint. Set when a just-saved account shares
/// its (trimmed, case-insensitive) name with an existing one; the page
/// fires an info toast and calls `clearDuplicateHint`. Never blocks a save.
@override final  String? duplicateName;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.step, step) || other.step == step)&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.duplicateName, duplicateName) || other.duplicateName == duplicateName));
}


@override
int get hashCode => Object.hash(runtimeType,step,const DeepCollectionEquality().hash(_accounts),status,error,duplicateName);

@override
String toString() {
  return 'OnboardingState(step: $step, accounts: $accounts, status: $status, error: $error, duplicateName: $duplicateName)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 OnboardingStep step, List<Account> accounts, OnboardingStatus status, Failure? error, String? duplicateName
});




}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? accounts = null,Object? status = null,Object? error = freezed,Object? duplicateName = freezed,}) {
  return _then(_OnboardingState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as OnboardingStep,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Account>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OnboardingStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,duplicateName: freezed == duplicateName ? _self.duplicateName : duplicateName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
