// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_review_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecurringReviewState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringReviewState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RecurringReviewState()';
}


}

/// @nodoc
class $RecurringReviewStateCopyWith<$Res>  {
$RecurringReviewStateCopyWith(RecurringReviewState _, $Res Function(RecurringReviewState) __);
}


/// Adds pattern-matching-related methods to [RecurringReviewState].
extension RecurringReviewStatePatterns on RecurringReviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RecurringReviewLoading value)?  loading,TResult Function( RecurringReviewLoaded value)?  loaded,TResult Function( RecurringReviewEmpty value)?  empty,TResult Function( RecurringReviewError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RecurringReviewLoading() when loading != null:
return loading(_that);case RecurringReviewLoaded() when loaded != null:
return loaded(_that);case RecurringReviewEmpty() when empty != null:
return empty(_that);case RecurringReviewError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RecurringReviewLoading value)  loading,required TResult Function( RecurringReviewLoaded value)  loaded,required TResult Function( RecurringReviewEmpty value)  empty,required TResult Function( RecurringReviewError value)  error,}){
final _that = this;
switch (_that) {
case RecurringReviewLoading():
return loading(_that);case RecurringReviewLoaded():
return loaded(_that);case RecurringReviewEmpty():
return empty(_that);case RecurringReviewError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RecurringReviewLoading value)?  loading,TResult? Function( RecurringReviewLoaded value)?  loaded,TResult? Function( RecurringReviewEmpty value)?  empty,TResult? Function( RecurringReviewError value)?  error,}){
final _that = this;
switch (_that) {
case RecurringReviewLoading() when loading != null:
return loading(_that);case RecurringReviewLoaded() when loaded != null:
return loaded(_that);case RecurringReviewEmpty() when empty != null:
return empty(_that);case RecurringReviewError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<PendingOccurrence> pending)?  loaded,TResult Function()?  empty,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RecurringReviewLoading() when loading != null:
return loading();case RecurringReviewLoaded() when loaded != null:
return loaded(_that.pending);case RecurringReviewEmpty() when empty != null:
return empty();case RecurringReviewError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<PendingOccurrence> pending)  loaded,required TResult Function()  empty,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case RecurringReviewLoading():
return loading();case RecurringReviewLoaded():
return loaded(_that.pending);case RecurringReviewEmpty():
return empty();case RecurringReviewError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<PendingOccurrence> pending)?  loaded,TResult? Function()?  empty,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case RecurringReviewLoading() when loading != null:
return loading();case RecurringReviewLoaded() when loaded != null:
return loaded(_that.pending);case RecurringReviewEmpty() when empty != null:
return empty();case RecurringReviewError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class RecurringReviewLoading implements RecurringReviewState {
  const RecurringReviewLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringReviewLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RecurringReviewState.loading()';
}


}




/// @nodoc


class RecurringReviewLoaded implements RecurringReviewState {
  const RecurringReviewLoaded({required final  List<PendingOccurrence> pending}): _pending = pending;
  

 final  List<PendingOccurrence> _pending;
 List<PendingOccurrence> get pending {
  if (_pending is EqualUnmodifiableListView) return _pending;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pending);
}


/// Create a copy of RecurringReviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringReviewLoadedCopyWith<RecurringReviewLoaded> get copyWith => _$RecurringReviewLoadedCopyWithImpl<RecurringReviewLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringReviewLoaded&&const DeepCollectionEquality().equals(other._pending, _pending));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_pending));

@override
String toString() {
  return 'RecurringReviewState.loaded(pending: $pending)';
}


}

/// @nodoc
abstract mixin class $RecurringReviewLoadedCopyWith<$Res> implements $RecurringReviewStateCopyWith<$Res> {
  factory $RecurringReviewLoadedCopyWith(RecurringReviewLoaded value, $Res Function(RecurringReviewLoaded) _then) = _$RecurringReviewLoadedCopyWithImpl;
@useResult
$Res call({
 List<PendingOccurrence> pending
});




}
/// @nodoc
class _$RecurringReviewLoadedCopyWithImpl<$Res>
    implements $RecurringReviewLoadedCopyWith<$Res> {
  _$RecurringReviewLoadedCopyWithImpl(this._self, this._then);

  final RecurringReviewLoaded _self;
  final $Res Function(RecurringReviewLoaded) _then;

/// Create a copy of RecurringReviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pending = null,}) {
  return _then(RecurringReviewLoaded(
pending: null == pending ? _self._pending : pending // ignore: cast_nullable_to_non_nullable
as List<PendingOccurrence>,
  ));
}


}

/// @nodoc


class RecurringReviewEmpty implements RecurringReviewState {
  const RecurringReviewEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringReviewEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RecurringReviewState.empty()';
}


}




/// @nodoc


class RecurringReviewError implements RecurringReviewState {
  const RecurringReviewError(this.failure);
  

 final  Failure failure;

/// Create a copy of RecurringReviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringReviewErrorCopyWith<RecurringReviewError> get copyWith => _$RecurringReviewErrorCopyWithImpl<RecurringReviewError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringReviewError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'RecurringReviewState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $RecurringReviewErrorCopyWith<$Res> implements $RecurringReviewStateCopyWith<$Res> {
  factory $RecurringReviewErrorCopyWith(RecurringReviewError value, $Res Function(RecurringReviewError) _then) = _$RecurringReviewErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$RecurringReviewErrorCopyWithImpl<$Res>
    implements $RecurringReviewErrorCopyWith<$Res> {
  _$RecurringReviewErrorCopyWithImpl(this._self, this._then);

  final RecurringReviewError _self;
  final $Res Function(RecurringReviewError) _then;

/// Create a copy of RecurringReviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(RecurringReviewError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
