// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_transaction_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchTransactionState {

 SearchTransactionParams get params;
/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchTransactionStateCopyWith<SearchTransactionState> get copyWith => _$SearchTransactionStateCopyWithImpl<SearchTransactionState>(this as SearchTransactionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchTransactionState&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'SearchTransactionState(params: $params)';
}


}

/// @nodoc
abstract mixin class $SearchTransactionStateCopyWith<$Res>  {
  factory $SearchTransactionStateCopyWith(SearchTransactionState value, $Res Function(SearchTransactionState) _then) = _$SearchTransactionStateCopyWithImpl;
@useResult
$Res call({
 SearchTransactionParams params
});


$SearchTransactionParamsCopyWith<$Res> get params;

}
/// @nodoc
class _$SearchTransactionStateCopyWithImpl<$Res>
    implements $SearchTransactionStateCopyWith<$Res> {
  _$SearchTransactionStateCopyWithImpl(this._self, this._then);

  final SearchTransactionState _self;
  final $Res Function(SearchTransactionState) _then;

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = null,}) {
  return _then(_self.copyWith(
params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as SearchTransactionParams,
  ));
}
/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchTransactionParamsCopyWith<$Res> get params {
  
  return $SearchTransactionParamsCopyWith<$Res>(_self.params, (value) {
    return _then(_self.copyWith(params: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchTransactionState].
extension SearchTransactionStatePatterns on SearchTransactionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchInitial value)?  initial,TResult Function( SearchLoading value)?  loading,TResult Function( SearchResults value)?  results,TResult Function( SearchEmpty value)?  empty,TResult Function( SearchFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that);case SearchLoading() when loading != null:
return loading(_that);case SearchResults() when results != null:
return results(_that);case SearchEmpty() when empty != null:
return empty(_that);case SearchFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchInitial value)  initial,required TResult Function( SearchLoading value)  loading,required TResult Function( SearchResults value)  results,required TResult Function( SearchEmpty value)  empty,required TResult Function( SearchFailure value)  failure,}){
final _that = this;
switch (_that) {
case SearchInitial():
return initial(_that);case SearchLoading():
return loading(_that);case SearchResults():
return results(_that);case SearchEmpty():
return empty(_that);case SearchFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchInitial value)?  initial,TResult? Function( SearchLoading value)?  loading,TResult? Function( SearchResults value)?  results,TResult? Function( SearchEmpty value)?  empty,TResult? Function( SearchFailure value)?  failure,}){
final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that);case SearchLoading() when loading != null:
return loading(_that);case SearchResults() when results != null:
return results(_that);case SearchEmpty() when empty != null:
return empty(_that);case SearchFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( SearchTransactionParams params)?  initial,TResult Function( SearchTransactionParams params)?  loading,TResult Function( SearchTransactionParams params,  List<Transaction> items)?  results,TResult Function( SearchTransactionParams params)?  empty,TResult Function( SearchTransactionParams params,  Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that.params);case SearchLoading() when loading != null:
return loading(_that.params);case SearchResults() when results != null:
return results(_that.params,_that.items);case SearchEmpty() when empty != null:
return empty(_that.params);case SearchFailure() when failure != null:
return failure(_that.params,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( SearchTransactionParams params)  initial,required TResult Function( SearchTransactionParams params)  loading,required TResult Function( SearchTransactionParams params,  List<Transaction> items)  results,required TResult Function( SearchTransactionParams params)  empty,required TResult Function( SearchTransactionParams params,  Failure failure)  failure,}) {final _that = this;
switch (_that) {
case SearchInitial():
return initial(_that.params);case SearchLoading():
return loading(_that.params);case SearchResults():
return results(_that.params,_that.items);case SearchEmpty():
return empty(_that.params);case SearchFailure():
return failure(_that.params,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( SearchTransactionParams params)?  initial,TResult? Function( SearchTransactionParams params)?  loading,TResult? Function( SearchTransactionParams params,  List<Transaction> items)?  results,TResult? Function( SearchTransactionParams params)?  empty,TResult? Function( SearchTransactionParams params,  Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that.params);case SearchLoading() when loading != null:
return loading(_that.params);case SearchResults() when results != null:
return results(_that.params,_that.items);case SearchEmpty() when empty != null:
return empty(_that.params);case SearchFailure() when failure != null:
return failure(_that.params,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class SearchInitial extends SearchTransactionState {
  const SearchInitial(this.params): super._();
  

@override final  SearchTransactionParams params;

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchInitialCopyWith<SearchInitial> get copyWith => _$SearchInitialCopyWithImpl<SearchInitial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchInitial&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'SearchTransactionState.initial(params: $params)';
}


}

/// @nodoc
abstract mixin class $SearchInitialCopyWith<$Res> implements $SearchTransactionStateCopyWith<$Res> {
  factory $SearchInitialCopyWith(SearchInitial value, $Res Function(SearchInitial) _then) = _$SearchInitialCopyWithImpl;
@override @useResult
$Res call({
 SearchTransactionParams params
});


@override $SearchTransactionParamsCopyWith<$Res> get params;

}
/// @nodoc
class _$SearchInitialCopyWithImpl<$Res>
    implements $SearchInitialCopyWith<$Res> {
  _$SearchInitialCopyWithImpl(this._self, this._then);

  final SearchInitial _self;
  final $Res Function(SearchInitial) _then;

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = null,}) {
  return _then(SearchInitial(
null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as SearchTransactionParams,
  ));
}

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchTransactionParamsCopyWith<$Res> get params {
  
  return $SearchTransactionParamsCopyWith<$Res>(_self.params, (value) {
    return _then(_self.copyWith(params: value));
  });
}
}

/// @nodoc


class SearchLoading extends SearchTransactionState {
  const SearchLoading(this.params): super._();
  

@override final  SearchTransactionParams params;

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchLoadingCopyWith<SearchLoading> get copyWith => _$SearchLoadingCopyWithImpl<SearchLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLoading&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'SearchTransactionState.loading(params: $params)';
}


}

