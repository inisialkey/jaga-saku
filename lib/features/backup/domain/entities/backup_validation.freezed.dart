// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_validation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackupValidation {

 bool get valid; BackupValidationReason get reason; BackupData? get data; int? get exportedAt;
/// Create a copy of BackupValidation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupValidationCopyWith<BackupValidation> get copyWith => _$BackupValidationCopyWithImpl<BackupValidation>(this as BackupValidation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupValidation&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.data, data) || other.data == data)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt));
}


@override
int get hashCode => Object.hash(runtimeType,valid,reason,data,exportedAt);

@override
String toString() {
  return 'BackupValidation(valid: $valid, reason: $reason, data: $data, exportedAt: $exportedAt)';
}


}

/// @nodoc
abstract mixin class $BackupValidationCopyWith<$Res>  {
  factory $BackupValidationCopyWith(BackupValidation value, $Res Function(BackupValidation) _then) = _$BackupValidationCopyWithImpl;
@useResult
$Res call({
 bool valid, BackupValidationReason reason, BackupData? data, int? exportedAt
});


$BackupDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$BackupValidationCopyWithImpl<$Res>
    implements $BackupValidationCopyWith<$Res> {
  _$BackupValidationCopyWithImpl(this._self, this._then);

  final BackupValidation _self;
  final $Res Function(BackupValidation) _then;

/// Create a copy of BackupValidation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? valid = null,Object? reason = null,Object? data = freezed,Object? exportedAt = freezed,}) {
  return _then(_self.copyWith(
valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as BackupValidationReason,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BackupData?,exportedAt: freezed == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of BackupValidation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $BackupDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [BackupValidation].
extension BackupValidationPatterns on BackupValidation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupValidation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupValidation() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupValidation value)  $default,){
final _that = this;
switch (_that) {
case _BackupValidation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupValidation value)?  $default,){
final _that = this;
switch (_that) {
case _BackupValidation() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool valid,  BackupValidationReason reason,  BackupData? data,  int? exportedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupValidation() when $default != null:
return $default(_that.valid,_that.reason,_that.data,_that.exportedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool valid,  BackupValidationReason reason,  BackupData? data,  int? exportedAt)  $default,) {final _that = this;
switch (_that) {
case _BackupValidation():
return $default(_that.valid,_that.reason,_that.data,_that.exportedAt);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool valid,  BackupValidationReason reason,  BackupData? data,  int? exportedAt)?  $default,) {final _that = this;
switch (_that) {
case _BackupValidation() when $default != null:
return $default(_that.valid,_that.reason,_that.data,_that.exportedAt);case _:
  return null;

}
}

}

/// @nodoc


class _BackupValidation implements BackupValidation {
  const _BackupValidation({required this.valid, required this.reason, this.data, this.exportedAt});
  

@override final  bool valid;
@override final  BackupValidationReason reason;
@override final  BackupData? data;
@override final  int? exportedAt;

/// Create a copy of BackupValidation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupValidationCopyWith<_BackupValidation> get copyWith => __$BackupValidationCopyWithImpl<_BackupValidation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupValidation&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.data, data) || other.data == data)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt));
}


@override
int get hashCode => Object.hash(runtimeType,valid,reason,data,exportedAt);

@override
String toString() {
  return 'BackupValidation(valid: $valid, reason: $reason, data: $data, exportedAt: $exportedAt)';
}


}

/// @nodoc
abstract mixin class _$BackupValidationCopyWith<$Res> implements $BackupValidationCopyWith<$Res> {
  factory _$BackupValidationCopyWith(_BackupValidation value, $Res Function(_BackupValidation) _then) = __$BackupValidationCopyWithImpl;
@override @useResult
$Res call({
 bool valid, BackupValidationReason reason, BackupData? data, int? exportedAt
});


@override $BackupDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$BackupValidationCopyWithImpl<$Res>
    implements _$BackupValidationCopyWith<$Res> {
  __$BackupValidationCopyWithImpl(this._self, this._then);

  final _BackupValidation _self;
  final $Res Function(_BackupValidation) _then;

/// Create a copy of BackupValidation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? valid = null,Object? reason = null,Object? data = freezed,Object? exportedAt = freezed,}) {
  return _then(_BackupValidation(
valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as BackupValidationReason,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BackupData?,exportedAt: freezed == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of BackupValidation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $BackupDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
