// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountListState()';
}


}

/// @nodoc
class $AccountListStateCopyWith<$Res>  {
$AccountListStateCopyWith(AccountListState _, $Res Function(AccountListState) __);
}


/// Adds pattern-matching-related methods to [AccountListState].
extension AccountListStatePatterns on AccountListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountListInitial value)?  initial,TResult Function( AccountListLoading value)?  loading,TResult Function( AccountListLoaded value)?  loaded,TResult Function( AccountListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountListInitial() when initial != null:
return initial(_that);case AccountListLoading() when loading != null:
return loading(_that);case AccountListLoaded() when loaded != null:
return loaded(_that);case AccountListError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountListInitial value)  initial,required TResult Function( AccountListLoading value)  loading,required TResult Function( AccountListLoaded value)  loaded,required TResult Function( AccountListError value)  error,}){
final _that = this;
switch (_that) {
case AccountListInitial():
return initial(_that);case AccountListLoading():
return loading(_that);case AccountListLoaded():
return loaded(_that);case AccountListError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountListInitial value)?  initial,TResult? Function( AccountListLoading value)?  loading,TResult? Function( AccountListLoaded value)?  loaded,TResult? Function( AccountListError value)?  error,}){
final _that = this;
switch (_that) {
case AccountListInitial() when initial != null:
return initial(_that);case AccountListLoading() when loading != null:
return loading(_that);case AccountListLoaded() when loaded != null:
return loaded(_that);case AccountListError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Account> items,  bool showArchived)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountListInitial() when initial != null:
return initial();case AccountListLoading() when loading != null:
return loading();case AccountListLoaded() when loaded != null:
return loaded(_that.items,_that.showArchived);case AccountListError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Account> items,  bool showArchived)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case AccountListInitial():
return initial();case AccountListLoading():
return loading();case AccountListLoaded():
return loaded(_that.items,_that.showArchived);case AccountListError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Account> items,  bool showArchived)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case AccountListInitial() when initial != null:
return initial();case AccountListLoading() when loading != null:
return loading();case AccountListLoaded() when loaded != null:
return loaded(_that.items,_that.showArchived);case AccountListError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class AccountListInitial implements AccountListState {
  const AccountListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountListState.initial()';
}


}




/// @nodoc


class AccountListLoading implements AccountListState {
  const AccountListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountListState.loading()';
}


}




/// @nodoc


class AccountListLoaded implements AccountListState {
  const AccountListLoaded({required final  List<Account> items, this.showArchived = false}): _items = items;
  

 final  List<Account> _items;
 List<Account> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@JsonKey() final  bool showArchived;

/// Create a copy of AccountListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountListLoadedCopyWith<AccountListLoaded> get copyWith => _$AccountListLoadedCopyWithImpl<AccountListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountListLoaded&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.showArchived, showArchived) || other.showArchived == showArchived));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),showArchived);

@override
String toString() {
  return 'AccountListState.loaded(items: $items, showArchived: $showArchived)';
}


}

/// @nodoc
abstract mixin class $AccountListLoadedCopyWith<$Res> implements $AccountListStateCopyWith<$Res> {
  factory $AccountListLoadedCopyWith(AccountListLoaded value, $Res Function(AccountListLoaded) _then) = _$AccountListLoadedCopyWithImpl;
@useResult
$Res call({
 List<Account> items, bool showArchived
});




}
/// @nodoc
class _$AccountListLoadedCopyWithImpl<$Res>
    implements $AccountListLoadedCopyWith<$Res> {
  _$AccountListLoadedCopyWithImpl(this._self, this._then);

  final AccountListLoaded _self;
  final $Res Function(AccountListLoaded) _then;

/// Create a copy of AccountListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? showArchived = null,}) {
  return _then(AccountListLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Account>,showArchived: null == showArchived ? _self.showArchived : showArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class AccountListError implements AccountListState {
  const AccountListError(this.failure);
  

 final  Failure failure;

/// Create a copy of AccountListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountListErrorCopyWith<AccountListError> get copyWith => _$AccountListErrorCopyWithImpl<AccountListError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountListError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'AccountListState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AccountListErrorCopyWith<$Res> implements $AccountListStateCopyWith<$Res> {
  factory $AccountListErrorCopyWith(AccountListError value, $Res Function(AccountListError) _then) = _$AccountListErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$AccountListErrorCopyWithImpl<$Res>
    implements $AccountListErrorCopyWith<$Res> {
  _$AccountListErrorCopyWithImpl(this._self, this._then);

  final AccountListError _self;
  final $Res Function(AccountListError) _then;

/// Create a copy of AccountListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(AccountListError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