/// @nodoc
abstract mixin class $SearchLoadingCopyWith<$Res> implements $SearchTransactionStateCopyWith<$Res> {
  factory $SearchLoadingCopyWith(SearchLoading value, $Res Function(SearchLoading) _then) = _$SearchLoadingCopyWithImpl;
@override @useResult
$Res call({
 SearchTransactionParams params
});


@override $SearchTransactionParamsCopyWith<$Res> get params;

}
/// @nodoc
class _$SearchLoadingCopyWithImpl<$Res>
    implements $SearchLoadingCopyWith<$Res> {
  _$SearchLoadingCopyWithImpl(this._self, this._then);

  final SearchLoading _self;
  final $Res Function(SearchLoading) _then;

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = null,}) {
  return _then(SearchLoading(
null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as SearchTransactionParams,
  ));
}

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchTransactionParamsCopyWith<$Res> get params {
  
  return $SearchTransactionParamsCopyWith<$Res>(_self.params, (value) {
    return _then(_self.copyWith(params: value));
  });
}
}

/// @nodoc


class SearchResults extends SearchTransactionState {
  const SearchResults(this.params, final  List<Transaction> items): _items = items,super._();
  

@override final  SearchTransactionParams params;
 final  List<Transaction> _items;
 List<Transaction> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultsCopyWith<SearchResults> get copyWith => _$SearchResultsCopyWithImpl<SearchResults>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResults&&(identical(other.params, params) || other.params == params)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,params,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SearchTransactionState.results(params: $params, items: $items)';
}


}

/// @nodoc
abstract mixin class $SearchResultsCopyWith<$Res> implements $SearchTransactionStateCopyWith<$Res> {
  factory $SearchResultsCopyWith(SearchResults value, $Res Function(SearchResults) _then) = _$SearchResultsCopyWithImpl;
@override @useResult
$Res call({
 SearchTransactionParams params, List<Transaction> items
});


@override $SearchTransactionParamsCopyWith<$Res> get params;

}
/// @nodoc
class _$SearchResultsCopyWithImpl<$Res>
    implements $SearchResultsCopyWith<$Res> {
  _$SearchResultsCopyWithImpl(this._self, this._then);

  final SearchResults _self;
  final $Res Function(SearchResults) _then;

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = null,Object? items = null,}) {
  return _then(SearchResults(
null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as SearchTransactionParams,null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Transaction>,
  ));
}

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchTransactionParamsCopyWith<$Res> get params {
  
  return $SearchTransactionParamsCopyWith<$Res>(_self.params, (value) {
    return _then(_self.copyWith(params: value));
  });
}
}

/// @nodoc


class SearchEmpty extends SearchTransactionState {
  const SearchEmpty(this.params): super._();
  

@override final  SearchTransactionParams params;

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchEmptyCopyWith<SearchEmpty> get copyWith => _$SearchEmptyCopyWithImpl<SearchEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchEmpty&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'SearchTransactionState.empty(params: $params)';
}


}

/// @nodoc
abstract mixin class $SearchEmptyCopyWith<$Res> implements $SearchTransactionStateCopyWith<$Res> {
  factory $SearchEmptyCopyWith(SearchEmpty value, $Res Function(SearchEmpty) _then) = _$SearchEmptyCopyWithImpl;
@override @useResult
$Res call({
 SearchTransactionParams params
});


@override $SearchTransactionParamsCopyWith<$Res> get params;

}
/// @nodoc
class _$SearchEmptyCopyWithImpl<$Res>
    implements $SearchEmptyCopyWith<$Res> {
  _$SearchEmptyCopyWithImpl(this._self, this._then);

  final SearchEmpty _self;
  final $Res Function(SearchEmpty) _then;

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = null,}) {
  return _then(SearchEmpty(
null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as SearchTransactionParams,
  ));
}

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchTransactionParamsCopyWith<$Res> get params {
  
  return $SearchTransactionParamsCopyWith<$Res>(_self.params, (value) {
    return _then(_self.copyWith(params: value));
  });
}
}

/// @nodoc


class SearchFailure extends SearchTransactionState {
  const SearchFailure(this.params, this.failure): super._();
  

@override final  SearchTransactionParams params;
 final  Failure failure;

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchFailureCopyWith<SearchFailure> get copyWith => _$SearchFailureCopyWithImpl<SearchFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchFailure&&(identical(other.params, params) || other.params == params)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,params,failure);

@override
String toString() {
  return 'SearchTransactionState.failure(params: $params, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SearchFailureCopyWith<$Res> implements $SearchTransactionStateCopyWith<$Res> {
  factory $SearchFailureCopyWith(SearchFailure value, $Res Function(SearchFailure) _then) = _$SearchFailureCopyWithImpl;
@override @useResult
$Res call({
 SearchTransactionParams params, Failure failure
});


@override $SearchTransactionParamsCopyWith<$Res> get params;

}
/// @nodoc
class _$SearchFailureCopyWithImpl<$Res>
    implements $SearchFailureCopyWith<$Res> {
  _$SearchFailureCopyWithImpl(this._self, this._then);

  final SearchFailure _self;
  final $Res Function(SearchFailure) _then;

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = null,Object? failure = null,}) {
  return _then(SearchFailure(
null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as SearchTransactionParams,null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of SearchTransactionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchTransactionParamsCopyWith<$Res> get params {
  
  return $SearchTransactionParamsCopyWith<$Res>(_self.params, (value) {
    return _then(_self.copyWith(params: value));
  });
}
}

// dart format on
