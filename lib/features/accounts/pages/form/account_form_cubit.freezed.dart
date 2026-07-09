// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountFormState {

 AccountType get type; String get name; int get openingBalance; String? get icon; int? get color; AccountFormStatus get status; Failure? get error; bool get isEditing;
/// Create a copy of AccountFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountFormStateCopyWith<AccountFormState> get copyWith => _$AccountFormStateCopyWithImpl<AccountFormState>(this as AccountFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountFormState&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.openingBalance, openingBalance) || other.openingBalance == openingBalance)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing));
}


@override
int get hashCode => Object.hash(runtimeType,type,name,openingBalance,icon,color,status,error,isEditing);

@override
String toString() {
  return 'AccountFormState(type: $type, name: $name, openingBalance: $openingBalance, icon: $icon, color: $color, status: $status, error: $error, isEditing: $isEditing)';
}


}

/// @nodoc
abstract mixin class $AccountFormStateCopyWith<$Res>  {
  factory $AccountFormStateCopyWith(AccountFormState value, $Res Function(AccountFormState) _then) = _$AccountFormStateCopyWithImpl;
@useResult
$Res call({
 AccountType type, String name, int openingBalance, String? icon, int? color, AccountFormStatus status, Failure? error, bool isEditing
});




}
/// @nodoc
class _$AccountFormStateCopyWithImpl<$Res>
    implements $AccountFormStateCopyWith<$Res> {
  _$AccountFormStateCopyWithImpl(this._self, this._then);

  final AccountFormState _self;
  final $Res Function(AccountFormState) _then;

/// Create a copy of AccountFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? name = null,Object? openingBalance = null,Object? icon = freezed,Object? color = freezed,Object? status = null,Object? error = freezed,Object? isEditing = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,openingBalance: null == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as int,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountFormStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountFormState].
extension AccountFormStatePatterns on AccountFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountFormState value)  $default,){
final _that = this;
switch (_that) {
case _AccountFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountFormState value)?  $default,){
final _that = this;
switch (_that) {
case _AccountFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AccountType type,  String name,  int openingBalance,  String? icon,  int? color,  AccountFormStatus status,  Failure? error,  bool isEditing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountFormState() when $default != null:
return $default(_that.type,_that.name,_that.openingBalance,_that.icon,_that.color,_that.status,_that.error,_that.isEditing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AccountType type,  String name,  int openingBalance,  String? icon,  int? color,  AccountFormStatus status,  Failure? error,  bool isEditing)  $default,) {final _that = this;
switch (_that) {
case _AccountFormState():
return $default(_that.type,_that.name,_that.openingBalance,_that.icon,_that.color,_that.status,_that.error,_that.isEditing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AccountType type,  String name,  int openingBalance,  String? icon,  int? color,  AccountFormStatus status,  Failure? error,  bool isEditing)?  $default,) {final _that = this;
switch (_that) {
case _AccountFormState() when $default != null:
return $default(_that.type,_that.name,_that.openingBalance,_that.icon,_that.color,_that.status,_that.error,_that.isEditing);case _:
  return null;

}
}

}

/// @nodoc


class _AccountFormState extends AccountFormState {
  const _AccountFormState({this.type = AccountType.cash, this.name = '', this.openingBalance = 0, this.icon, this.color, this.status = AccountFormStatus.editing, this.error, this.isEditing = false}): super._();
  

@override@JsonKey() final  AccountType type;
@override@JsonKey() final  String name;
@override@JsonKey() final  int openingBalance;
@override final  String? icon;
@override final  int? color;
@override@JsonKey() final  AccountFormStatus status;
@override final  Failure? error;
@override@JsonKey() final  bool isEditing;

/// Create a copy of AccountFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountFormStateCopyWith<_AccountFormState> get copyWith => __$AccountFormStateCopyWithImpl<_AccountFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountFormState&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.openingBalance, openingBalance) || other.openingBalance == openingBalance)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing));
}


@override
int get hashCode => Object.hash(runtimeType,type,name,openingBalance,icon,color,status,error,isEditing);

@override
String toString() {
  return 'AccountFormState(type: $type, name: $name, openingBalance: $openingBalance, icon: $icon, color: $color, status: $status, error: $error, isEditing: $isEditing)';
}


}

/// @nodoc
abstract mixin class _$AccountFormStateCopyWith<$Res> implements $AccountFormStateCopyWith<$Res> {
  factory _$AccountFormStateCopyWith(_AccountFormState value, $Res Function(_AccountFormState) _then) = __$AccountFormStateCopyWithImpl;
@override @useResult
$Res call({
 AccountType type, String name, int openingBalance, String? icon, int? color, AccountFormStatus status, Failure? error, bool isEditing
});




}
/// @nodoc
class __$AccountFormStateCopyWithImpl<$Res>
    implements _$AccountFormStateCopyWith<$Res> {
  __$AccountFormStateCopyWithImpl(this._self, this._then);

  final _AccountFormState _self;
  final $Res Function(_AccountFormState) _then;

/// Create a copy of AccountFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? name = null,Object? openingBalance = null,Object? icon = freezed,Object? color = freezed,Object? status = null,Object? error = freezed,Object? isEditing = null,}) {
  return _then(_AccountFormState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,openingBalance: null == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as int,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountFormStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
