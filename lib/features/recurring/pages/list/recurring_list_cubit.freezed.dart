// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecurringListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RecurringListState()';
}


}

/// @nodoc
class $RecurringListStateCopyWith<$Res>  {
$RecurringListStateCopyWith(RecurringListState _, $Res Function(RecurringListState) __);
}


/// Adds pattern-matching-related methods to [RecurringListState].
extension RecurringListStatePatterns on RecurringListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RecurringListInitial value)?  initial,TResult Function( RecurringListLoading value)?  loading,TResult Function( RecurringListLoaded value)?  loaded,TResult Function( RecurringListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RecurringListInitial() when initial != null:
return initial(_that);case RecurringListLoading() when loading != null:
return loading(_that);case RecurringListLoaded() when loaded != null:
return loaded(_that);case RecurringListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RecurringListInitial value)  initial,required TResult Function( RecurringListLoading value)  loading,required TResult Function( RecurringListLoaded value)  loaded,required TResult Function( RecurringListError value)  error,}){
final _that = this;
switch (_that) {
case RecurringListInitial():
return initial(_that);case RecurringListLoading():
return loading(_that);case RecurringListLoaded():
return loaded(_that);case RecurringListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RecurringListInitial value)?  initial,TResult? Function( RecurringListLoading value)?  loading,TResult? Function( RecurringListLoaded value)?  loaded,TResult? Function( RecurringListError value)?  error,}){
final _that = this;
switch (_that) {
case RecurringListInitial() when initial != null:
return initial(_that);case RecurringListLoading() when loading != null:
return loading(_that);case RecurringListLoaded() when loaded != null:
return loaded(_that);case RecurringListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<RecurringRule> rules)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RecurringListInitial() when initial != null:
return initial();case RecurringListLoading() when loading != null:
return loading();case RecurringListLoaded() when loaded != null:
return loaded(_that.rules);case RecurringListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<RecurringRule> rules)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case RecurringListInitial():
return initial();case RecurringListLoading():
return loading();case RecurringListLoaded():
return loaded(_that.rules);case RecurringListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<RecurringRule> rules)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case RecurringListInitial() when initial != null:
return initial();case RecurringListLoading() when loading != null:
return loading();case RecurringListLoaded() when loaded != null:
return loaded(_that.rules);case RecurringListError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class RecurringListInitial implements RecurringListState {
  const RecurringListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RecurringListState.initial()';
}


}




/// @nodoc


class RecurringListLoading implements RecurringListState {
  const RecurringListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RecurringListState.loading()';
}


}




/// @nodoc


class RecurringListLoaded implements RecurringListState {
  const RecurringListLoaded({required final  List<RecurringRule> rules}): _rules = rules;
  

 final  List<RecurringRule> _rules;
 List<RecurringRule> get rules {
  if (_rules is EqualUnmodifiableListView) return _rules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rules);
}


/// Create a copy of RecurringListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringListLoadedCopyWith<RecurringListLoaded> get copyWith => _$RecurringListLoadedCopyWithImpl<RecurringListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringListLoaded&&const DeepCollectionEquality().equals(other._rules, _rules));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rules));

@override
String toString() {
  return 'RecurringListState.loaded(rules: $rules)';
}


}

/// @nodoc
abstract mixin class $RecurringListLoadedCopyWith<$Res> implements $RecurringListStateCopyWith<$Res> {
  factory $RecurringListLoadedCopyWith(RecurringListLoaded value, $Res Function(RecurringListLoaded) _then) = _$RecurringListLoadedCopyWithImpl;
@useResult
$Res call({
 List<RecurringRule> rules
});




}
/// @nodoc
class _$RecurringListLoadedCopyWithImpl<$Res>
    implements $RecurringListLoadedCopyWith<$Res> {
  _$RecurringListLoadedCopyWithImpl(this._self, this._then);

  final RecurringListLoaded _self;
  final $Res Function(RecurringListLoaded) _then;

/// Create a copy of RecurringListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rules = null,}) {
  return _then(RecurringListLoaded(
rules: null == rules ? _self._rules : rules // ignore: cast_nullable_to_non_nullable
as List<RecurringRule>,
  ));
}


}

/// @nodoc


class RecurringListError implements RecurringListState {
  const RecurringListError(this.failure);
  

 final  Failure failure;

/// Create a copy of RecurringListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringListErrorCopyWith<RecurringListError> get copyWith => _$RecurringListErrorCopyWithImpl<RecurringListError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringListError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'RecurringListState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $RecurringListErrorCopyWith<$Res> implements $RecurringListStateCopyWith<$Res> {
  factory $RecurringListErrorCopyWith(RecurringListError value, $Res Function(RecurringListError) _then) = _$RecurringListErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$RecurringListErrorCopyWithImpl<$Res>
    implements $RecurringListErrorCopyWith<$Res> {
  _$RecurringListErrorCopyWithImpl(this._self, this._then);

  final RecurringListError _self;
  final $Res Function(RecurringListError) _then;

/// Create a copy of RecurringListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(RecurringListError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
