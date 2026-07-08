// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_name_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditNameState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditNameState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditNameState()';
}


}

/// @nodoc
class $EditNameStateCopyWith<$Res>  {
$EditNameStateCopyWith(EditNameState _, $Res Function(EditNameState) __);
}


/// Adds pattern-matching-related methods to [EditNameState].
extension EditNameStatePatterns on EditNameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EditNameStateLoading value)?  loading,TResult Function( EditNameStateLoaded value)?  loaded,TResult Function( EditNameStateSubmitting value)?  submitting,TResult Function( EditNameStateSuccess value)?  success,TResult Function( EditNameStateFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EditNameStateLoading() when loading != null:
return loading(_that);case EditNameStateLoaded() when loaded != null:
return loaded(_that);case EditNameStateSubmitting() when submitting != null:
return submitting(_that);case EditNameStateSuccess() when success != null:
return success(_that);case EditNameStateFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EditNameStateLoading value)  loading,required TResult Function( EditNameStateLoaded value)  loaded,required TResult Function( EditNameStateSubmitting value)  submitting,required TResult Function( EditNameStateSuccess value)  success,required TResult Function( EditNameStateFailure value)  failure,}){
final _that = this;
switch (_that) {
case EditNameStateLoading():
return loading(_that);case EditNameStateLoaded():
return loaded(_that);case EditNameStateSubmitting():
return submitting(_that);case EditNameStateSuccess():
return success(_that);case EditNameStateFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EditNameStateLoading value)?  loading,TResult? Function( EditNameStateLoaded value)?  loaded,TResult? Function( EditNameStateSubmitting value)?  submitting,TResult? Function( EditNameStateSuccess value)?  success,TResult? Function( EditNameStateFailure value)?  failure,}){
final _that = this;
switch (_that) {
case EditNameStateLoading() when loading != null:
return loading(_that);case EditNameStateLoaded() when loaded != null:
return loaded(_that);case EditNameStateSubmitting() when submitting != null:
return submitting(_that);case EditNameStateSuccess() when success != null:
return success(_that);case EditNameStateFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( String name)?  loaded,TResult Function()?  submitting,TResult Function()?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EditNameStateLoading() when loading != null:
return loading();case EditNameStateLoaded() when loaded != null:
return loaded(_that.name);case EditNameStateSubmitting() when submitting != null:
return submitting();case EditNameStateSuccess() when success != null:
return success();case EditNameStateFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( String name)  loaded,required TResult Function()  submitting,required TResult Function()  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case EditNameStateLoading():
return loading();case EditNameStateLoaded():
return loaded(_that.name);case EditNameStateSubmitting():
return submitting();case EditNameStateSuccess():
return success();case EditNameStateFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( String name)?  loaded,TResult? Function()?  submitting,TResult? Function()?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case EditNameStateLoading() when loading != null:
return loading();case EditNameStateLoaded() when loaded != null:
return loaded(_that.name);case EditNameStateSubmitting() when submitting != null:
return submitting();case EditNameStateSuccess() when success != null:
return success();case EditNameStateFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class EditNameStateLoading implements EditNameState {
  const EditNameStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditNameStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditNameState.loading()';
}


}




/// @nodoc


class EditNameStateLoaded implements EditNameState {
  const EditNameStateLoaded(this.name);
  

 final  String name;

/// Create a copy of EditNameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditNameStateLoadedCopyWith<EditNameStateLoaded> get copyWith => _$EditNameStateLoadedCopyWithImpl<EditNameStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditNameStateLoaded&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'EditNameState.loaded(name: $name)';
}


}

/// @nodoc
abstract mixin class $EditNameStateLoadedCopyWith<$Res> implements $EditNameStateCopyWith<$Res> {
  factory $EditNameStateLoadedCopyWith(EditNameStateLoaded value, $Res Function(EditNameStateLoaded) _then) = _$EditNameStateLoadedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$EditNameStateLoadedCopyWithImpl<$Res>
    implements $EditNameStateLoadedCopyWith<$Res> {
  _$EditNameStateLoadedCopyWithImpl(this._self, this._then);

  final EditNameStateLoaded _self;
  final $Res Function(EditNameStateLoaded) _then;

/// Create a copy of EditNameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(EditNameStateLoaded(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EditNameStateSubmitting implements EditNameState {
  const EditNameStateSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditNameStateSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditNameState.submitting()';
}


}




/// @nodoc


class EditNameStateSuccess implements EditNameState {
  const EditNameStateSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditNameStateSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditNameState.success()';
}


}




/// @nodoc


class EditNameStateFailure implements EditNameState {
  const EditNameStateFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of EditNameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditNameStateFailureCopyWith<EditNameStateFailure> get copyWith => _$EditNameStateFailureCopyWithImpl<EditNameStateFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditNameStateFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'EditNameState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $EditNameStateFailureCopyWith<$Res> implements $EditNameStateCopyWith<$Res> {
  factory $EditNameStateFailureCopyWith(EditNameStateFailure value, $Res Function(EditNameStateFailure) _then) = _$EditNameStateFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$EditNameStateFailureCopyWithImpl<$Res>
    implements $EditNameStateFailureCopyWith<$Res> {
  _$EditNameStateFailureCopyWithImpl(this._self, this._then);

  final EditNameStateFailure _self;
  final $Res Function(EditNameStateFailure) _then;

/// Create a copy of EditNameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(EditNameStateFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
