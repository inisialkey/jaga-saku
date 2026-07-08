// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PermissionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PermissionState()';
}


}

/// @nodoc
class $PermissionStateCopyWith<$Res>  {
$PermissionStateCopyWith(PermissionState _, $Res Function(PermissionState) __);
}


/// Adds pattern-matching-related methods to [PermissionState].
extension PermissionStatePatterns on PermissionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PermissionStateInitial value)?  initial,TResult Function( PermissionStateGranted value)?  granted,TResult Function( PermissionStateDenied value)?  denied,TResult Function( PermissionStatePermanentlyDenied value)?  permanentlyDenied,TResult Function( PermissionStateRestricted value)?  restricted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PermissionStateInitial() when initial != null:
return initial(_that);case PermissionStateGranted() when granted != null:
return granted(_that);case PermissionStateDenied() when denied != null:
return denied(_that);case PermissionStatePermanentlyDenied() when permanentlyDenied != null:
return permanentlyDenied(_that);case PermissionStateRestricted() when restricted != null:
return restricted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PermissionStateInitial value)  initial,required TResult Function( PermissionStateGranted value)  granted,required TResult Function( PermissionStateDenied value)  denied,required TResult Function( PermissionStatePermanentlyDenied value)  permanentlyDenied,required TResult Function( PermissionStateRestricted value)  restricted,}){
final _that = this;
switch (_that) {
case PermissionStateInitial():
return initial(_that);case PermissionStateGranted():
return granted(_that);case PermissionStateDenied():
return denied(_that);case PermissionStatePermanentlyDenied():
return permanentlyDenied(_that);case PermissionStateRestricted():
return restricted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PermissionStateInitial value)?  initial,TResult? Function( PermissionStateGranted value)?  granted,TResult? Function( PermissionStateDenied value)?  denied,TResult? Function( PermissionStatePermanentlyDenied value)?  permanentlyDenied,TResult? Function( PermissionStateRestricted value)?  restricted,}){
final _that = this;
switch (_that) {
case PermissionStateInitial() when initial != null:
return initial(_that);case PermissionStateGranted() when granted != null:
return granted(_that);case PermissionStateDenied() when denied != null:
return denied(_that);case PermissionStatePermanentlyDenied() when permanentlyDenied != null:
return permanentlyDenied(_that);case PermissionStateRestricted() when restricted != null:
return restricted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  granted,TResult Function()?  denied,TResult Function()?  permanentlyDenied,TResult Function()?  restricted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PermissionStateInitial() when initial != null:
return initial();case PermissionStateGranted() when granted != null:
return granted();case PermissionStateDenied() when denied != null:
return denied();case PermissionStatePermanentlyDenied() when permanentlyDenied != null:
return permanentlyDenied();case PermissionStateRestricted() when restricted != null:
return restricted();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  granted,required TResult Function()  denied,required TResult Function()  permanentlyDenied,required TResult Function()  restricted,}) {final _that = this;
switch (_that) {
case PermissionStateInitial():
return initial();case PermissionStateGranted():
return granted();case PermissionStateDenied():
return denied();case PermissionStatePermanentlyDenied():
return permanentlyDenied();case PermissionStateRestricted():
return restricted();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  granted,TResult? Function()?  denied,TResult? Function()?  permanentlyDenied,TResult? Function()?  restricted,}) {final _that = this;
switch (_that) {
case PermissionStateInitial() when initial != null:
return initial();case PermissionStateGranted() when granted != null:
return granted();case PermissionStateDenied() when denied != null:
return denied();case PermissionStatePermanentlyDenied() when permanentlyDenied != null:
return permanentlyDenied();case PermissionStateRestricted() when restricted != null:
return restricted();case _:
  return null;

}
}

}

/// @nodoc


class PermissionStateInitial implements PermissionState {
  const PermissionStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PermissionState.initial()';
}


}




/// @nodoc


class PermissionStateGranted implements PermissionState {
  const PermissionStateGranted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionStateGranted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PermissionState.granted()';
}


}




/// @nodoc


class PermissionStateDenied implements PermissionState {
  const PermissionStateDenied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionStateDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PermissionState.denied()';
}


}




/// @nodoc


class PermissionStatePermanentlyDenied implements PermissionState {
  const PermissionStatePermanentlyDenied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionStatePermanentlyDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PermissionState.permanentlyDenied()';
}


}




/// @nodoc


class PermissionStateRestricted implements PermissionState {
  const PermissionStateRestricted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionStateRestricted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PermissionState.restricted()';
}


}




// dart format on
