// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoritesListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoritesListState()';
}


}

/// @nodoc
class $FavoritesListStateCopyWith<$Res>  {
$FavoritesListStateCopyWith(FavoritesListState _, $Res Function(FavoritesListState) __);
}


/// Adds pattern-matching-related methods to [FavoritesListState].
extension FavoritesListStatePatterns on FavoritesListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FavoritesListInitial value)?  initial,TResult Function( FavoritesListLoading value)?  loading,TResult Function( FavoritesListLoaded value)?  loaded,TResult Function( FavoritesListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FavoritesListInitial() when initial != null:
return initial(_that);case FavoritesListLoading() when loading != null:
return loading(_that);case FavoritesListLoaded() when loaded != null:
return loaded(_that);case FavoritesListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FavoritesListInitial value)  initial,required TResult Function( FavoritesListLoading value)  loading,required TResult Function( FavoritesListLoaded value)  loaded,required TResult Function( FavoritesListError value)  error,}){
final _that = this;
switch (_that) {
case FavoritesListInitial():
return initial(_that);case FavoritesListLoading():
return loading(_that);case FavoritesListLoaded():
return loaded(_that);case FavoritesListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FavoritesListInitial value)?  initial,TResult? Function( FavoritesListLoading value)?  loading,TResult? Function( FavoritesListLoaded value)?  loaded,TResult? Function( FavoritesListError value)?  error,}){
final _that = this;
switch (_that) {
case FavoritesListInitial() when initial != null:
return initial(_that);case FavoritesListLoading() when loading != null:
return loading(_that);case FavoritesListLoaded() when loaded != null:
return loaded(_that);case FavoritesListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<TxTemplate> items)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FavoritesListInitial() when initial != null:
return initial();case FavoritesListLoading() when loading != null:
return loading();case FavoritesListLoaded() when loaded != null:
return loaded(_that.items);case FavoritesListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<TxTemplate> items)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case FavoritesListInitial():
return initial();case FavoritesListLoading():
return loading();case FavoritesListLoaded():
return loaded(_that.items);case FavoritesListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<TxTemplate> items)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case FavoritesListInitial() when initial != null:
return initial();case FavoritesListLoading() when loading != null:
return loading();case FavoritesListLoaded() when loaded != null:
return loaded(_that.items);case FavoritesListError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class FavoritesListInitial implements FavoritesListState {
  const FavoritesListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoritesListState.initial()';
}


}




/// @nodoc


class FavoritesListLoading implements FavoritesListState {
  const FavoritesListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoritesListState.loading()';
}


}




/// @nodoc


class FavoritesListLoaded implements FavoritesListState {
  const FavoritesListLoaded({required final  List<TxTemplate> items}): _items = items;
  

 final  List<TxTemplate> _items;
 List<TxTemplate> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of FavoritesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoritesListLoadedCopyWith<FavoritesListLoaded> get copyWith => _$FavoritesListLoadedCopyWithImpl<FavoritesListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesListLoaded&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'FavoritesListState.loaded(items: $items)';
}


}

/// @nodoc
abstract mixin class $FavoritesListLoadedCopyWith<$Res> implements $FavoritesListStateCopyWith<$Res> {
  factory $FavoritesListLoadedCopyWith(FavoritesListLoaded value, $Res Function(FavoritesListLoaded) _then) = _$FavoritesListLoadedCopyWithImpl;
@useResult
$Res call({
 List<TxTemplate> items
});




}
/// @nodoc
class _$FavoritesListLoadedCopyWithImpl<$Res>
    implements $FavoritesListLoadedCopyWith<$Res> {
  _$FavoritesListLoadedCopyWithImpl(this._self, this._then);

  final FavoritesListLoaded _self;
  final $Res Function(FavoritesListLoaded) _then;

/// Create a copy of FavoritesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(FavoritesListLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TxTemplate>,
  ));
}


}

/// @nodoc


class FavoritesListError implements FavoritesListState {
  const FavoritesListError(this.failure);
  

 final  Failure failure;

/// Create a copy of FavoritesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoritesListErrorCopyWith<FavoritesListError> get copyWith => _$FavoritesListErrorCopyWithImpl<FavoritesListError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritesListError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'FavoritesListState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FavoritesListErrorCopyWith<$Res> implements $FavoritesListStateCopyWith<$Res> {
  factory $FavoritesListErrorCopyWith(FavoritesListError value, $Res Function(FavoritesListError) _then) = _$FavoritesListErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$FavoritesListErrorCopyWithImpl<$Res>
    implements $FavoritesListErrorCopyWith<$Res> {
  _$FavoritesListErrorCopyWithImpl(this._self, this._then);

  final FavoritesListError _self;
  final $Res Function(FavoritesListError) _then;

/// Create a copy of FavoritesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(FavoritesListError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
