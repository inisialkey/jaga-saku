// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserDetailState()';
}


}

/// @nodoc
class $UserDetailStateCopyWith<$Res>  {
$UserDetailStateCopyWith(UserDetailState _, $Res Function(UserDetailState) __);
}


/// Adds pattern-matching-related methods to [UserDetailState].
extension UserDetailStatePatterns on UserDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UserDetailStateLoading value)?  loading,TResult Function( UserDetailStateLoaded value)?  loaded,TResult Function( UserDetailStateFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UserDetailStateLoading() when loading != null:
return loading(_that);case UserDetailStateLoaded() when loaded != null:
return loaded(_that);case UserDetailStateFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UserDetailStateLoading value)  loading,required TResult Function( UserDetailStateLoaded value)  loaded,required TResult Function( UserDetailStateFailure value)  failure,}){
final _that = this;
switch (_that) {
case UserDetailStateLoading():
return loading(_that);case UserDetailStateLoaded():
return loaded(_that);case UserDetailStateFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UserDetailStateLoading value)?  loading,TResult? Function( UserDetailStateLoaded value)?  loaded,TResult? Function( UserDetailStateFailure value)?  failure,}){
final _that = this;
switch (_that) {
case UserDetailStateLoading() when loading != null:
return loading(_that);case UserDetailStateLoaded() when loaded != null:
return loaded(_that);case UserDetailStateFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( User user)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UserDetailStateLoading() when loading != null:
return loading();case UserDetailStateLoaded() when loaded != null:
return loaded(_that.user);case UserDetailStateFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( User user)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case UserDetailStateLoading():
return loading();case UserDetailStateLoaded():
return loaded(_that.user);case UserDetailStateFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( User user)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case UserDetailStateLoading() when loading != null:
return loading();case UserDetailStateLoaded() when loaded != null:
return loaded(_that.user);case UserDetailStateFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class UserDetailStateLoading implements UserDetailState {
  const UserDetailStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDetailStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserDetailState.loading()';
}


}




/// @nodoc


class UserDetailStateLoaded implements UserDetailState {
  const UserDetailStateLoaded(this.user);
  

 final  User user;

/// Create a copy of UserDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDetailStateLoadedCopyWith<UserDetailStateLoaded> get copyWith => _$UserDetailStateLoadedCopyWithImpl<UserDetailStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDetailStateLoaded&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'UserDetailState.loaded(user: $user)';
}


}

/// @nodoc
abstract mixin class $UserDetailStateLoadedCopyWith<$Res> implements $UserDetailStateCopyWith<$Res> {
  factory $UserDetailStateLoadedCopyWith(UserDetailStateLoaded value, $Res Function(UserDetailStateLoaded) _then) = _$UserDetailStateLoadedCopyWithImpl;
@useResult
$Res call({
 User user
});


$UserCopyWith<$Res> get user;

}
/// @nodoc
class _$UserDetailStateLoadedCopyWithImpl<$Res>
    implements $UserDetailStateLoadedCopyWith<$Res> {
  _$UserDetailStateLoadedCopyWithImpl(this._self, this._then);

  final UserDetailStateLoaded _self;
  final $Res Function(UserDetailStateLoaded) _then;

/// Create a copy of UserDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(UserDetailStateLoaded(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,
  ));
}

/// Create a copy of UserDetailState
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


class UserDetailStateFailure implements UserDetailState {
  const UserDetailStateFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of UserDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDetailStateFailureCopyWith<UserDetailStateFailure> get copyWith => _$UserDetailStateFailureCopyWithImpl<UserDetailStateFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDetailStateFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'UserDetailState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $UserDetailStateFailureCopyWith<$Res> implements $UserDetailStateCopyWith<$Res> {
  factory $UserDetailStateFailureCopyWith(UserDetailStateFailure value, $Res Function(UserDetailStateFailure) _then) = _$UserDetailStateFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$UserDetailStateFailureCopyWithImpl<$Res>
    implements $UserDetailStateFailureCopyWith<$Res> {
  _$UserDetailStateFailureCopyWithImpl(this._self, this._then);

  final UserDetailStateFailure _self;
  final $Res Function(UserDetailStateFailure) _then;

/// Create a copy of UserDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(UserDetailStateFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
