// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryListState()';
}


}

/// @nodoc
class $CategoryListStateCopyWith<$Res>  {
$CategoryListStateCopyWith(CategoryListState _, $Res Function(CategoryListState) __);
}


/// Adds pattern-matching-related methods to [CategoryListState].
extension CategoryListStatePatterns on CategoryListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CategoryListInitial value)?  initial,TResult Function( CategoryListLoading value)?  loading,TResult Function( CategoryListLoaded value)?  loaded,TResult Function( CategoryListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CategoryListInitial() when initial != null:
return initial(_that);case CategoryListLoading() when loading != null:
return loading(_that);case CategoryListLoaded() when loaded != null:
return loaded(_that);case CategoryListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CategoryListInitial value)  initial,required TResult Function( CategoryListLoading value)  loading,required TResult Function( CategoryListLoaded value)  loaded,required TResult Function( CategoryListError value)  error,}){
final _that = this;
switch (_that) {
case CategoryListInitial():
return initial(_that);case CategoryListLoading():
return loading(_that);case CategoryListLoaded():
return loaded(_that);case CategoryListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CategoryListInitial value)?  initial,TResult? Function( CategoryListLoading value)?  loading,TResult? Function( CategoryListLoaded value)?  loaded,TResult? Function( CategoryListError value)?  error,}){
final _that = this;
switch (_that) {
case CategoryListInitial() when initial != null:
return initial(_that);case CategoryListLoading() when loading != null:
return loading(_that);case CategoryListLoaded() when loaded != null:
return loaded(_that);case CategoryListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( CategoryType type)?  loading,TResult Function( List<Category> items,  CategoryType type,  bool showArchived)?  loaded,TResult Function( Failure failure,  CategoryType type)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CategoryListInitial() when initial != null:
return initial();case CategoryListLoading() when loading != null:
return loading(_that.type);case CategoryListLoaded() when loaded != null:
return loaded(_that.items,_that.type,_that.showArchived);case CategoryListError() when error != null:
return error(_that.failure,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( CategoryType type)  loading,required TResult Function( List<Category> items,  CategoryType type,  bool showArchived)  loaded,required TResult Function( Failure failure,  CategoryType type)  error,}) {final _that = this;
switch (_that) {
case CategoryListInitial():
return initial();case CategoryListLoading():
return loading(_that.type);case CategoryListLoaded():
return loaded(_that.items,_that.type,_that.showArchived);case CategoryListError():
return error(_that.failure,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( CategoryType type)?  loading,TResult? Function( List<Category> items,  CategoryType type,  bool showArchived)?  loaded,TResult? Function( Failure failure,  CategoryType type)?  error,}) {final _that = this;
switch (_that) {
case CategoryListInitial() when initial != null:
return initial();case CategoryListLoading() when loading != null:
return loading(_that.type);case CategoryListLoaded() when loaded != null:
return loaded(_that.items,_that.type,_that.showArchived);case CategoryListError() when error != null:
return error(_that.failure,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class CategoryListInitial implements CategoryListState {
  const CategoryListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryListState.initial()';
}


}




/// @nodoc


class CategoryListLoading implements CategoryListState {
  const CategoryListLoading({this.type = CategoryType.expense});
  

@JsonKey() final  CategoryType type;

/// Create a copy of CategoryListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryListLoadingCopyWith<CategoryListLoading> get copyWith => _$CategoryListLoadingCopyWithImpl<CategoryListLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryListLoading&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'CategoryListState.loading(type: $type)';
}


}

/// @nodoc
abstract mixin class $CategoryListLoadingCopyWith<$Res> implements $CategoryListStateCopyWith<$Res> {
  factory $CategoryListLoadingCopyWith(CategoryListLoading value, $Res Function(CategoryListLoading) _then) = _$CategoryListLoadingCopyWithImpl;
@useResult
$Res call({
 CategoryType type
});




}
/// @nodoc
class _$CategoryListLoadingCopyWithImpl<$Res>
    implements $CategoryListLoadingCopyWith<$Res> {
  _$CategoryListLoadingCopyWithImpl(this._self, this._then);

  final CategoryListLoading _self;
  final $Res Function(CategoryListLoading) _then;

/// Create a copy of CategoryListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(CategoryListLoading(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,
  ));
}


}

/// @nodoc


class CategoryListLoaded implements CategoryListState {
  const CategoryListLoaded({required final  List<Category> items, required this.type, this.showArchived = false}): _items = items;
  

 final  List<Category> _items;
 List<Category> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  CategoryType type;
@JsonKey() final  bool showArchived;

/// Create a copy of CategoryListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryListLoadedCopyWith<CategoryListLoaded> get copyWith => _$CategoryListLoadedCopyWithImpl<CategoryListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryListLoaded&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.type, type) || other.type == type)&&(identical(other.showArchived, showArchived) || other.showArchived == showArchived));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),type,showArchived);

@override
String toString() {
  return 'CategoryListState.loaded(items: $items, type: $type, showArchived: $showArchived)';
}


}

/// @nodoc
abstract mixin class $CategoryListLoadedCopyWith<$Res> implements $CategoryListStateCopyWith<$Res> {
  factory $CategoryListLoadedCopyWith(CategoryListLoaded value, $Res Function(CategoryListLoaded) _then) = _$CategoryListLoadedCopyWithImpl;
@useResult
$Res call({
 List<Category> items, CategoryType type, bool showArchived
});




}
/// @nodoc
class _$CategoryListLoadedCopyWithImpl<$Res>
    implements $CategoryListLoadedCopyWith<$Res> {
  _$CategoryListLoadedCopyWithImpl(this._self, this._then);

  final CategoryListLoaded _self;
  final $Res Function(CategoryListLoaded) _then;

/// Create a copy of CategoryListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? type = null,Object? showArchived = null,}) {
  return _then(CategoryListLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Category>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,showArchived: null == showArchived ? _self.showArchived : showArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class CategoryListError implements CategoryListState {
  const CategoryListError({required this.failure, this.type = CategoryType.expense});
  

 final  Failure failure;
@JsonKey() final  CategoryType type;

/// Create a copy of CategoryListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryListErrorCopyWith<CategoryListError> get copyWith => _$CategoryListErrorCopyWithImpl<CategoryListError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryListError&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,failure,type);

@override
String toString() {
  return 'CategoryListState.error(failure: $failure, type: $type)';
}


}

/// @nodoc
abstract mixin class $CategoryListErrorCopyWith<$Res> implements $CategoryListStateCopyWith<$Res> {
  factory $CategoryListErrorCopyWith(CategoryListError value, $Res Function(CategoryListError) _then) = _$CategoryListErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure, CategoryType type
});




}
/// @nodoc
class _$CategoryListErrorCopyWithImpl<$Res>
    implements $CategoryListErrorCopyWith<$Res> {
  _$CategoryListErrorCopyWithImpl(this._self, this._then);

  final CategoryListError _self;
  final $Res Function(CategoryListError) _then;

/// Create a copy of CategoryListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? type = null,}) {
  return _then(CategoryListError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,
  ));
}


}

// dart format on
