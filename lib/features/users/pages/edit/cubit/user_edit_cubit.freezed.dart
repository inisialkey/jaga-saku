// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_edit_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserEditState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserEditState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserEditState()';
}


}

/// @nodoc
class $UserEditStateCopyWith<$Res>  {
$UserEditStateCopyWith(UserEditState _, $Res Function(UserEditState) __);
}


/// Adds pattern-matching-related methods to [UserEditState].
extension UserEditStatePatterns on UserEditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UserEditStateInitial value)?  initial,TResult Function( UserEditStateSubmitting value)?  submitting,TResult Function( UserEditStateSuccess value)?  success,TResult Function( UserEditStateDeleted value)?  deleted,TResult Function( UserEditStateFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UserEditStateInitial() when initial != null:
return initial(_that);case UserEditStateSubmitting() when submitting != null:
return submitting(_that);case UserEditStateSuccess() when success != null:
return success(_that);case UserEditStateDeleted() when deleted != null:
return deleted(_that);case UserEditStateFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UserEditStateInitial value)  initial,required TResult Function( UserEditStateSubmitting value)  submitting,required TResult Function( UserEditStateSuccess value)  success,required TResult Function( UserEditStateDeleted value)  deleted,required TResult Function( UserEditStateFailure value)  failure,}){
final _that = this;
switch (_that) {
case UserEditStateInitial():
return initial(_that);case UserEditStateSubmitting():
return submitting(_that);case UserEditStateSuccess():
return success(_that);case UserEditStateDeleted():
return deleted(_that);case UserEditStateFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UserEditStateInitial value)?  initial,TResult? Function( UserEditStateSubmitting value)?  submitting,TResult? Function( UserEditStateSuccess value)?  success,TResult? Function( UserEditStateDeleted value)?  deleted,TResult? Function( UserEditStateFailure value)?  failure,}){
final _that = this;
switch (_that) {
case UserEditStateInitial() when initial != null:
return initial(_that);case UserEditStateSubmitting() when submitting != null:
return submitting(_that);case UserEditStateSuccess() when success != null:
return success(_that);case UserEditStateDeleted() when deleted != null:
return deleted(_that);case UserEditStateFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  submitting,TResult Function( User user)?  success,TResult Function()?  deleted,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UserEditStateInitial() when initial != null:
return initial();case UserEditStateSubmitting() when submitting != null:
return submitting();case UserEditStateSuccess() when success != null:
return success(_that.user);case UserEditStateDeleted() when deleted != null:
return deleted();case UserEditStateFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  submitting,required TResult Function( User user)  success,required TResult Function()  deleted,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case UserEditStateInitial():
return initial();case UserEditStateSubmitting():
return submitting();case UserEditStateSuccess():
return success(_that.user);case UserEditStateDeleted():
return deleted();case UserEditStateFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  submitting,TResult? Function( User user)?  success,TResult? Function()?  deleted,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case UserEditStateInitial() when initial != null:
return initial();case UserEditStateSubmitting() when submitting != null:
return submitting();case UserEditStateSuccess() when success != null:
return success(_that.user);case UserEditStateDeleted() when deleted != null:
return deleted();case UserEditStateFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class UserEditStateInitial implements UserEditState {
  const UserEditStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserEditStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserEditState.initial()';
}


}




/// @nodoc


class UserEditStateSubmitting implements UserEditState {
  const UserEditStateSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserEditStateSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserEditState.submitting()';
}


}




/// @nodoc


class UserEditStateSuccess implements UserEditState {
  const UserEditStateSuccess(this.user);
  

 final  User user;

/// Create a copy of UserEditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserEditStateSuccessCopyWith<UserEditStateSuccess> get copyWith => _$UserEditStateSuccessCopyWithImpl<UserEditStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserEditStateSuccess&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'UserEditState.success(user: $user)';
}


}

/// @nodoc
abstract mixin class $UserEditStateSuccessCopyWith<$Res> implements $UserEditStateCopyWith<$Res> {
  factory $UserEditStateSuccessCopyWith(UserEditStateSuccess value, $Res Function(UserEditStateSuccess) _then) = _$UserEditStateSuccessCopyWithImpl;
@useResult
$Res call({
 User user
});


$UserCopyWith<$Res> get user;

}
/// @nodoc
class _$UserEditStateSuccessCopyWithImpl<$Res>
    implements $UserEditStateSuccessCopyWith<$Res> {
  _$UserEditStateSuccessCopyWithImpl(this._self, this._then);

  final UserEditStateSuccess _self;
  final $Res Function(UserEditStateSuccess) _then;

/// Create a copy of UserEditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(UserEditStateSuccess(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,
  ));
}

/// Create a copy of UserEditState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class UserEditStateDeleted implements UserEditState {
  const UserEditStateDeleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserEditStateDeleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserEditState.deleted()';
}


}




/// @nodoc


class UserEditStateFailure implements UserEditState {
  const UserEditStateFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of UserEditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserEditStateFailureCopyWith<UserEditStateFailure> get copyWith => _$UserEditStateFailureCopyWithImpl<UserEditStateFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserEditStateFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'UserEditState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $UserEditStateFailureCopyWith<$Res> implements $UserEditStateCopyWith<$Res> {
  factory $UserEditStateFailureCopyWith(UserEditStateFailure value, $Res Function(UserEditStateFailure) _then) = _$UserEditStateFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$UserEditStateFailureCopyWithImpl<$Res>
    implements $UserEditStateFailureCopyWith<$Res> {
  _$UserEditStateFailureCopyWithImpl(this._self, this._then);

  final UserEditStateFailure _self;
  final $Res Function(UserEditStateFailure) _then;

/// Create a copy of UserEditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(UserEditStateFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
