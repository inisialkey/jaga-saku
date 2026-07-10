// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetListState()';
}


}

/// @nodoc
class $BudgetListStateCopyWith<$Res>  {
$BudgetListStateCopyWith(BudgetListState _, $Res Function(BudgetListState) __);
}


/// Adds pattern-matching-related methods to [BudgetListState].
extension BudgetListStatePatterns on BudgetListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BudgetListInitial value)?  initial,TResult Function( BudgetListLoading value)?  loading,TResult Function( BudgetListLoaded value)?  loaded,TResult Function( BudgetListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BudgetListInitial() when initial != null:
return initial(_that);case BudgetListLoading() when loading != null:
return loading(_that);case BudgetListLoaded() when loaded != null:
return loaded(_that);case BudgetListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BudgetListInitial value)  initial,required TResult Function( BudgetListLoading value)  loading,required TResult Function( BudgetListLoaded value)  loaded,required TResult Function( BudgetListError value)  error,}){
final _that = this;
switch (_that) {
case BudgetListInitial():
return initial(_that);case BudgetListLoading():
return loading(_that);case BudgetListLoaded():
return loaded(_that);case BudgetListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BudgetListInitial value)?  initial,TResult? Function( BudgetListLoading value)?  loading,TResult? Function( BudgetListLoaded value)?  loaded,TResult? Function( BudgetListError value)?  error,}){
final _that = this;
switch (_that) {
case BudgetListInitial() when initial != null:
return initial(_that);case BudgetListLoading() when loading != null:
return loading(_that);case BudgetListLoaded() when loaded != null:
return loaded(_that);case BudgetListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( DateTime month,  List<Budget> budgets,  Map<int, Category> categoriesById)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BudgetListInitial() when initial != null:
return initial();case BudgetListLoading() when loading != null:
return loading();case BudgetListLoaded() when loaded != null:
return loaded(_that.month,_that.budgets,_that.categoriesById);case BudgetListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( DateTime month,  List<Budget> budgets,  Map<int, Category> categoriesById)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case BudgetListInitial():
return initial();case BudgetListLoading():
return loading();case BudgetListLoaded():
return loaded(_that.month,_that.budgets,_that.categoriesById);case BudgetListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( DateTime month,  List<Budget> budgets,  Map<int, Category> categoriesById)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case BudgetListInitial() when initial != null:
return initial();case BudgetListLoading() when loading != null:
return loading();case BudgetListLoaded() when loaded != null:
return loaded(_that.month,_that.budgets,_that.categoriesById);case BudgetListError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class BudgetListInitial implements BudgetListState {
  const BudgetListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetListState.initial()';
}


}




/// @nodoc


class BudgetListLoading implements BudgetListState {
  const BudgetListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetListState.loading()';
}


}




/// @nodoc


class BudgetListLoaded implements BudgetListState {
  const BudgetListLoaded({required this.month, required final  List<Budget> budgets, final  Map<int, Category> categoriesById = const <int, Category>{}}): _budgets = budgets,_categoriesById = categoriesById;
  

 final  DateTime month;
 final  List<Budget> _budgets;
 List<Budget> get budgets {
  if (_budgets is EqualUnmodifiableListView) return _budgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgets);
}

 final  Map<int, Category> _categoriesById;
@JsonKey() Map<int, Category> get categoriesById {
  if (_categoriesById is EqualUnmodifiableMapView) return _categoriesById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categoriesById);
}


/// Create a copy of BudgetListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetListLoadedCopyWith<BudgetListLoaded> get copyWith => _$BudgetListLoadedCopyWithImpl<BudgetListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetListLoaded&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other._budgets, _budgets)&&const DeepCollectionEquality().equals(other._categoriesById, _categoriesById));
}


@override
int get hashCode => Object.hash(runtimeType,month,const DeepCollectionEquality().hash(_budgets),const DeepCollectionEquality().hash(_categoriesById));

@override
String toString() {
  return 'BudgetListState.loaded(month: $month, budgets: $budgets, categoriesById: $categoriesById)';
}


}

/// @nodoc
abstract mixin class $BudgetListLoadedCopyWith<$Res> implements $BudgetListStateCopyWith<$Res> {
  factory $BudgetListLoadedCopyWith(BudgetListLoaded value, $Res Function(BudgetListLoaded) _then) = _$BudgetListLoadedCopyWithImpl;
@useResult
$Res call({
 DateTime month, List<Budget> budgets, Map<int, Category> categoriesById
});




}
/// @nodoc
class _$BudgetListLoadedCopyWithImpl<$Res>
    implements $BudgetListLoadedCopyWith<$Res> {
  _$BudgetListLoadedCopyWithImpl(this._self, this._then);

  final BudgetListLoaded _self;
  final $Res Function(BudgetListLoaded) _then;

/// Create a copy of BudgetListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? month = null,Object? budgets = null,Object? categoriesById = null,}) {
  return _then(BudgetListLoaded(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,budgets: null == budgets ? _self._budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<Budget>,categoriesById: null == categoriesById ? _self._categoriesById : categoriesById // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,
  ));
}


}

/// @nodoc


class BudgetListError implements BudgetListState {
  const BudgetListError(this.failure);
  

 final  Failure failure;

/// Create a copy of BudgetListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetListErrorCopyWith<BudgetListError> get copyWith => _$BudgetListErrorCopyWithImpl<BudgetListError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetListError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'BudgetListState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $BudgetListErrorCopyWith<$Res> implements $BudgetListStateCopyWith<$Res> {
  factory $BudgetListErrorCopyWith(BudgetListError value, $Res Function(BudgetListError) _then) = _$BudgetListErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$BudgetListErrorCopyWithImpl<$Res>
    implements $BudgetListErrorCopyWith<$Res> {
  _$BudgetListErrorCopyWithImpl(this._self, this._then);

  final BudgetListError _self;
  final $Res Function(BudgetListError) _then;

/// Create a copy of BudgetListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(BudgetListError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
