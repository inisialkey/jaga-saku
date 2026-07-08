// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsersState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UsersState()';
}


}

/// @nodoc
class $UsersStateCopyWith<$Res>  {
$UsersStateCopyWith(UsersState _, $Res Function(UsersState) __);
}


/// Adds pattern-matching-related methods to [UsersState].
extension UsersStatePatterns on UsersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UsersStateInitial value)?  initial,TResult Function( UsersStateLoading value)?  loading,TResult Function( UsersStateLoaded value)?  loaded,TResult Function( UsersStateEmpty value)?  empty,TResult Function( UsersStateFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UsersStateInitial() when initial != null:
return initial(_that);case UsersStateLoading() when loading != null:
return loading(_that);case UsersStateLoaded() when loaded != null:
return loaded(_that);case UsersStateEmpty() when empty != null:
return empty(_that);case UsersStateFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UsersStateInitial value)  initial,required TResult Function( UsersStateLoading value)  loading,required TResult Function( UsersStateLoaded value)  loaded,required TResult Function( UsersStateEmpty value)  empty,required TResult Function( UsersStateFailure value)  failure,}){
final _that = this;
switch (_that) {
case UsersStateInitial():
return initial(_that);case UsersStateLoading():
return loading(_that);case UsersStateLoaded():
return loaded(_that);case UsersStateEmpty():
return empty(_that);case UsersStateFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UsersStateInitial value)?  initial,TResult? Function( UsersStateLoading value)?  loading,TResult? Function( UsersStateLoaded value)?  loaded,TResult? Function( UsersStateEmpty value)?  empty,TResult? Function( UsersStateFailure value)?  failure,}){
final _that = this;
switch (_that) {
case UsersStateInitial() when initial != null:
return initial(_that);case UsersStateLoading() when loading != null:
return loading(_that);case UsersStateLoaded() when loaded != null:
return loaded(_that);case UsersStateEmpty() when empty != null:
return empty(_that);case UsersStateFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Page<User> page,  List<User> items,  bool isLoadingMore)?  loaded,TResult Function()?  empty,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UsersStateInitial() when initial != null:
return initial();case UsersStateLoading() when loading != null:
return loading();case UsersStateLoaded() when loaded != null:
return loaded(_that.page,_that.items,_that.isLoadingMore);case UsersStateEmpty() when empty != null:
return empty();case UsersStateFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Page<User> page,  List<User> items,  bool isLoadingMore)  loaded,required TResult Function()  empty,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case UsersStateInitial():
return initial();case UsersStateLoading():
return loading();case UsersStateLoaded():
return loaded(_that.page,_that.items,_that.isLoadingMore);case UsersStateEmpty():
return empty();case UsersStateFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Page<User> page,  List<User> items,  bool isLoadingMore)?  loaded,TResult? Function()?  empty,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case UsersStateInitial() when initial != null:
return initial();case UsersStateLoading() when loading != null:
return loading();case UsersStateLoaded() when loaded != null:
return loaded(_that.page,_that.items,_that.isLoadingMore);case UsersStateEmpty() when empty != null:
return empty();case UsersStateFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class UsersStateInitial implements UsersState {
  const UsersStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UsersState.initial()';
}


}




/// @nodoc


class UsersStateLoading implements UsersState {
  const UsersStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UsersState.loading()';
}


}




/// @nodoc


class UsersStateLoaded implements UsersState {
  const UsersStateLoaded({required this.page, required final  List<User> items, this.isLoadingMore = false}): _items = items;
  

 final  Page<User> page;
 final  List<User> _items;
 List<User> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@JsonKey() final  bool isLoadingMore;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsersStateLoadedCopyWith<UsersStateLoaded> get copyWith => _$UsersStateLoadedCopyWithImpl<UsersStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersStateLoaded&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(_items),isLoadingMore);

@override
String toString() {
  return 'UsersState.loaded(page: $page, items: $items, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $UsersStateLoadedCopyWith<$Res> implements $UsersStateCopyWith<$Res> {
  factory $UsersStateLoadedCopyWith(UsersStateLoaded value, $Res Function(UsersStateLoaded) _then) = _$UsersStateLoadedCopyWithImpl;
@useResult
$Res call({
 Page<User> page, List<User> items, bool isLoadingMore
});




}
/// @nodoc
class _$UsersStateLoadedCopyWithImpl<$Res>
    implements $UsersStateLoadedCopyWith<$Res> {
  _$UsersStateLoadedCopyWithImpl(this._self, this._then);

  final UsersStateLoaded _self;
  final $Res Function(UsersStateLoaded) _then;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? page = null,Object? items = null,Object? isLoadingMore = null,}) {
  return _then(UsersStateLoaded(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as Page<User>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<User>,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class UsersStateEmpty implements UsersState {
  const UsersStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UsersState.empty()';
}


}




/// @nodoc


class UsersStateFailure implements UsersState {
  const UsersStateFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsersStateFailureCopyWith<UsersStateFailure> get copyWith => _$UsersStateFailureCopyWithImpl<UsersStateFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersStateFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'UsersState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $UsersStateFailureCopyWith<$Res> implements $UsersStateCopyWith<$Res> {
  factory $UsersStateFailureCopyWith(UsersStateFailure value, $Res Function(UsersStateFailure) _then) = _$UsersStateFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$UsersStateFailureCopyWithImpl<$Res>
    implements $UsersStateFailureCopyWith<$Res> {
  _$UsersStateFailureCopyWithImpl(this._self, this._then);

  final UsersStateFailure _self;
  final $Res Function(UsersStateFailure) _then;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(UsersStateFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
